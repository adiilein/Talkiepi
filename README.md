talkiepi - Automatische Installation für Raspberry Pi Zero
Dieses Bash-Skript installiert talkiepi – einen Mumble-Client für Sprachkommunikation – vollautomatisch auf einem Raspberry Pi Zero.

✨ Was das Skript macht
Systemaktualisierung – Aktualisiert alle Pakete und installiert benötigte Systembibliotheken

Go 1.21.13 Installation – Lädt und installiert Go speziell für ARMv6 (Raspberry Pi Zero)

GOPATH-basierte Umgebung – Richtet das klassische Go-Entwicklungsumfeld ein (ohne Go Modules)

Alle Abhängigkeiten klonen – Holt automatisch alle benötigten Repositories in der richtigen Version:

talkiepi (Hauptprojekt)

gpio, gumble, gopus, go-openal (Audio/GPIO-Bibliotheken)

protobuf (alt + neu v1.28.1 kompatibel)

sanitize, go-rpio, golang.org/x/net (weitere Hilfsbibliotheken)

Workarounds für den Pi Zero – Entfernt inkompatible go.mod-Dateien und installiert eine NEON-freie libopenal-Version

Swap-Aktivierung – Erhöht den Arbeitsspeicher durch Swap, um die Kompilierung zu ermöglichen

Kompilierung – Baut talkiepi in etwa 10–15 Minuten direkt auf dem Pi Zero

Funktionstest – Prüft, ob die ausführbare Datei funktioniert

🧩 Voraussetzungen
Raspberry Pi Zero (oder ähnliches ARMv6-System)

ReSpeaker 2-Mic HAT (oder kompatibles Audio-Interface)

Raspberry Pi OS (Debian-basiert)

Internetverbindung

Optional: GitHub Personal Access Token für private Repositories

🚀 Verwendung
bash
# Skript herunterladen und ausführbar machen
wget -O talkiepi_install.sh <URL-zum-Skript>
chmod +x talkiepi_install.sh

# Installation starten
./talkiepi_install.sh
🔧 Besonderheiten
Feature	Beschreibung
Go-Version	1.21.13 (letzte Version mit ARMv6-Support)
Build-Methode	Traditioneller GOPATH-Ansatz (GO111MODULE=off)
Protobuf	Verwendet die kompatible Version v1.28.1
libopenal	Ohne NEON-Instruktionen für den Pi Zero
Swap	Aktiviert temporären Swap für die Kompilierung
📦 Enthaltene Komponenten
talkiepi – Mumble-Client für Einplatinencomputer

gumble – Mumble-Protokoll-Implementierung in Go

go-openal – OpenAL-Bindings für Audioausgabe

gopus – Opus-Codec-Unterstützung

gpio – GPIO-Steuerung für Taster/LEDs

protobuf – Google Protocol Buffers für Netzwerkkommunikation

⚠️ Hinweise
Die Kompilierung dauert auf dem Pi Zero 10–15 Minuten

Ein GitHub Token kann für private Repositories im Skript eingetragen werden

Das Skript ist für Bash optimiert und setzt set -e für Fehlerabbruch

📄 Lizenz
Dieses Skript steht unter der MIT-Lizenz – du darfst es verwenden, anpassen und weitergeben.

🔗 Weitere Informationen: talkiepi GitHub Repository

Entwickelt für den Einsatz in Mumble-Sprachsystemen mit dem Raspberry Pi Zero.

gib mir bitte noch eine readme.md für github für dieses script
Hier ist eine vollständige README.md für dein GitHub-Repository:

markdown
# 🎙️ talkiepi Installer für Raspberry Pi Zero

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Go Version](https://img.shields.io/badge/Go-1.21.13-blue.svg)](https://golang.org/)
[![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi%20Zero-green.svg)](https://www.raspberrypi.org/)

> Automatische Installation von talkiepi auf dem Raspberry Pi Zero

Dieses Skript installiert **talkiepi** – einen Mumble-Client für Sprachkommunikation – vollautomatisch auf einem **Raspberry Pi Zero** mit **ReSpeaker 2-Mic HAT**.

---

## 📋 Inhaltsverzeichnis

- [Über das Projekt](#-über-das-projekt)
- [Voraussetzungen](#-voraussetzungen)
- [Installation](#-installation)
- [Was das Skript macht](#-was-das-skript-macht)
- [Technische Details](#-technische-details)
- [Fehlerbehebung](#-fehlerbehebung)
- [Lizenz](#-lizenz)
- [Kontakt](#-kontakt)

---

## 🎯 Über das Projekt

**talkiepi** ist ein Mumble-Client, der speziell für Einplatinencomputer wie den Raspberry Pi entwickelt wurde. Dieses Installationsskript automatisiert den gesamten Setup-Prozess und berücksichtigt dabei die speziellen Anforderungen des **Raspberry Pi Zero**:

- ARMv6-Architektur (keine NEON-Erweiterungen)
- Begrenzter Arbeitsspeicher (512 MB)
- ReSpeaker 2-Mic HAT für Audio-Ein- und Ausgabe

---

## 📦 Voraussetzungen

### Hardware
- 🖥️ **Raspberry Pi Zero** (oder Zero W/WH)
- 🎤 **ReSpeaker 2-Mic HAT** (oder kompatibles Audio-Interface)
- 💾 **Micro-SD-Karte** (mindestens 8 GB)
- 🔌 **Stromversorgung** (5V / 2.5A empfohlen)

### Software
- 🐧 **Raspberry Pi OS** (Debian Bullseye oder neuer)
- 🌐 **Internetverbindung** (für den Download der Abhängigkeiten)
- 🔑 **GitHub Token** (optional, für private Repositories)

---

## 🚀 Installation

### 1. Skript herunterladen

```bash
# Skript herunterladen
wget -O talkiepi_install.sh https://raw.githubusercontent.com/adiilein/talkiepi-installer/main/talkiepi_install.sh

# Ausführbar machen
chmod +x talkiepi_install.sh
2. GitHub Token einfügen (optional)
Öffne die Datei und ersetze GITHUB_TOKEN mit deinem persönlichen Access-Token:

bash
nano talkiepi_install.sh
bash
GITHUB_TOKEN="ghp_dein_persönlicher_token_hier"
Hinweis: Ein Token ist nur erforderlich, wenn du auf private Repositories zugreifen musst.

3. Installation starten
bash
sudo ./talkiepi_install.sh
Die Installation dauert auf dem Pi Zero etwa 10–15 Minuten.

🔧 Was das Skript macht
Schritt	Aktion	Beschreibung
1	System aktualisieren	apt-get update & upgrade + I2C-Tools
2	Bibliotheken installieren	libopenal, libopus, libasound2, build-essential, etc.
3	Go 1.21.13 installieren	Speziell für ARMv6 (Pi Zero)
4	GOPATH einrichten	Traditionelles Go-Environment (GO111MODULE=off)
5	Alte Verzeichnisse löschen	Bereinigt fehlerhafte Pfade aus früheren Installationen
6	Abhängigkeiten klonen	Holt alle benötigten Repositories in kompatiblen Versionen
7	Swap aktivieren	Erhöht den verfügbaren Arbeitsspeicher für die Kompilierung
8	Workarounds anwenden	Entfernt inkompatible go.mod-Dateien
9	talkiepi kompilieren	Baut die ausführbare Datei
10	libopenal patchen	Installiert NEON-freie Version für Pi Zero
🛠️ Technische Details
Go-Installation
bash
Version:    1.21.13
Architektur: ARMv6
Methode:    Traditioneller GOPATH-Ansatz
GO111MODULE: off
GOPATH:     $HOME/gocode
Abhängigkeiten
Repository	Version/Branch	Zweck
talkiepi	main	Hauptprojekt
gpio	main	GPIO-Steuerung
gumble	main	Mumble-Protokoll
gopus	main	Opus-Codec
go-openal	main	Audio-Ausgabe
protobuf	alt	Protocol Buffers (legacy)
protobuf-go	v1.28.1	Protocol Buffers (modern)
sanitize	main	Textbereinigung
go-rpio	main	GPIO (Alternative)
golang.org/x/net	244492dfa37a	Netzwerkbibliothek
Spezielle Anpassungen für Pi Zero
Keine NEON-Unterstützung: Der Pi Zero hat keine NEON-FPU. Das Skript installiert eine spezielle libopenal-Version ohne NEON-Instruktionen.

Swap-Aktivierung: 512 MB RAM reichen nicht für die Kompilierung aus – das Skript aktiviert temporären Swap. Punkt 7 im Skript, evtl. deaktivieren falls die Installation fehlschlägt 

ARMv6 Go-Version: Go 1.21.13 ist die letzte Version, die ARMv6 unterstützt.

🐛 Fehlerbehebung
Problem: "Illegal instruction" beim Start
bash
# Lösung: libopenal neu installieren
sudo apt-get remove --purge libopenal1
sudo apt-get install libopenal1
Problem: "go: command not found"
bash
# Lösung: Go-Pfad neu laden
source ~/.profile
go version
Problem: Kompilierung schlägt fehl (Out of Memory)
bash
# Lösung: Swap manuell erhöhen
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Ändere CONF_SWAPSIZE=1024
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
Problem: Kein Audio auf dem ReSpeaker
bash
# Lösung: I2C und Audio-Interface prüfen
sudo i2cdetect -y 1
# Sollte die Adresse 0x1a anzeigen

# Alsa-Konfiguration prüfen
aplay -l
arecord -l
Problem: GitHub-Rate-Limit überschritten
bash
# Lösung: GitHub Token verwenden (im Skript eintragen)
# Oder: Warte eine Stunde, bis das Limit zurückgesetzt wird
📄 Lizenz
Dieses Projekt steht unter der MIT-Lizenz. Siehe LICENSE für weitere Informationen.

🤝 Beitrag leisten
Beiträge sind willkommen! So kannst du helfen:

Forke das Repository

Erstelle einen neuen Branch (git checkout -b feature/verbesserung)

Committe deine Änderungen (git commit -m 'Füge neue Funktion hinzu')

Pushe den Branch (git push origin feature/verbesserung)

Erstelle einen Pull Request
