#!/bin/bash

ANDROID_HOME="$HOME/android"

yes | sdkmanager "build-tools;36.0.0"
yes | sdkmanager "platforms;android-35"
yes | sdkmanager "system-images;android-27;google_apis_playstore;x86"

flutter config --android-sdk "$ANDROID_HOME"
flutter config --disable-analytics
yes | flutter doctor --android-licenses

# yes | sdkmanager "system-images;android-35;google_apis;x86_64"
# avdmanager create avd -n flutter_emulator -k "system-images;android-35;google_apis;x86_64" --device "pixel"
# sdkmanager "ndk;26.3.11579264"
# # JAVA_HOME path may be different if not on ubuntu
# echo "export JAVA_HOME=\"/usr/lib/jvm/java-17-openjdk-amd64\"" >> $HOME/.bashrc
