#!/bin/bash

echo "🔥 Google Sign-In Configuration Test"
echo "===================================="
echo ""

echo "📋 Your Configuration Details:"
echo "SHA-1: 2F:2F:DB:EA:33:FA:4A:70:48:CE:41:DA:FF:E1:DF:9A:55:66:D2:49"
echo "Package: com.example.homework"
echo "Project ID: homework-1a9c3"
echo ""

echo "🔗 Quick Links:"
echo "1. Firebase Console: https://console.firebase.google.com/project/homework-1a9c3"
echo "2. Add SHA-1: https://console.firebase.google.com/project/homework-1a9c3/settings/general"
echo "3. Enable Google Auth: https://console.firebase.google.com/project/homework-1a9c3/authentication/providers"
echo ""

echo "✅ After configuring Firebase:"
echo "1. Download new google-services.json"
echo "2. Replace android/app/google-services.json"
echo "3. Run: flutter clean && flutter pub get && flutter run"
echo ""

echo "🎯 Expected Result:"
echo "- Google Sign-In should work without ApiException: 10"
echo "- Users should be able to sign in with Google account"
echo "- No more 'not properly configured' errors"
echo ""

read -p "Press Enter to continue..."
