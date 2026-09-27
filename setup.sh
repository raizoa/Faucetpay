#!/data/data/com.termux/files/usr/bin/bash

set -u

REPO="https://github.com/raizoa/Faucetpay"
INSTALL_DIR="$HOME/Faucetpay"
TMP_DIR="$HOME/.faucetpay_install"

export DEBIAN_FRONTEND=noninteractive
export PIP_DISABLE_PIP_VERSION_CHECK=1

echo ""
echo "=========================================="
echo "       FAUCETPAY AUTO INSTALLER"
echo "=========================================="
echo ""

echo "[1/7] Updating Termux..."
pkg update -y
pkg upgrade -y

echo ""
echo "[2/7] Installing required packages..."
pkg install -y \
    python \
    php \
    imagemagick \
    tesseract \
    curl \
    unzip \
    git

echo ""
echo "[3/7] Checking Android storage..."

if [ ! -d "$HOME/storage/shared" ]; then
    echo "Storage permission has not been configured."
    echo "Please allow Termux storage permission."
    termux-setup-storage
else
    echo "Storage already configured."
fi

echo ""
echo "[4/7] Preparing installation directory..."

rm -rf "$TMP_DIR"
rm -rf "$INSTALL_DIR"

mkdir -p "$TMP_DIR"
mkdir -p "$INSTALL_DIR"

echo ""
echo "[5/7] Downloading Faucetpay..."

cd "$TMP_DIR"

curl -L \
    -o faucetpay.zip \
    "$REPO/archive/refs/heads/main.zip"

if [ ! -s faucetpay.zip ]; then
    echo ""
    echo "ERROR: Download failed."
    exit 1
fi

echo "Extracting..."

unzip -q faucetpay.zip

if [ ! -d "$TMP_DIR/Faucetpay-main" ]; then
    echo ""
    echo "ERROR: Repository extraction failed."
    exit 1
fi

cp -r "$TMP_DIR/Faucetpay-main"/. "$INSTALL_DIR"/

echo ""
echo "[6/7] Installing Python dependencies..."

python -m pip install \
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

echo ""
echo "[7/7] Setting permissions..."

find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;

rm -rf "$TMP_DIR"

echo ""
echo "=========================================="
echo "       FAUCETPAY INSTALLATION DONE"
echo "=========================================="
echo ""

echo "Location:"
echo "$INSTALL_DIR"

echo ""
echo "Files:"
ls -la "$INSTALL_DIR"

echo ""
echo "Python:"
python --version

echo ""
echo "Pip:"
pip --version

echo ""
echo "=========================================="
echo "       INSTALLATION COMPLETE"
echo "=========================================="
echo ""
