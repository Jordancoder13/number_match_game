@echo off
echo Building Number Match Game for Android...
echo.

echo Cleaning previous builds...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building APK (Release)...
flutter build apk --release

echo.
echo Build complete! 
echo APK location: build\app\outputs\flutter-apk\app-release.apk
echo.
pause
