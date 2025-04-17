#!/bin/bash

ANDROID_HOME="$HOME/android"

# This is so VSCode can find the Android SDK
ln -s "$ANDROID_HOME/cmdline-tools" "$ANDROID_HOME/tools"

yes | sdkmanager "build-tools;36.0.0"
yes | sdkmanager "platforms;android-35"
yes | sdkmanager "system-images;android-27;google_apis_playstore;x86"

flutter config --android-sdk "$ANDROID_HOME"
flutter config --disable-analytics
yes | flutter doctor --android-licenses
