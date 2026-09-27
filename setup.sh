#!/data/data/com.termux/files/usr/bin/bash

set -u

REPO="https://github.com/raizoa/Faucetpay"
RAW="https://raw.githubusercontent.com/raizoa/Faucetpay/main"

INSTALL_DIR="$HOME/Faucetpay"
TMP_DIR="$HOME/.faucetpay_install"

export DEBIAN_FRONTEND=noninteractive
export PIP_DISABLE_PIP_VERSION_CHECK=1

echo ""
echo "=========================================="
echo "       FAUCETPAY AUTO INSTALLER"
echo "=========================================="
echo ""

# ------------------------------------------------------------
# 1. UPDATE TERMUX
# ------------------------------------------------------------

echo "[1/8] Updating Termux packages..."

pkg update -y
pkg upgrade -y

# ------------------------------------------------------------
# 2. INSTALL REQUIRED TERMUX PACKAGES
# ------------------------------------------------------------

echo ""
echo "[2/8] Installing required packages..."

pkg install -y \
    python \
    php \
    imagemagick \
    tesseract \
    curl \
    unzip \
    git

# ------------------------------------------------------------
# 3. STORAGE PERMISSION
# ------------------------------------------------------------

echo ""
echo "[3/8] Setting up Android storage..."

termux-setup-storage

# ------------------------------------------------------------
# 4. CREATE INSTALL DIRECTORY
# ------------------------------------------------------------

echo ""
echo "[4/8] Preparing Faucetpay directory..."

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# ------------------------------------------------------------
# 5. DOWNLOAD REPOSITORY
# ------------------------------------------------------------

echo ""
echo "[5/8] Downloading Faucetpay..."

cd "$TMP_DIR"

curl -L \
    -o faucetpay.zip \
    "$REPO/archive/refs/heads/main.zip"

if [ ! -s faucetpay.zip ]; then
    echo ""
    echo "ERROR: Failed to download Faucetpay."
    exit 1
fi

echo "Extracting files..."

unzip -q faucetpay.zip

if [ ! -d "$TMP_DIR/Faucetpay-main" ]; then
    echo ""
    echo "ERROR: Extracted repository not found."
    exit 1
fi

cp -r "$TMP_DIR/Faucetpay-main"/. "$INSTALL_DIR"/

# ------------------------------------------------------------
# 6. INSTALL PYTHON DEPENDENCIES
# ------------------------------------------------------------

echo ""
echo "[6/8] Upgrading pip..."

python -m pip install --upgrade pip

echo ""
echo "[7/8] Installing Python dependencies..."

pip install -U \
    seledroid \
    telethon \
    rich \
    requests \
    bs4 \
    janda \
    pycryptodome \
    pyrogram \
    tgcrypto \
    pillow \
    pypng \
    pycurl \
    curl_cffi \
    httpx \
    bas-http \
    skipcha

# ------------------------------------------------------------
# 7. PERMISSIONS
# ------------------------------------------------------------

echo ""
echo "[8/8] Setting executable permissions..."

find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;

# ------------------------------------------------------------
# CLEANUP
# ------------------------------------------------------------

rm -rf "$TMP_DIR"

# ------------------------------------------------------------
# FINISHED
# ------------------------------------------------------------

echo ""
echo "=========================================="
echo "       FAUCETPAY INSTALLATION DONE"
echo "=========================================="
echo ""

echo "Installed at:"
echo "$INSTALL_DIR"

echo ""
echo "Contents:"
ls -la "$INSTALL_DIR"

echo ""
echo "=========================================="
echo "Installation completed successfully."
echo "=========================================="
echo ""
