# Troubleshooting Login Issues

## If you're getting "Permission Error - Access Denied" and unable to login:

### 1. **Use the Reset Session Button**

- On the login screen, tap "Having login issues? Reset session"
- This will clear your authentication state and allow you to login fresh

### 2. **Check Firebase Console**

- Go to Firebase Console → Authentication
- Make sure the user account exists and is not disabled
- Check if Email/Password provider is enabled

### 3. **Update Firestore Security Rules**

Make sure your Firestore rules are set to:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /homeworks/{homeworkId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### 4. **Clear App Data** (If still stuck)

- Uninstall and reinstall the app
- Or clear app data in device settings

### 5. **Create New Account**

- Try registering with a new email address
- This often resolves persistent auth issues

### 6. **Debug Information**

- Check the console/logs for detailed error messages
- Look for "Firebase Auth Error" messages

## Common Error Codes:

- **user-not-found**: Email doesn't exist, try registering
- **wrong-password**: Incorrect password
- **invalid-email**: Email format is incorrect
- **network-request-failed**: Check internet connection
- **permission-denied**: Firestore rules issue or auth state problem

## Quick Fix Steps:

1. Tap "Reset session" on login screen
2. Wait 2-3 seconds for the process to complete
3. Try logging in again with correct credentials
4. If still failing, try registering a new account

The app now has improved error handling and should automatically guide you through fixing auth issues!
