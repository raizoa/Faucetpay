#!/data/data/com.termux/files/usr/bin/bash

set -u

echo ""
echo "=========================================="
echo "       FAUCETPAY TERMUX SETUP"
echo "=========================================="
echo ""

# ============================================================
# DPKG CONFIGURATION
# Mencegah prompt Y/I/N/O/D/Z
# ============================================================

export DEBIAN_FRONTEND=noninteractive

mkdir -p "$PREFIX/etc/apt/apt.conf.d"

cat > "$PREFIX/etc/apt/apt.conf.d/99faucetpay" <<'EOF'
Dpkg::Options {
    "--force-confdef";
    "--force-confold";
};
EOF

# ============================================================
# 1. UPDATE PACKAGE
# ============================================================

echo ""
echo "[1/7] Updating Termux packages..."
echo ""

pkg update -y

# ============================================================
# 2. UPGRADE PACKAGE
# ============================================================

echo ""
echo "[2/7] Upgrading Termux packages..."
echo ""

pkg upgrade -y

# ============================================================
# 3. INSTALL SYSTEM PACKAGE
# ============================================================

echo ""
echo "[3/7] Installing system packages..."
echo ""

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

echo ""
echo "[4/7] Setting up storage..."
echo ""

if [ ! -d "$HOME/storage/shared" ]; then
    termux-setup-storage
else
    echo "Storage already configured."
fi

# ============================================================
# 5. INSTALL PYTHON PACKAGES
# ============================================================

echo ""
echo "[5/7] Installing Python packages..."
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
# 6. DOWNLOAD FAUCETPAY REPOSITORY
# ============================================================

echo ""
echo "[6/7] Downloading Faucetpay repository..."
echo ""

INSTALL_DIR="$HOME/Faucetpay"
ZIP_FILE="$HOME/Faucetpay.zip"
TEMP_DIR="$HOME/Faucetpay-install"

# Bersihkan instalasi lama
rm -rf "$INSTALL_DIR"
rm -rf "$TEMP_DIR"
rm -f "$ZIP_FILE"

mkdir -p "$TEMP_DIR"

echo "Downloading from GitHub..."

if ! curl -fL \
    --retry 3 \
    --connect-timeout 20 \
    --max-time 300 \
    "https://github.com/raizoa/Faucetpay/archive/refs/heads/main.zip" \
    -o "$ZIP_FILE"
then
    echo ""
    echo "=========================================="
    echo "[ERROR] GAGAL DOWNLOAD FAUCETPAY"
    echo "=========================================="
    echo ""
    echo "Periksa koneksi internet dan URL GitHub."
    rm -rf "$TEMP_DIR"
    rm -f "$ZIP_FILE"
    exit 1
fi

# Pastikan ZIP tidak kosong
if [ ! -s "$ZIP_FILE" ]; then
    echo ""
    echo "[ERROR] File Faucetpay.zip kosong."
    rm -rf "$TEMP_DIR"
    rm -f "$ZIP_FILE"
    exit 1
fi

echo "[OK] Download selesai."

# ============================================================
# EXTRACT
# ============================================================

echo ""
echo "Extracting Faucetpay..."

if ! unzip -q "$ZIP_FILE" -d "$TEMP_DIR"; then
    echo ""
    echo "=========================================="
    echo "[ERROR] GAGAL EXTRACT FAUCETPAY"
    echo "=========================================="
    rm -rf "$TEMP_DIR"
    rm -f "$ZIP_FILE"
    exit 1
fi

# Cari folder hasil extract
SOURCE_DIR="$TEMP_DIR/Faucetpay-main"

if [ ! -d "$SOURCE_DIR" ]; then
    echo ""
    echo "[ERROR] Folder Faucetpay-main tidak ditemukan."
    echo ""
    echo "Isi hasil extract:"
    find "$TEMP_DIR" -maxdepth 2 -type f
    rm -rf "$TEMP_DIR"
    rm -f "$ZIP_FILE"
    exit 1
fi

# Pindahkan repository ke HOME
mv "$SOURCE_DIR" "$INSTALL_DIR"

# Bersihkan file temporary
rm -rf "$TEMP_DIR"
rm -f "$ZIP_FILE"

# ============================================================
# SET PERMISSION
# ============================================================

find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo ""
echo "[OK] Repository Faucetpay berhasil diinstall."
echo "Location: $INSTALL_DIR"

# ============================================================
# 7. CHECK INSTALLATION
# ============================================================

echo ""
echo "[7/7] Checking installation..."
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

echo "Checking required commands..."

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "[OK] $1"
    else
        echo "[ERROR] $1 tidak ditemukan"
        return 1
    fi
}

check_command python
check_command php
check_command convert
check_command tesseract
check_command curl
check_command unzip

# ============================================================
# CHECK FAUCETPAY FILES
# ============================================================

echo ""
echo "Checking Faucetpay files..."

TRON_DIR="$INSTALL_DIR/TronBlow"

if [ -f "$TRON_DIR/tronblow.php" ]; then
    echo "[OK] TronBlow/tronblow.php"
else
    echo "[ERROR] TronBlow/tronblow.php TIDAK DITEMUKAN"
    exit 1
fi

if [ -f "$TRON_DIR/tronblow_config.json" ]; then
    echo "[OK] TronBlow/tronblow_config.json"
else
    echo "[ERROR] TronBlow/tronblow_config.json TIDAK DITEMUKAN"
    exit 1
fi

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
echo "Starting TronBlow..."
echo ""

cd "$INSTALL_DIR/TronBlow"

php tronblow.php
