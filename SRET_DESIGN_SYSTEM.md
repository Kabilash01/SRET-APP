# SRET App - Design System Documentation

## Overview
This Flutter app has been completely redesigned with the new **SRET Design System** featuring a sophisticated burgundy and copper color palette, Material 3 components, and premium glass morphism effects.

## 🎨 Design System

### Color Palette
- **Primary**: `#7A0E2A` (Burgundy) - Main brand color for buttons, headers, links
- **Accent**: `#DFA06E` (Copper) - Secondary accent color for highlights and interactions
- **Background**: `#FAF6F1` (Warm Cream) - Main app background
- **Surface**: `#F7EFE6` (Light Cream) - Card and surface backgrounds
- **Text Primary**: `#1F1B16` (Dark Brown) - Main text color
- **Text Secondary**: `#6B6B6B` (Gray) - Secondary text and labels
- **Divider**: `#E7DED3` (Light Brown) - Borders and dividers

### Typography
- **Font Family**: Roboto Serif (via Google Fonts)
- **Font Weights**: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)
- **Text Styles**: Material 3 typography scale adapted for SRET branding

## 🔧 Key Components

### LiquidGlass Component
Located: `lib/features/shared/liquid_glass.dart`

A premium animated glass morphism component featuring:
- **BackdropFilter** blur effect (18px)
- **Animated Sheen** gradient (360° rotation over 3 seconds)
- **Drift Animation** radial gradient movement
- **Border Radius** customization
- **Performance Optimization** with RepaintBoundary
- **Accessibility** respects system animation preferences

```dart
LiquidGlass(
  radius: BorderRadius.circular(20),
  child: YourContent(),
)
```

### Form Validators
Located: `lib/features/shared/validators.dart`

Comprehensive validation utilities:
- **validateSretEmail()** - Validates @sret.edu.in domain
- **validatePassword()** - Minimum 6 characters
- **validateFullName()** - Required field validation
- **validatePhone()** - 10-15 digit validation
- **validateEmpId()** - 3-20 alphanumeric validation

### Enhanced Auth Pages

#### 1. Login Page (`login_page.dart`)
- ✅ Updated with LiquidGlass container
- ✅ SRET email validation (@sret.edu.in)
- ✅ "Continue with Google" functionality maintained
- ✅ Smooth animations and micro-interactions
- ✅ Responsive design with max-width constraints

#### 2. Sign Up Page (`signup_page_new.dart`)
- ✅ Comprehensive registration form with all required fields:
  - Full Name
  - Employee ID
  - Phone Number
  - SRET Email (@sret.edu.in)
  - Password & Confirm Password
  - Department Selection (E01-E05 with full names)
  - Role Selection (DEAN, VICE DEAN, HOD, FACULTY, STAFF, etc.)
- ✅ Real-time form validation
- ✅ Terms & Privacy Policy checkbox
- ✅ Admin verification notice for senior roles
- ✅ Animated form submission with loading states

#### 3. Forgot Password Page (`forgot_password_page_sret.dart`)
- ✅ Two-state UI: Form → Success confirmation
- ✅ SRET email validation
- ✅ Reset link functionality via FakeAuthRepo
- ✅ Success state with resend option
- ✅ Elegant animations and transitions

## 🔄 Updated Components

### FakeAuthRepo
Enhanced with new methods:
- `createAccount()` - Handles registration with all user fields
- `sendResetEmail()` - Password reset functionality
- Proper async delays for realistic UX

### App Router
Updated routes:
- `/login` → LoginPage (updated)
- `/signup` → SignUpPage (new SRET version)
- `/forgot-password` → ForgotPasswordPageSret (new)

### Theme System
Complete Material 3 integration:
- Custom ColorScheme with SRET colors
- Roboto Serif typography throughout
- Consistent component styling
- Dark/light theme support foundation

## 🎯 Design Principles

### Visual Hierarchy
1. **Primary Actions** use burgundy (#7A0E2A)
2. **Secondary Actions** use copper accent (#DFA06E)
3. **Information** uses warm cream surfaces (#F7EFE6)
4. **Text** maintains high contrast ratios

### Animation Philosophy
- **Micro-interactions** enhance user feedback
- **Page transitions** use gentle slide and fade
- **Loading states** provide clear progress indication
- **Glass effects** add premium feel without distraction

### Accessibility
- High contrast color ratios
- Semantic labels on interactive elements
- Respect for system animation preferences
- Clear focus states and navigation

## 📱 Mobile-First Design
- Responsive layouts with max-width constraints
- Touch-friendly interactive elements (minimum 44px)
- Optimized for both portrait and landscape orientations
- Consistent spacing using 8px grid system

## 🚀 Implementation Notes

### Performance Optimizations
- RepaintBoundary on animated components
- Efficient state management
- Lazy loading of complex animations
- Optimized image and asset loading

### Code Organization
```
lib/
├── features/
│   ├── auth/          # Authentication pages
│   ├── shared/        # Reusable components
│   └── demo/          # Design system demo
├── theme/             # Theme configuration
└── core/              # Business logic
```

### Development Workflow
1. All new components follow SRET design tokens
2. LiquidGlass used for premium surface elements
3. Consistent animation timing (300ms for transitions)
4. Form validation using shared utilities

## 🔮 Future Enhancements
- Dark theme implementation
- Advanced glass effect customization
- Component animation presets
- Extended color palette for status states
- Advanced accessibility features

---

**SRET Design System** - Elevating the user experience with premium design and thoughtful interactions.
