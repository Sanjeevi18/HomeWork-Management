# Homework Management App - Setup Guide

## Firebase Configuration

To fix the permission-denied error, you need to configure Firebase Security Rules:

### 1. Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database**
4. Go to **Rules** tab

### 2. Update Security Rules

Replace the default rules with the content from `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Allow access to homework subcollection for authenticated users
      match /homeworks/{homeworkId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Deny all other reads/writes
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### 3. Authentication Setup

Make sure Firebase Authentication is enabled:

1. Go to **Authentication** in Firebase Console
2. Enable **Email/Password** provider
3. Add authorized domains if needed

### 4. Common Issues & Solutions

#### Permission Denied Error

- **Cause**: User not authenticated or incorrect security rules
- **Solution**: Make sure user is logged in and security rules allow access

#### RenderFlex Overflow

- **Fixed**: Updated homework list empty state to be scrollable and responsive

#### Network Connectivity Issues

- **Fixed**: Added retry logic and better error handling in HomeworkController

### 5. Testing

1. Register a new user
2. Login with the user
3. Try adding/viewing homework
4. Check that data persists across app restarts

### 6. Build & Run

```bash
flutter clean
flutter pub get
flutter run
```

## Features

✅ **Onboarding** - Animated introduction
✅ **Authentication** - Login/Register with Firebase
✅ **Homework CRUD** - Add, view, edit, delete homework
✅ **Profile Management** - User profile and settings
✅ **Custom Theme** - Beautiful color palette
✅ **Responsive UI** - Works on different screen sizes
✅ **Error Handling** - Robust network and auth error handling

## Architecture

- **State Management**: GetX
- **Backend**: Firebase (Auth + Firestore)
- **Storage**: GetStorage for local preferences
- **UI**: Material Design with custom theme
