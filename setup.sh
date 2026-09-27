#!/data/data/com.termux/files/usr/bin/bash

set -u

export DEBIAN_FRONTEND=noninteractive
export PIP_DISABLE_PIP_VERSION_CHECK=1

echo ""
echo "=========================================="
echo "       TERMUX AUTO SETUP"
echo "=========================================="
echo ""

echo "[1/6] Update package..."
yes '' | pkg update -y

echo ""
echo "[2/6] Upgrade package..."
yes '' | pkg upgrade -y

echo ""
echo "[3/6] Install package..."
yes '' | pkg install -y python php imagemagick tesseract

echo ""
echo "[4/6] Setup storage..."
termux-setup-storage

echo ""
echo "[5/6] Upgrade pip..."
yes '' | python -m pip install --upgrade pip

echo ""
echo "[6/6] Install Python packages..."

yes '' | pip install -U \
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
echo "=========================================="
echo "           SETUP SELESAI"
echo "=========================================="
echo ""

python --version
pip --version

echo ""
echo "=========================================="
echo "Semua proses selesai."
echo "=========================================="
