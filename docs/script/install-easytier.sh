#!/bin/sh
# Simple EasyTier installer script

# Variables
ZIP_URL="https://github.com/EasyTier/EasyTier/releases/download/v2.4.2/easytier-linux-x86_64-v2.4.2.zip"
# https://ghfast.top/https://github.com/EasyTier/EasyTier/releases/download/v2.4.2/easytier-linux-x86_64-v2.4.2.zip
TMP_ZIP="/tmp/easytier.zip"
INSTALL_DIR="/opt/EasyTier"

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Download the ZIP file
echo "Downloading EasyTier..."
curl -L -o "$TMP_ZIP" "$ZIP_URL"

# Verify download
if [ ! -f "$TMP_ZIP" ]; then
    echo "Download failed!"
    exit 1
fi

# Extract ZIP into the installation directory
echo "Extracting EasyTier to $INSTALL_DIR..."
unzip -o "$TMP_ZIP" -d "$INSTALL_DIR"

# Clean up temporary ZIP
rm -f "$TMP_ZIP"

echo "EasyTier installed successfully to $INSTALL_DIR!"
