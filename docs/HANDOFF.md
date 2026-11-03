# 📘 HANDOFF.md — Evently Master Project Manual & Production Handoff

> **Project:** Evently — Modern Event Planning & Management Application (Flutter)  
> **Framework:** Based strictly on `ENGINEERING_FRAMEWORK.md` & `AGENTS.md`  
> **Status:** Production-Ready & Verified (`101/101` tests passing, `0` analyzer issues)  
> **Target Platforms:** Android & iOS (Offline-First, Localization & Theme Adaptive)  

---

## 🏛️ 1. System Overview & Architecture

Evently is engineered following the **Feature-First Clean Architecture** pattern, providing clear boundaries, modular scalability, and deterministic state management using `provider`.

```
lib/
├── l10n/                                   # Localization Engine
│   └── app_localizations.dart              # Dual-language dictionaries (AR/EN) & delegates
├── models/                                 # Domain & Data Models (Equatable & Serializable)
│   ├── event_model.dart                    # Event entity, Category Enum, JSON serialization
│   └── user_model.dart                     # User entity, session credentials
├── providers/                              # State Management (ChangeNotifier Providers)
│   ├── app_auth_provider.dart              # User auth, Google chooser & local DB persistence
│   ├── app_events_provider.dart            # Events CRUD, category filtering & favorites
│   ├── app_language_provider.dart          # Locale management (AR / EN) with SharedPreferences
│   └── app_theme_provider.dart             # ThemeMode management (Light / Dark)
├── screens/                                # Presentation Layer (Screens, Tabs, Widgets)
│   ├── auth/                               # Login, Register, Forget Password, Google BottomSheet
│   ├── event/                              # CreateEventScreen, EditEventScreen, EventDetailsScreen
│   ├── favorites/                          # FavoritesTab with live instant search
│   ├── home/                               # HomeScreen, HomeHeader, EventCard, CategorySelector
│   ├── main_layout/                        # MainLayoutScreen & CustomBottomNavBar (Notched FAB)
│   ├── map/                                # MapTab, MapEventCard, and carousel discovery
│   ├── onboarding/                         # OnboardingScreen (3-page carousel) & OnboardingSetupScreen
│   ├── profile/                            # ProfileTab, LanguageBottomSheet, ThemeBottomSheet
│   └── splash/                             # SplashScreen with branded Route logo & route check
├── utils/                                  # Design System & Constants (Single Source of Truth)
│   ├── app_color.dart                      # Color palette, semantic states, gradients
│   ├── app_images.dart                     # Vector SVGs and high-resolution raster assets
│   ├── app_routes.dart                     # Centralized typed route names
│   ├── app_style.dart                      # Typography scale powered by Google Fonts
│   └── app_theme.dart                      # ThemeData configurations for Light and Dark modes
└── widgets/                                # Reusable UI Components
    ├── custom_elevated_button.dart         # Standard branded buttons with loading state
    ├── custom_text_field.dart              # Standard input fields with validation and icons
    └── or_divider_widget.dart              # Branded divider with localized separator text
```

### 🧠 State Management Architecture (`Provider`)
1. **`AppAuthProvider`**:
   - Manages authentication state (`currentUser`, `isAuthenticated`).
   - Implements native credential sign-in, registration, and password recovery.
   - Implements Google Sign-In with an interactive account selector (`GoogleSignInBottomSheet`) backed by persistent mock storage (`registered_users_db`) in `SharedPreferences`.
2. **`AppEventsProvider`**:
   - Manages full event lifecycle (Create, Read, Update, Delete).
   - Provides reactive category filtering and instant favorite toggling.
   - Serializes events state to JSON in local storage for offline resilience.
3. **`AppThemeProvider`**:
   - Manages `ThemeMode.light` and `ThemeMode.dark`.
   - Persists user preferences and immediately updates the widget tree.
4. **`AppLanguageProvider`**:
   - Manages `Locale('en')` and `Locale('ar')`.
   - Adapts UI layout direction (LTR/RTL) across the entire application.

---

## 🎨 2. Design System Fidelity

The application strictly implements the design system defined in `lib/utils/` without magic constants or unapproved styling:

- **Colors ([`AppColor`](file:///d:/NCT/NCT-4/Mobile%20Programming%20II/Lab/evently/lib/utils/app_color.dart)):**
  - Primary Brand: `#5669FF` (Light Primary), `#101127` (Dark Background), `#5669FF` (Dark Primary).
  - Semantic: Error/Red (`#FF5659`), Light Gray (`#7B7B7B`), White (`#FFFFFF`), Off-White (`#F2FEFF`).
- **Typography ([`AppStyle`](file:///d:/NCT/NCT-4/Mobile%20Programming%20II/Lab/evently/lib/utils/app_style.dart)):**
  - Built with `GoogleFonts.inter` and `GoogleFonts.jockeyOne`.
  - Comprehensive typographic scale: Display, Title, Headline, Body, and Label styles.
- **Theming ([`AppTheme`](file:///d:/NCT/NCT-4/Mobile%20Programming%20II/Lab/evently/lib/utils/app_theme.dart)):**
  - Fully articulated `ThemeData` for both Light and Dark modes.
  - Consistent elevated button themes, input decoration themes, app bar themes, and bottom navigation bar themes.
- **Assets ([`AppImages`](file:///d:/NCT/NCT-4/Mobile%20Programming%20II/Lab/evently/lib/utils/app_images.dart)):**
  - Scalable vector graphics (SVGs): Logo, Route branding, Google icon, Compass, Navigation tabs, Calendar, Clock, Location pin, Edit, Delete.
  - High-resolution banners: `birthday_banner.png`, `sport_banner.png`, `meeting_banner.png`, `book_club_banner.png`, `user_avatar.png`, and `map_preview.png`.
- **Routing ([`AppRoutes`](file:///d:/NCT/NCT-4/Mobile%20Programming%20II/Lab/evently/lib/utils/app_routes.dart)):**
  - Centralized, strongly-typed route table covering the complete application navigation hierarchy.

---

## 🚀 3. Implemented Feature Matrix

| Feature | Key Components | Description |
| :--- | :--- | :--- |
| **Splash & Onboarding** | `SplashScreen`, `OnboardingSetupScreen`, `OnboardingScreen` | Branded splash screen, initial locale/theme selector, and 3-page interactive onboarding carousel with persistence. |
| **Authentication** | `LoginScreen`, `RegisterScreen`, `ForgetPasswordScreen` | Complete form validation, password visibility toggle, session persistence, and logout flow. |
| **Google Sign-In** | `GoogleSignInBottomSheet`, `AppAuthProvider` | Realistic Google account picker bottom sheet, dynamic account creation, and immediate authenticated session creation. |
| **Main Navigation Shell** | `MainLayoutScreen`, `CustomBottomNavBar` | Scaffolding with notched bottom navigation bar (`CircularNotchedRectangle`), 4 tabs, and center action button. |
| **Home & Event Discovery** | `HomeScreen`, `HomeHeader`, `CategoryChipSelector`, `EventCard` | Curved header with user greeting, instant theme/language toggles, category filtering chips, and event cards with date badges. |
| **Events Management (CRUD)**| `CreateEventScreen`, `EditEventScreen`, `EventDetailsScreen` | Dynamic banner preview by category, date/time pickers, form validation, event update, and deletion with confirmation dialog. |
| **Favorites & Live Search** | `FavoritesTab`, `EventCard` | Real-time reactive search filtering favorites by title, description, or location, with comprehensive empty state handling. |
| **Map Discovery** | `MapTab`, `MapEventCard` | Map background view, floating compass button, and bottom horizontal carousel with direct navigation to event details. |
| **Profile & Settings** | `ProfileTab`, `LanguageBottomSheet`, `ThemeBottomSheet` | User profile card, interactive bottom sheets for theme and language switching, and secure logout. |
| **Bilingual Localization** | `AppLocalizations`, `BuildContext.l10n` | Complete English and Arabic dictionaries, dynamic RTL layout switching, and 100% string coverage. |

---

## 🧪 4. Testing & Quality Metrics

Evently maintains an uncompromising quality standard with automated tests across all architectural layers:

```
Total Automated Tests: 101 / 101 PASSED (100% Pass Rate)
Static Analysis (flutter analyze): 0 Errors, 0 Warnings, 0 Issues
```

### Breakdown of Test Suites:
1. **Unit Tests (`test/models/`, `test/providers/`):**
   - Serialization, copyWith, Equatable comparisons for models.
   - Provider state transitions, CRUD actions, search filters, persistence mocking.
2. **Widget Tests (`test/screens/`, `test/widgets/`):**
   - Rendering, navigation, input forms, validation triggers, modal bottom sheets.
3. **Responsive & Text Scaling Tests (`test/screens/responsive/`):**
   - Small device viewport constraint (360x640).
   - High accessibility text scale factor (1.3x).
   - Verified zero `RenderFlex` overflow exceptions across all screens.
4. **End-to-End User Journey Tests (`test/integration/`):**
   - Complete lifecycle validation: Splash ➡️ Setup ➡️ Onboarding ➡️ Google Login ➡️ Create Event ➡️ View on Home ➡️ Favorites ➡️ Profile ➡️ Logout.

---

## 🛠️ 5. Developer Guide: Run, Test & Build

### Prerequisites
- **Flutter SDK:** `>=3.5.4 <4.0.0`
- **Dart SDK:** Included with Flutter
- **Platform Tools:** Android Studio / Xcode

### Running Tests
To run the complete automated test suite without triggering dependency fetches:
```bash
flutter test --no-pub
```

To run a specific test file:
```bash
flutter test --no-pub test/integration/e2e_user_journey_test.dart
flutter test --no-pub test/screens/responsive/responsive_layout_test.dart
```

### Static Analysis
To verify code formatting and clean architecture compliance:
```bash
flutter analyze
```

### Running the Application
To run the application locally on an emulator or connected device:
```bash
flutter run
```

### Building the Debug APK
To compile the Android APK with all bundled assets and validated dependencies:
```bash
flutter build apk --debug
```
The compiled output is generated at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

---

## 📦 6. Deployment & Deliverables Checklist

- [x] Complete Feature Implementation (Phases 0 through 7).
- [x] High-fidelity Figma visual alignment (Assets, Colors, Typography).
- [x] Dual-language Arabic & English support (`AppLocalizations`).
- [x] Light & Dark theme support (`AppTheme`).
- [x] Responsive layout verified on small viewports (360x640) & text scaling (1.3x).
- [x] 101/101 automated tests passing with zero failures.
- [x] Clean static analysis (`No issues found!`).
- [x] Successful APK compilation (`flutter build apk --debug`).
- [x] Complete developer documentation and handoff manual (`docs/HANDOFF.md`).
