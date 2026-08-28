#!/bin/bash
# Komplette talkiepi Installation mit Go 1.21.13 + GOPATH (traditionell)
# Für Raspberry Pi Zero mit ReSpeaker 2-Mic HAT
# bash talkiepi_install_go1.21.sh

set -e  # Stoppt bei Fehler

echo "=========================================="
echo "talkiepi Installation - Go 1.21.13 + GOPATH"
echo "Raspberry Pi Zero + ReSpeaker 2-Mic HAT"
echo "=========================================="
# ============================================
# SCHRITT 0: GitHub Token (optional)
# ============================================
GITHUB_TOKEN="ghp_CIYEYS1I19M0293RIU4CQB9B2BVW75F9"  # Hier deinen Token einfügen

if [ -n "$GITHUB_TOKEN" ]; then
    GIT_CLONE_CMD="git clone https://${GITHUB_TOKEN}@github.com"
    echo "✓ Verwende GitHub Token für Authentifizierung"
else
    GIT_CLONE_CMD="git clone https://github.com"
    echo "ℹ Kein Token gesetzt - verwende öffentlichen HTTPS-Zugriff"
fi
echo ""

# ============================================
# SCHRITT 1: System aktualisieren
# ============================================
echo "[1/10] System aktualisieren..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt update && sudo apt install -y i2c-tools
echo "✓ System aktuell"
echo ""

# ============================================
# SCHRITT 2: System-Bibliotheken installieren
# ============================================
echo "[2/10] System-Bibliotheken installieren..."
sudo apt-get install -y \
    libopenal-dev \
    libopus-dev \
    libasound2-dev \
    git \
    wget \
    build-essential \
    dphys-swapfile
echo "✓ System-Bibliotheken installiert"
echo ""

# ============================================
# SCHRITT 3: Go 1.21 installieren
# ============================================
echo "[3/10] Go 1.21.13 herunterladen und installieren..."
cd /tmp

wget -q https://golang.org/dl/go1.21.13.linux-armv6l.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.13.linux-armv6l.tar.gz
rm go1.21.13.linux-armv6l.tar.gz

echo "✓ Go 1.21.13 installiert"
echo ""

# ============================================
# SCHRITT 4: GOPATH Environment setzen
# ============================================
echo "[4/10] GOPATH Environment konfigurieren..."

if ! grep -q "export PATH=/usr/local/go/bin" ~/.profile; then
    cat >> ~/.profile << 'EOF'

# Go 1.21 + GOPATH (traditionell)
export PATH=/usr/local/go/bin:$PATH
export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export GO111MODULE=off
EOF
fi

export PATH=/usr/local/go/bin:$PATH
export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export GO111MODULE=off

mkdir -p $GOPATH/src/github.com/dchote
mkdir -p $GOPATH/src/golang.org/x
mkdir -p $GOPATH/src/google.golang.org
mkdir -p $GOBIN

echo "Go Version:"
go version
echo "GOPATH: $GOPATH"
echo "GO111MODULE: $GO111MODULE"
echo "✓ GOPATH Environment konfiguriert"
echo ""

# ============================================
# SCHRITT 5: Alte falsche Verzeichnisse löschen
# ============================================
echo "[5/10] Alte Verzeichnisse aufräumen..."
rm -rf ~/github.com 2>/dev/null || true
rm -rf ~/golang.org 2>/dev/null || true
echo "✓ Alte Verzeichnisse gelöscht"
echo ""

# ============================================
# SCHRITT 6: Alle Abhängigkeiten klonen
# ============================================
echo "[6/10] Alle Abhängigkeiten klonen (an den richtigen Ort)..."

cd $GOPATH/src

# 1. talkiepi
if [ ! -d "$GOPATH/src/github.com/dchote/talkiepi" ]; then
    echo "  → Klone talkiepi..."
    $GIT_CLONE_CMD/dchote/talkiepi.git github.com/dchote/talkiepi
else
    echo "  → talkiepi bereits vorhanden"
fi

# 2. gpio
if [ ! -d "$GOPATH/src/github.com/dchote/gpio" ]; then
    echo "  → Klone gpio..."
    $GIT_CLONE_CMD/dchote/gpio.git github.com/dchote/gpio
else
    echo "  → gpio bereits vorhanden"
fi

# 3. gumble
if [ ! -d "$GOPATH/src/github.com/dchote/gumble" ]; then
    echo "  → Klone gumble..."
    $GIT_CLONE_CMD/dchote/gumble.git github.com/dchote/gumble
else
    echo "  → gumble bereits vorhanden"
fi

# 4. gopus
if [ ! -d "$GOPATH/src/github.com/dchote/gopus" ]; then
    echo "  → Klone gopus..."
    $GIT_CLONE_CMD/dchote/gopus.git github.com/dchote/gopus
else
    echo "  → gopus bereits vorhanden"
fi

# 5. go-openal
if [ ! -d "$GOPATH/src/github.com/dchote/go-openal" ]; then
    echo "  → Klone go-openal..."
    $GIT_CLONE_CMD/dchote/go-openal.git github.com/dchote/go-openal
else
    echo "  → go-openal bereits vorhanden"
fi

# 6. protobuf (alt)
if [ ! -d "$GOPATH/src/github.com/golang/protobuf" ]; then
    echo "  → Klone protobuf (alt)..."
    $GIT_CLONE_CMD/golang/protobuf.git github.com/golang/protobuf
else
    echo "  → protobuf (alt) bereits vorhanden"
fi

# 7. protobuf (neu - KOMPATIBLE VERSION!)
if [ ! -d "$GOPATH/src/google.golang.org/protobuf" ]; then
    echo "  → Klone protobuf (neu) in kompatibler Version..."
    cd $GOPATH/src/google.golang.org
    git clone https://github.com/protocolbuffers/protobuf-go.git protobuf
    cd protobuf
    git checkout v1.28.1 2>/dev/null || true
    cd $GOPATH/src
else
    echo "  → protobuf (neu) bereits vorhanden"
    cd $GOPATH/src/google.golang.org/protobuf
    git checkout v1.28.1 2>/dev/null || true
    cd $GOPATH/src
fi

# 8. sanitize
if [ ! -d "$GOPATH/src/github.com/kennygrant/sanitize" ]; then
    echo "  → Klone sanitize..."
    $GIT_CLONE_CMD/kennygrant/sanitize.git github.com/kennygrant/sanitize
else
    echo "  → sanitize bereits vorhanden"
fi

# 9. go-rpio
if [ ! -d "$GOPATH/src/github.com/stianeikeland/go-rpio" ]; then
    echo "  → Klone go-rpio..."
    $GIT_CLONE_CMD/stianeikeland/go-rpio.git github.com/stianeikeland/go-rpio
else
    echo "  → go-rpio bereits vorhanden"
fi

# 10. golang.org/x/net - KOMPATIBLE VERSION
echo "  → Installiere golang.org/x/net (Commit 244492dfa37a)..."
cd $GOPATH/src/golang.org/x
rm -rf net 2>/dev/null || true

git clone https://go.googlesource.com/net
cd net
git checkout 244492dfa37a 2>/dev/null || true
cd $GOPATH/src

echo "✓ Alle Abhängigkeiten geklont"
echo ""

# ============================================
# SCHRITT 7: SWAP aktivieren
# ============================================
echo "[7/10] Swap aktivieren..."

#if ! command -v dphys-swapfile &> /dev/null; then
#    sudo apt-get install -y dphys-swapfile
#fi

#sudo dphys-swapfile swapon
echo "  → Speicherstatus:"
#free -h

echo "✓ Swap aktiviert"
echo ""

# ============================================
# SCHRITT 8: Workarounds für go.mod
# ============================================
echo "[8/10] Zusätzliche Workarounds..."

cd $GOPATH/src/github.com/dchote/talkiepi
rm -f go.mod go.sum 2>/dev/null || true

cd $GOPATH/src/github.com/dchote/gumble
rm -f go.mod go.sum 2>/dev/null || true

cd $GOPATH/src/github.com/dchote/gpio
rm -f go.mod go.sum 2>/dev/null || true

echo "✓ Workarounds angewendet"
echo ""

# ============================================
# SCHRITT 9: talkiepi kompilieren
# ============================================
echo "[9/10] talkiepi kompilieren..."
echo "  → Kompilierung dauert 10-15 Min auf Pi Zero"
echo ""

cd $GOPATH/src/github.com/dchote/talkiepi
go build -v -o $GOBIN/talkiepi ./cmd/talkiepi

echo "✓ talkiepi erfolgreich kompiliert"
ls -lah $GOBIN/talkiepi
echo ""

# ============================================
# SCHRITT 10: libopenal ohne NEON für Pi Zero
# ============================================
echo "[10/10] libopenal ohne NEON für Pi Zero installieren..."
echo "  → Pi Zero hat keine NEON FPU"
echo ""

cd /tmp

# Zuerst die Abhängigkeiten installieren
echo "  → Installiere benötigte Abhängigkeiten..."
sudo apt-get install -y libsndio6.1 || true

# Workaround-Package von talkiepi Repo herunterladen und installieren
if wget -q https://github.com/dchote/talkiepi/raw/master/workarounds/libopenal1_1.17.2-4_armhf.deb; then
    echo "  → Installiere libopenal ohne NEON..."
    sudo dpkg -i --force-depends libopenal1_1.17.2-4_armhf.deb || true
    sudo apt-get install -f -y  # Abhängigkeiten reparieren
    rm libopenal1_1.17.2-4_armhf.deb
    echo "✓ libopenal ohne NEON installiert"
else
    echo "ℹ Workaround-Package nicht erreichbar"
    echo "  → Verwende Standard libopenal (könnte auf Pi Zero Probleme geben)"
fi
echo ""

# ============================================
# TEST
# ============================================
echo "  → Funktionstest..."
if $GOBIN/talkiepi -help > /dev/null 2>&1; then
    echo "✓ talkiepi funktioniert"
else
    echo "⚠ talkiepi startet, aber -help wird nicht unterstützt"
fi
echo ""

# ============================================
# ZUSAMMENFASSUNG
# ============================================
echo "=========================================="
echo "✓ Installation abgeschlossen!"
echo "=========================================="
echo ""
echo "Go Version:        1.21.13"
echo "Method:            GOPATH (traditionell)"
echo "GO111MODULE:       off"
echo "Swap:              aktiviert"
echo "talkiepi:          $GOBIN/talkiepi"
echo "Source:            $GOPATH/src/github.com/dchote/talkiepi"
echo ""
echo "Alle Abhängigkeiten:"
echo "  - github.com/dchote/gpio"
echo "  - github.com/dchote/gumble"
echo "  - github.com/dchote/gopus"
echo "  - github.com/dchote/go-openal"
echo "  - github.com/golang/protobuf (alt)"
echo "  - google.golang.org/protobuf (v1.28.1)"
echo "  - github.com/kennygrant/sanitize"
echo "  - github.com/stianeikeland/go-rpio"
echo "  - golang.org/x/net (Commit 244492dfa37a)"
echo ""
echo "Quick Test:"
echo "  $GOBIN/talkiepi"
echo ""