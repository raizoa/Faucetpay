#!/data/data/com.termux/files/usr/bin/bash

set -u

echo ""
echo "=========================================="
echo "       FAUCETPAY TERMUX SETUP"
echo "=========================================="
echo ""

# ============================================================
# 1. UPDATE PACKAGE
# ============================================================

echo "[1/6] Updating Termux packages..."
pkg update -y

# ============================================================
# 2. UPGRADE PACKAGE
# ============================================================

echo "[2/6] Upgrading Termux packages..."
pkg upgrade -y

# ============================================================
# 3. INSTALL SYSTEM PACKAGE
# ============================================================

echo "[3/6] Installing system packages..."

pkg install -y \
    python \
    php \
    imagemagick \
    tesseract \
    curl \
    unzip

# ============================================================
# 4. SETUP STORAGE
# ============================================================

echo "[4/6] Setting up storage..."

if [ ! -d "$HOME/storage/shared" ]; then
    termux-setup-storage
else
    echo "Storage already configured."
fi

# ============================================================
# 5. INSTALL PYTHON PACKAGE
# ============================================================

echo "[5/6] Installing Python packages..."

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

# ============================================================
# 6. CHECK INSTALLATION
# ============================================================

echo ""
echo "[6/6] Checking installation..."
echo ""

echo "Python:"
python --version

echo ""
echo "PHP:"
php -v | head -1

echo ""
echo "PIP:"
python -m pip --version

echo ""
echo "=========================================="
echo "          SETUP SELESAI"
echo "=========================================="
echo ""

echo "Folder Faucetpay:"
echo "$HOME/Faucetpay"

echo ""
echo "Untuk menjalankan TronBlow:"
echo "cd ~/Faucetpay/TronBlow"
echo "php tronblow.php"

echo ""
