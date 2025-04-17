#!/bin/bash

# Exit on error
set -e

# Check for required dependencies
for cmd in unzip xz wget grep; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

# Declare variables
ANDROID_HOME="$HOME/android"
ANDROID_URL="https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip"
TEMP_ZIP="cmdline-tools.zip"

# Check if Android SDK is already installed
if [ -d "$ANDROID_HOME" ]; then
    echo "Android SDK is already installed at $ANDROID_HOME"
    echo "If you want to reinstall, please remove the existing installation first."
    exit 1
fi

# Create temp directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo "Downloading Android SDK..."
if ! wget "$ANDROID_URL" -O "$TEMP_ZIP"; then
    echo "Error: Failed to download Android SDK"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "Extracting Android SDK..."
if ! unzip "$TEMP_ZIP"; then
    echo "Error: Failed to unzip Android SDK"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "Installing Android SDK..."

mkdir -p "$ANDROID_HOME/cmdline-tools" || {
    echo "Error: Failed to create directory structure"
    rm -rf "$TMP_DIR"
    exit 1
}

if ! mv cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"; then
    echo "Error: Failed to move cmdline-tools"
    rm -rf "$TMP_DIR"
    exit 1
fi

# Clean up
rm -rf "$TMP_DIR"

# Add PATH only if it doesn't exist already
if ! grep -q "$ANDROID_HOME/cmdline-tools/latest/bin" "$HOME/.bashrc"; then
    echo "export PATH=\"$ANDROID_HOME/cmdline-tools/latest/bin:\$PATH\"" >> "$HOME/.bashrc"
fi

PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

echo "Installing Android SDK components"
yes | sdkmanager "platform-tools"
yes | sdkmanager "emulator"

echo "Installation completed successfully!"
echo "Please restart your terminal."
