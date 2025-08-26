# SRET Design System

## Overview
The SRET (Sri Ramakrishna Engineering & Technology) app design system implements a modern, Apple-inspired interface with liquid glass morphism effects and a warm peach-cream color palette. This system emphasizes elegance, accessibility, and user experience while maintaining the institutional identity.

## Color Palette

### Primary Colors
```dart
// SRET Brand Colors
static const Color sretPrimary = Color(0xFF7A0E2A);      // Burgundy (Primary brand)
static const Color sretAccent = Color(0xFFDFA06E);       // Copper (Secondary accent)
static const Color sretText = Color(0xFF1F1B16);         // Rich dark text
static const Color sretTextSecondary = Color(0xFF4B5563); // Muted secondary text
```

### Background System
```dart
// Global Peach-Cream Gradient Background
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFF7E9), // Warm cream
    Color(0xFFFFE1CF), // Soft peach
    Color(0xFFF8B4A6), // Peachy pink
  ],
  stops: [0.0, 0.5, 1.0],
)

// Radial Highlight Overlay
RadialGradient(
  center: Alignment.topRight,
  radius: 1.2,
  colors: [
    Color(0x1AFFFFFF), // White 10% opacity
    Color(0x00FFFFFF), // Transparent
  ],
)
```

### Surface Colors
```dart
static const Color sretBg = Color(0xFFFAF6F1);           // SRET/BG (Legacy)
static const Color sretSurface = Color(0xFFF7EFE6);      // SRET/Surface
static const Color sretDivider = Color(0xFFE7DED3);      // SRET/Divider
```

## Apple Liquid Glass System

### Core Glass Effects
The design system implements authentic Apple-style glass morphism with the following specifications:

#### AppleLiquidGlass Component
```dart
// Backdrop blur with sigma 24.0 for authentic iOS feel
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x33FFFFFF), // White 20% opacity
          Color(0x0FFFFFFF), // White 6% opacity
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Color(0x38FFFFFF), // White 22% border
        width: 1,
      ),
    ),
  ),
)
```

#### Animated Liquid Sheen
- **Duration**: 7 seconds per cycle
- **Effect**: Diagonal sweep with opacity gradient
- **Colors**: White to transparent gradient overlay
- **Animation**: Continuous linear motion with easing

### Glass Color Tokens
```dart
static const Color glassFrost = Color(0x29FFFFFF);       // White @16%
static const Color glassBorder = Color(0x38FFFFFF);      // White @22%
static const Color glassShadow = Color(0x1A7A0E2A);      // Burgundy @10%
```

## Navigation System

### Liquid Pill Navigation
The primary navigation uses a floating pill design with liquid glass effects:

#### Design Specifications
- **Shape**: Rounded rectangle with 28px radius
- **Height**: 64px
- **Backdrop**: Blur(σ=24) + gradient overlay
- **Items**: 5 navigation chips (Today, Timetable, Calendar, Inbox, Department)
- **Positioning**: Bottom floating with safe area insets

#### Navigation Chips
```dart
// Individual navigation items
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: isActive ? activeGlassDecoration : inactiveDecoration,
  child: Icon + Text layout
)
```

### Active States
- **Background**: Enhanced glass effect with stronger opacity
- **Typography**: Bold weight for active items
- **Animation**: Smooth transitions with 200ms duration

## Typography System

### Font Family
**Primary**: Google Fonts Roboto Serif
- Elegant serif font for institutional feel
- Excellent readability across all sizes
- Professional academic appearance

### Type Scale
```dart
// Headings
headlineLarge:   32px / 1.25 line height / Bold
headlineMedium:  28px / 1.3 line height  / Bold
headlineSmall:   24px / 1.33 line height / SemiBold

// Body Text
bodyLarge:       16px / 1.5 line height  / Regular
bodyMedium:      14px / 1.43 line height / Regular
bodySmall:       12px / 1.33 line height / Regular

// Labels
labelLarge:      14px / 1.43 line height / Medium
labelMedium:     12px / 1.33 line height / Medium
labelSmall:      10px / 1.6 line height  / Medium
```

## Component Library

### Buttons
#### Primary Button
- **Background**: SRET Primary (Burgundy)
- **Text**: White
- **Radius**: 12px
- **Padding**: 16px horizontal, 12px vertical
- **Animation**: Scale 0.95 on press

#### Secondary Button
- **Background**: SRET Surface
- **Text**: SRET Primary
- **Border**: 1px SRET Divider
- **Same dimensions as primary**

### Form Fields
#### TextFormField
- **Background**: Transparent
- **Border**: Material 3 outline style
- **Label**: Floating label with SRET colors
- **Focus**: SRET Primary border color
- **Icons**: Outlined style with SRET theming

### Cards and Containers
#### Glass Card
```dart
AppleLiquidGlass(
  child: Container(
    padding: EdgeInsets.all(24),
    child: content,
  ),
)
```

#### Standard Card
- **Background**: SRET Surface
- **Radius**: 16px
- **Elevation**: 2dp with SRET shadow colors
- **Padding**: 20px

## Layout Principles

### Global Background
All screens use the `AppBackground` widget that provides:
1. Base peach-cream gradient
2. Radial highlight overlay
3. Consistent visual foundation

### Transparent Scaffolds
```dart
Scaffold(
  backgroundColor: Colors.transparent,
  body: content,
)
```

### Content Containers
- Maximum width: 420px for forms
- Centered layout with responsive padding
- Glass morphism for elevation

## Animation Guidelines

### Micro-Interactions
- **Duration**: 200-300ms for UI feedback
- **Easing**: Curves.easeOut for natural feel
- **Scale**: 0.95-1.0 for button presses

### Page Transitions
- **Fade In**: 300ms with easeOut curve
- **Slide Animations**: 0.15 offset with 300ms duration
- **Staggered Reveals**: 100ms delays between elements

### Liquid Effects
- **Sheen Animation**: 7 second continuous cycle
- **Blur Transitions**: 200ms for focus states
- **Glass Morphing**: Smooth opacity changes

## Accessibility

### Color Contrast
- All text meets WCAG 2.1 AA standards
- Primary text: 4.5:1 minimum contrast ratio
- Secondary text: 3:1 minimum contrast ratio

### Touch Targets
- Minimum 44px × 44px for all interactive elements
- Adequate spacing between touch targets
- Visual feedback for all interactions

### Screen Reader Support
- Semantic markup with proper roles
- Descriptive labels for all controls
- Logical navigation order

## Implementation Notes

### Key Files
- `lib/theme/app_background.dart` - Global background system
- `lib/features/shared/apple_liquid_glass.dart` - Core glass component
- `lib/features/shared/liquid_pill_nav.dart` - Navigation system
- `lib/theme/app_theme.dart` - Color tokens and theme configuration

### Usage Examples
```dart
// Apply global background
MaterialApp.router(
  builder: (context, child) => AppBackground(
    child: child ?? const SizedBox(),
  ),
)

// Create glass card
AppleLiquidGlass(
  child: Container(
    padding: const EdgeInsets.all(24),
    child: YourContent(),
  ),
)

// Transparent page background
Scaffold(
  backgroundColor: Colors.transparent,
  body: YourPageContent(),
)
```

## Performance Considerations

### Backdrop Filters
- Limit concurrent backdrop filters for performance
- Use `ClipRect` to constrain blur regions
- Consider device capabilities for blur intensity

### Animations
- Use `AnimationController` disposal properly
- Implement `WidgetsBindingObserver` for lifecycle management
- Optimize animation curves for 60fps performance

### Memory Management
- Dispose controllers in widget lifecycle
- Use `const` constructors where possible
- Optimize image assets for web deployment

## Future Enhancements

### Planned Features
1. **Dark Mode Support**: Adaptive color schemes
2. **Custom Themes**: User preference system
3. **Enhanced Animations**: More sophisticated micro-interactions
4. **Accessibility Plus**: Voice control integration

### Design Evolution
- Seasonal color variations
- Dynamic background systems
- Advanced glass morphism effects
- Gesture-based interactions

---

This design system ensures consistency, beauty, and usability across the entire SRET application while maintaining the distinctive Apple-inspired aesthetic with institutional branding.
