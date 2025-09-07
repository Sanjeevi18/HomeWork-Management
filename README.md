# 📚 Homework Manager App

A comprehensive Flutter application for students to manage their homework assignments efficiently. Built with **GetX** for state management and **Firebase** for backend services.

## 🎨 Design Theme

The app features a calming and student-friendly color palette:

- **Pale Cerulean** (#A5C8E4) - Primary color (soft, gentle blue)
- **Tea Green** (#C0ECCC) - Secondary color (refreshing minty tone)
- **Blond** (#F9F0C1) - Background color (warm, neutral cream)
- **Deep Champagne** (#F4CDA6) - Accent color (subtle peach warmth)
- **Mauvelous** (#F6A8A6) - Error/Alert color (mild, calming rose)

## ✨ Features

### 🚀 Core Features

- **Onboarding Experience**: Interactive 4-screen introduction to the app
- **User Authentication**:
  - Email/password registration and login
  - Firebase Authentication integration
  - Secure user session management
- **Homework Management**:
  - Add, edit, and delete homework assignments
  - Mark homework as completed
  - Real-time sync with Firebase Firestore
  - Progress tracking and statistics

### 📱 User Interface Features

- **Responsive Design**: Works on all screen sizes
- **Dark/Light Theme**: Automatic system theme detection
- **Smooth Animations**: Card transitions and loading states
- **Intuitive Navigation**: GetX-powered routing
- **Form Validation**: Email and password validation
- **Snackbar Notifications**: User feedback for actions

### 🔧 Technical Features

- **State Management**: GetX for reactive programming
- **Local Storage**: GetStorage for user preferences
- **Firebase Integration**:
  - Firestore for data storage
  - Firebase Auth for authentication
- **Clean Architecture**: MVC pattern implementation
- **Code Organization**: Modular folder structure

## 🏗️ Project Structure

```
lib/
├── app/
│   ├── routes.dart              # App navigation routes
│   └── themes.dart              # Light and dark themes
├── controllers/
│   ├── auth_controller.dart     # Authentication logic
│   ├── homework_controller.dart # Homework CRUD operations
│   └── onboarding_controller.dart # Onboarding flow
├── models/
│   └── homework_model.dart      # Homework data model
├── views/
│   ├── auth/
│   │   ├── login_screen.dart    # Login interface
│   │   └── register_screen.dart # Registration interface
│   ├── homework/
│   │   └── homework_list.dart   # Main homework screen
│   └── onboarding/
│       └── onboarding_screen.dart # Welcome screens
├── utils/
│   └── validators.dart          # Form validation logic
├── widgets/                     # Reusable UI components
└── main.dart                    # App entry point
```

## 📦 Dependencies

### Core Dependencies

- `flutter`: SDK
- `get: ^4.6.6`: State management and navigation
- `firebase_core: ^2.24.2`: Firebase initialization
- `cloud_firestore: ^4.13.6`: Database operations
- `firebase_auth: ^4.15.3`: User authentication

### UI & Utility Dependencies

- `flutter_slidable: ^3.0.1`: Swipe actions for homework items
- `get_storage: ^2.1.1`: Local data persistence
- `intl: ^0.19.0`: Date formatting and internationalization
- `flutter_local_notifications: ^16.3.2`: Push notifications

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Firebase project setup
- Android Studio / VS Code with Flutter extension

### Installation Steps

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd homework
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Run Firebase CLI setup:

   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/homeworks/{homeworkId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Assets Setup

Place your onboarding images in `assets/images/` and update the JSON file at `assets/Kids Learning From Home.json`.

## 🐛 Common Issues & Solutions

### 1. Firebase Configuration Errors

**Problem**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`
**Solution**:

- Ensure `firebase_options.dart` is generated
- Check Firebase initialization in `main.dart`
- Verify `google-services.json` is in `android/app/`

### 2. GetX Controller Not Found

**Problem**: `Controller not found. You need to call "Get.put"`
**Solution**:

- Check controller initialization in `main.dart`
- Verify route bindings in `routes.dart`
- Use `Get.find()` instead of `Get.put()` if controller exists

### 3. Firestore Permission Denied

**Problem**: `FirebaseError: Missing or insufficient permissions`
**Solution**:

- Update Firestore security rules
- Ensure user is authenticated before database operations
- Check user ID matches document path

### 4. Build Errors

**Problem**: Various compilation errors
**Solution**:

- Run `flutter clean && flutter pub get`
- Check Flutter and Dart SDK versions
- Verify all imports are correct

### 5. Theme/UI Issues

**Problem**: Colors not applying correctly
**Solution**:

- Check `ColorScheme` vs deprecated `primarySwatch`
- Restart app after theme changes
- Verify Material 3 compatibility

## 🔄 App Flow

1. **App Launch** → Check onboarding completion
2. **Onboarding** → 4 screens introducing the app
3. **Authentication** → Login/Register with Firebase
4. **Home Screen** → Homework list with CRUD operations
5. **Data Sync** → Real-time Firestore synchronization

## 🎯 Future Enhancements

- [ ] Push notifications for homework deadlines
- [ ] Homework categories/subjects
- [ ] File attachments for homework
- [ ] Calendar view integration
- [ ] Offline mode support
- [ ] Export homework as PDF
- [ ] Share homework with classmates
- [ ] Teacher/Parent dashboard
- [ ] Homework reminders
- [ ] Achievement system

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Generate coverage report
flutter test --coverage
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (11.0+)
- ✅ Web (Progressive Web App)
- ✅ Windows (Desktop)
- ✅ macOS (Desktop)
- ✅ Linux (Desktop)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

If you encounter any issues or have questions:

- Check the [Common Issues](#-common-issues--solutions) section
- Create an issue on GitHub
- Review Firebase documentation
- Check GetX documentation

---

**Happy Homework Management! 📚✨**
