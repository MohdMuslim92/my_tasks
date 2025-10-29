# My Tasks Application

---

## Description
**My Tasks** is a simple Flutter app for managing daily tasks.  
It allows users to create, edit, and delete tasks, with dynamic updates on the task list. The app supports user authentication, dark/light mode, and localization (English/Arabic).

---

## Features

### 1. Splash & Login Screen
- Splash screen with app logo and name.
- Email/password login using Firebase Authentication.
- Navigate to task list after successful login.
- Language switcher (English / Arabic).
- Dark/Light mode toggle.

### 2. Register Screen
- User registration with email/password.
- Reuses the same form as login.
- Password visibility toggle.

### 3. Task List Page
- Displays task title, description, and status.
- Add, edit, delete tasks.
- Responsive layout (mobile, tablet, desktop).
- Dark/light mode support.
- Pull-to-refresh support.

### 4. Add / Edit Task Page
- Input fields: title (required), description, status (done/not done).
- Updates reflect instantly on the main list.

### 5. Bonus Features
- State management with **Provider**.
- Dark and light mode.
- Localization (English/Arabic).
- Modular and reusable code for forms, theme, and language.

---

## Setup Instructions

### 1. Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase project](https://console.firebase.google.com/)
- IDE (VSCode / Android Studio)
- Mobile device or emulator

### 2. Clone Repository
```bash
git clone https://github.com/MohdMuslim92/my_tasks.git
cd my_tasks
```

### 3. Install Dependencies
```
flutter pub get
```
### 4. Firebase Setup

1. Create a Firebase project.

2. Enable Authentication → Email/Password.

3. Enable Firestore Database (in test mode or configure rules).

4. Add Android/iOS app in Firebase console.

5. Download google-services.json (Android) and GoogleService-Info.plist (iOS) and place them in respective directories:

    - android/app/ → google-services.json

    - ios/Runner/ → GoogleService-Info.plist

### 5. Run the App
```
flutter run
```


- Launch on emulator or physical device.

- Splash screen will appear, followed by login screen.

### 6. Optional Setup

- Dark/Light mode: toggle in AppBar (theme icon).

- Language switcher: toggle in AppBar (EN/AR).

- Demo credentials available on login screen for quick testing.

### Project Structure

```
lib/
├── main.dart
├── services/
│   └── auth_service.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── task_list_screen.dart
│   └── add_edit_task_screen.dart
├── themes/
│   ├── app_theme.dart
├── widgets/
│   ├── auth_form.dart
│   ├── app_logo.dart
│   ├── task_card.dart
│   ├── task_form.dart
│   ├── theme_toggle.dart
│   └── language_switcher.dart
├── providers/
│   ├── auth_service.dart
│   ├── task_provider.dart
│   └── locale_provider.dart
├── models/
│   └── task.dart
└── l10n/
    ├── app_en.arb
    └── app_ar.arb
```

## Notes

- This project uses Provider for state management.

- Firestore collections:

    * users → user data.

    * tasks → stores tasks by user.

- Localization uses flutter_localizations and ARB files.

- Dark/light theme fully applies to all screens, buttons, texts, and forms.
