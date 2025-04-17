#!/bin/bash

set -e  # Exit on any error

# Check for required dependencies
for cmd in unzip xz wget grep; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

FLUTTER_HOME="$HOME/flutter"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz"

# Check if Flutter is already installed
if [ -d "$FLUTTER_HOME" ]; then
    echo "Flutter is already installed at $FLUTTER_HOME"
    echo "If you want to reinstall, please remove the existing installation first."
    exit 1
fi

# Create temp directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download Flutter
echo "Downloading Flutter..."
if ! wget "$FLUTTER_URL" -O "flutter.tar.xz"; then
    echo "Failed to download Flutter"
    rm -rf "$TMP_DIR"
    exit 1
fi

# Extract Flutter
echo "Extracting Flutter..."
if ! tar -xf "flutter.tar.xz"; then
    echo "Failed to extract Flutter"
    rm -rf "$TMP_DIR"
    exit 1
fi

# Move Flutter to home directory
echo "Installing Flutter..."
if ! mv "flutter" "$FLUTTER_HOME"; then
    echo "Failed to move Flutter to $FLUTTER_HOME"
    rm -rf "$TMP_DIR"
    exit 1
fi

# Clean up
rm -rf "$TMP_DIR"

# Set permissions
chown -R "$USER:$USER" "$FLUTTER_HOME"

# Add to PATH if not already present
if ! grep -q "export PATH=\"$FLUTTER_HOME/bin:\$PATH\"" "$HOME/.bashrc"; then
    echo "export PATH=\"$FLUTTER_HOME/bin:\$PATH\"" >> "$HOME/.bashrc"
fi

echo "Flutter is successfully installed."
echo "Please restart your terminal."
