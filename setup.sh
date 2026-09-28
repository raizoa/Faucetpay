#!/data/data/com.termux/files/usr/bin/bash

set -u

echo ""
echo "=========================================="
echo "       FAUCETPAY TERMUX SETUP"
echo "=========================================="
echo ""

# ============================================================
# KONFIGURASI DPKG
# Agar tidak berhenti pada prompt:
# Y/I/N/O/D/Z
# ============================================================

export DEBIAN_FRONTEND=noninteractive

DPKG_OPTIONS=(
    "-o"
    "Dpkg::Options::=--force-confdef"
    "-o"
    "Dpkg::Options::=--force-confold"
)

# ============================================================
# FUNCTION
# Menjalankan pkg dengan opsi DPKG otomatis
# ============================================================

pkg_auto() {
    pkg "${DPKG_OPTIONS[@]}" "$@"
}

# ============================================================
# 1. UPDATE PACKAGE
# ============================================================

echo "[1/6] Updating Termux packages..."
echo ""

pkg_auto update -y

# ============================================================
# 2. UPGRADE PACKAGE
# ============================================================

echo ""
echo "[2/6] Upgrading Termux packages..."
echo ""

pkg_auto upgrade -y

# ============================================================
# 3. INSTALL SYSTEM PACKAGE
# ============================================================

echo ""
echo "[3/6] Installing system packages..."
echo ""

pkg_auto install -y \
    python \
    php \
    imagemagick \
    tesseract \
    curl \
    unzip

# ============================================================
# 4. SETUP STORAGE
# ============================================================

echo ""
echo "[4/6] Setting up storage..."
echo ""

if [ ! -d "$HOME/storage/shared" ]; then
    termux-setup-storage
else
    echo "Storage already configured."
fi

# ============================================================
# 5. INSTALL PYTHON PACKAGE
# ============================================================

echo ""
echo "[5/6] Installing Python packages..."
echo ""

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

echo "------------------------------------------"
echo "Python:"
python --version

echo ""
echo "PHP:"
php -v | head -1

echo ""
echo "PIP:"
python -m pip --version

echo ""
echo "------------------------------------------"

# ============================================================
# CEK PACKAGE PENTING
# ============================================================

echo ""
echo "Checking required commands..."

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "[OK] $1"
    else
        echo "[ERROR] $1 tidak ditemukan"
    fi
}

check_command python
check_command php
check_command convert
check_command tesseract
check_command curl
check_command unzip

# ============================================================
# SELESAI
# ============================================================

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
