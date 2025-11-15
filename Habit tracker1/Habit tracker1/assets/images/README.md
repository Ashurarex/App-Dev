# App Icon Assets

## Required Files

To generate app icons, you need to create:

1. **app_icon.png** - Main app icon (1024x1024px)
   - Should be a square image
   - Recommended: Gradient background with checkmark or habit tracker symbol
   - Colors: Indigo (#6366F1) to Violet (#8B5CF6)

2. **app_icon_foreground.png** - Adaptive icon foreground (1024x1024px)
   - Should have transparent background
   - Contains the main icon/symbol
   - Will be placed on top of the adaptive icon background

## Quick Setup

1. Create or download your icon designs
2. Save them in this directory (`assets/images/`)
3. Run: `flutter pub run flutter_launcher_icons`

The package will automatically generate all required sizes for Android and iOS.

## Design Tips

- Use a simple, recognizable symbol (checkmark, calendar, or habit tracker icon)
- Keep the design clean and modern
- Ensure good contrast for visibility
- Test on both light and dark backgrounds

