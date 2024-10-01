# Image to Icon Converter PowerShell Script

This PowerShell script converts an image (in formats such as SVG) into a multi-size ICO icon. The script uses [Inkscape](https://inkscape.org/) to generate PNG images at different resolutions and [ImageMagick](https://imagemagick.org/) to combine these images into a single `.ico` file. Temporary files created during the process are automatically cleaned up.

## Features
- Generates icons with multiple resolutions: 256x256, 128x128, 64x64, 48x48, 32x32, 24x24, and 16x16 pixels.
- Automatically finds `magick.exe` (ImageMagick) in the system's `PATH` or a common installation directory.
- Uses Inkscape to handle SVG image conversion.
- Cleans up temporary files after conversion.

## Requirements
- **Inkscape**: The script uses Inkscape to export PNG files. You need to have Inkscape installed and accessible at the path `C:\Program Files\Inkscape\bin\inkscape.com`. Adjust the path if your installation is located elsewhere.
- **ImageMagick**: The script uses ImageMagick’s `magick.exe` command to generate ICO files. It attempts to find `magick.exe` in your system's `PATH`. If not found, it falls back to a common installation path: `C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe`.

## How it works
1. **Input Image**: The script takes a single image file (such as an SVG) as input.
2. **Generate PNGs**: It uses Inkscape to generate PNGs in different sizes (256x256, 128x128, 64x64, 48x48, 32x32, 24x24, and 16x16 pixels).
3. **Create ICO**: The script then uses ImageMagick to combine the PNG files into a single `.ico` file.
4. **Clean-up**: Finally, it cleans up the temporary directory where the PNG files were stored.

## Usage

### Syntax
```bash
.\ConvertToIcon.ps1 -ImagePath <path_to_image_file>
```

### Example
```bash
.\ConvertToIcon.ps1 -ImagePath "C:\Images\logo.svg"
```
This command will convert the `logo.svg` image into a `.ico` file containing multiple resolutions, saved in the same directory as the original image.

### Parameters
- `-ImagePath`: The full path to the image file (SVG or another format supported by Inkscape).