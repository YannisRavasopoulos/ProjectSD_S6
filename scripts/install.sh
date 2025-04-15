#!/bin/bash

ANDROID_PATH="$HOME/android"
FLUTTER_PATH="$HOME/flutter"

echo "Installing dependencies"
sudo apt-get update && sudo apt-get install wget unzip xz-utils openjdk-17-jre-headless git -y

echo "Downloading Flutter SDK"
wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz" -O "flutter.tar.xz"
tar -xf "flutter.tar.xz"
mv flutter $FLUTTER_PATH
chown -R $USER:$USER $FLUTTER_PATH

echo "Downloading Android SDK"
wget "https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip" -O "cmdline-tools.zip"
unzip "cmdline-tools.zip"
mkdir -p $ANDROID_PATH/cmdline-tools
mv cmdline-tools $ANDROID_PATH/cmdline-tools/latest

echo "export PATH=\"$ANDROID_PATH/cmdline-tools/latest/bin:\$PATH\"" >>  $HOME/.bashrc
echo "export PATH=\"$FLUTTER_PATH/bin:\$PATH\"" >> $HOME/.bashrc

# JAVA_HOME path may be different if not on ubuntu
echo "export JAVA_HOME=\"/usr/lib/jvm/java-17-openjdk-amd64\"" >> $HOME/.bashrc

echo "CLOSE YOUR TERMINAL APP AND RE-OPEN IT"
