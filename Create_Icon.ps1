param(
    [Parameter(
        mandatory = $true
    )]
    [string] $ImagePath
)

$Sizes = 256, 128, 64, 48, 32, 24, 16

$InkScapePath = 'C:\Program Files\Inkscape\bin\inkscape.com'

# Try to find magick.exe in the system PATH or common installation directories
try {
    $ImgMagickPath = (Get-Command magick.exe -ErrorAction SilentlyContinue).Path

    if (-not $ImgMagickPath) {
        # If not found in PATH, fall back to a common installation path
        $DefaultImgMagickPath = 'C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe'
        if (Test-Path $DefaultImgMagickPath) {
            $ImgMagickPath = $DefaultImgMagickPath
        } else {
            throw "magick.exe not found in system PATH or at '$DefaultImgMagickPath'."
        }
    }

    # Check if Inkscape executable exists
    if (-not (Test-Path $InkScapePath)) {
        throw "Inkscape executable not found at '$InkScapePath'. Please check the path."
    }

    # Check if the input image exists
    if (-not (Test-Path $ImagePath)) {
        throw "Image path '$ImagePath' does not exist."
    }

    # Get image root path and name
    $ImageRootPath = Split-Path -LiteralPath $ImagePath
    $ImageName = [System.IO.Path]::GetFileNameWithoutExtension($ImagePath)

    # Create temporary directory
    try {
        $tempDir = Join-Path -Path $ImageRootPath -ChildPath (New-Guid)
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    } catch {
        throw "Failed to create temporary directory at '$tempDir'. Error: $_"
    }

    # Export PNG files using Inkscape for different sizes
    foreach ($size in $Sizes) {
        try {
            &$InkScapePath --export-type=png --export-overwrite --export-area-page --export-background-opacity=0 --export-filename="$tempDir\$size.png" -w $size -h $size $ImagePath
        } catch {
            throw "Failed to export PNG for size $size. Error: $_"
        }
    }

    # Construct the list of PNG file paths based on the sizes
    $PngPaths = $Sizes | ForEach-Object { "$tempDir\$_" + ".png" }

    # Combine the images into an ICO file using ImageMagick
    try {
        &$ImgMagickPath convert $PngPaths "$ImageRootPath\$ImageName.ico"
    } catch {
        throw "Failed to create ICO file. Error: $_"
    }

} catch {
    # Handle errors
    Write-Host "An error occurred: $_" -ForegroundColor Red
} finally {
    # Clean up temporary files
    if (Test-Path $tempDir) {
        try {
            Remove-Item -Force -Recurse -LiteralPath $tempDir
            Write-Host "Temporary files cleaned up."
        } catch {
            Write-Host "Failed to clean up temporary files. Error: $_" -ForegroundColor Yellow
        }
    }
}
