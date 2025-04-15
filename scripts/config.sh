#!/bin/bash

ANDROID_PATH="$HOME/android"
FLUTTER_PATH="$HOME/flutter"

# Accept licenses and config Flutter
flutter config --android-sdk "$ANDROID_PATH"
flutter config --disable-analytics
yes | flutter doctor --android-licenses

echo "Installing Android SDK components"
# Install Android SDK components
yes | sdkmanager "platform-tools"
yes | sdkmanager "emulator"
yes | sdkmanager "build-tools;36.0.0"
yes | sdkmanager "platforms;android-35"
yes | sdkmanager "system-images;android-35;google_apis;x86_64"
yes | flutter doctor --android-licenses

echo "Create Android Virtual Device (AVD)"
avdmanager create avd -n flutter_emulator -k "system-images;android-35;google_apis;x86_64" --device "pixel"

# Install NDK: idk why THE FUCK fucking flutter cant install it by itself
echo "Install NDK"
sdkmanager "ndk;26.3.11579264"

flutter doctor



