param(
    [Parameter(
        mandatory = $true
    )]
    [string]    $ImagePath
)

$Sizes = 256, 128, 64, 48, 32, 24, 16

$InkScapePath = 'C:\Program Files\Inkscape\bin\inkscape.com'
$ImgMagickPath = 'C:\Program Files\ImageMagick-7.1.0-Q16-HDRI\magick.exe'

$ImageRootPath = Split-Path -LiteralPath $ImagePath
$ImageName = [System.IO.Path]::GetFileNameWithoutExtension($ImagePath) 
New-Item -ItemType Directory -Force -Path $ImageRootPath\_TEMP | Out-Null

foreach ($size in $Sizes)
{
    &$InkScapePath --export-type=png --export-overwrite --export-area-page --export-background-opacity=0 --export-filename=$ImageRootPath\_TEMP\$size.png -w $size -h $size $ImagePath
}

&$ImgMagickPath convert $ImageRootPath\_TEMP\256.png $ImageRootPath\_TEMP\128.png $ImageRootPath\_TEMP\64.png $ImageRootPath\_TEMP\48.png $ImageRootPath\_TEMP\32.png $ImageRootPath\_TEMP\24.png $ImageRootPath\_TEMP\16.png $ImageRootPath\$ImageName.ico

Remove-Item -Force -Recurse -LiteralPath $ImageRootPath\_TEMP