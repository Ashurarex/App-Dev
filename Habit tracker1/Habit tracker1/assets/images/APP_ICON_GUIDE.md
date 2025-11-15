# App Icon Setup Guide

## Creating the App Icon

To create a beautiful app icon for Habitual, follow these steps:

### Option 1: Using Online Tools (Recommended)
1. Go to https://www.canva.com or https://www.figma.com
2. Create a 1024x1024px square design
3. Design should include:
   - A checkmark or habit tracker symbol
   - Gradient colors: Indigo (#6366F1) to Violet (#8B5CF6)
   - Modern, clean design
   - Rounded corners (optional)

### Option 2: Using Flutter Icon Generator
1. Create a 1024x1024px PNG image
2. Save it as `app_icon.png` in `assets/images/`
3. For adaptive icon foreground, create a 1024x1024px PNG with transparent background
4. Save it as `app_icon_foreground.png` in `assets/images/`

### Generating Icons
After creating the icon files, run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all required icon sizes for Android and iOS.

## Icon Design Suggestions

- **Main Symbol**: Checkmark circle or habit tracker icon
- **Colors**: Gradient from Indigo (#6366F1) to Violet (#8B5CF6)
- **Style**: Modern, minimalist, rounded
- **Background**: Solid color or subtle gradient

## Current Configuration

The app is configured to use:
- **Android**: Adaptive icon with indigo background (#6366F1)
- **iOS**: Standard app icon set
- **Image Path**: `assets/images/app_icon.png`
- **Foreground Path**: `assets/images/app_icon_foreground.png`

