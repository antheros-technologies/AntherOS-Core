#!/usr/bin/env bash
# ==============================================================================
# Project: AntherOS System Transformer
# Description: Converts a clean Pop!_OS installation into AntherOS by 
#              overriding configurations, themes, packages, and flatpaks.
# ==============================================================================

set -eo pipefail

# --- Color Definitions ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Logging Helpers ---
print_info()    { echo -e "${BLUE}${BOLD}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}${BOLD}[SUCCESS]${NC} $1"; }
print_warn()    { echo -e "${YELLOW}${BOLD}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}${BOLD}[ERROR]${NC} $1"; }

# --- Banner ---
clear
echo -e "${CYAN}${BOLD}"
cat "$SOURCE_DIR/ascii"
echo -e "${NC}"
echo -e "${BOLD}==> [AntherOS Transformer] Initializing system overlay...${NC}\n"

# --- Validation: Operating System ---
OS_NAME=$(awk -F= '$1=="NAME" {print $2}' /etc/os-release | tr -d '"')
if [[ "$OS_NAME" == "Pop!_OS" ]]; then
    print_info "Target OS verified: Pop!_OS detected."
else
    print_error "Unsupported OS ('$OS_NAME'). This script is designed exclusively for Pop!_OS."
    exit 1
fi

# --- Validation: Root Privileges ---
if [[ "$EUID" -ne 0 ]]; then
    print_error "Privilege check failed. Please run with sudo: sudo ./build.sh"
    exit 1
fi



# --- Step 1: Wallpapers (Override) ---
print_info "[1/6] Overriding system wallpapers..."
mkdir -p /usr/share/backgrounds/cosmic/
rm -rf /usr/share/backgrounds/cosmic/*
if [[ -d "$SOURCE_DIR/wallpapers" ]]; then
    cp -r "$SOURCE_DIR/wallpapers/"* /usr/share/backgrounds/cosmic/
    print_success "Wallpapers overridden successfully."
else
    print_warn "'wallpapers' directory not found in source."
fi

# --- Step 2: Plymouth Theme (Override) ---
print_info "[2/6] Overriding Plymouth boot theme (anther-default)..."
PLYMOUTH_DIR="/usr/share/plymouth/themes/anther-default"
mkdir -p "$PLYMOUTH_DIR"
rm -rf "${PLYMOUTH_DIR:?}"/*
if [[ -d "$SOURCE_DIR/anther-default" ]]; then
    cp -r "$SOURCE_DIR/anther-default/"* "$PLYMOUTH_DIR/"
    if command -v plymouth-set-default-theme &> /dev/null; then
        plymouth-set-default-theme -R anther-default
        print_success "Plymouth theme applied and initramfs rebuilt."
    else
        print_warn "plymouth-set-default-theme command not found."
    fi
else
    print_warn "'anther-default' directory not found in source."
fi

# --- Step 3: COSMIC Configurations (Override) ---
print_info "[3/6] Overriding COSMIC desktop layouts to /etc/skel..."
if [[ -d "$SOURCE_DIR/skel/.config/cosmic" ]]; then
    mkdir -p /etc/skel/.config/cosmic
    rm -rf /etc/skel/.config/cosmic/*
    cp -r "$SOURCE_DIR/skel/.config/cosmic/"* /etc/skel/.config/cosmic/
    chown -R root:root /etc/skel/.config/cosmic
    print_success "COSMIC skeleton configurations overridden."
fi

# --- Step 4: Package Management (Purge & Install) ---
print_info "[4/6] Managing APT package footprint..."
if [[ -f "$SOURCE_DIR/removed_packages.txt" && -s "$SOURCE_DIR/removed_packages.txt" ]]; then
    print_info "Purging unneeded system packages..."
    xargs apt-get purge -y < "$SOURCE_DIR/removed_packages.txt" || true
fi

if [[ -f "$SOURCE_DIR/installed_packages.txt" && -s "$SOURCE_DIR/installed_packages.txt" ]]; then
    print_info "Installing custom package list..."
    apt-get update -qq
    xargs apt-get install -y < "$SOURCE_DIR/installed_packages.txt" || true
fi

add-apt-repository -y ppa:anagh9090/antheros
add-apt-repository -y ppa:anagh9090/bolt

apt-get update -y
apt-get install antheros bolt -y

# --- Step 5: Flatpak System-Wide Deployment ---
print_info "[5/6] Installing Flatpaks system-wide..."
if command -v flatpak &> /dev/null; then
    # Ensure Flathub repository is enabled system-wide
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
    if [[ -f "$SOURCE_DIR/flatpaks.txt" && -s "$SOURCE_DIR/flatpaks.txt" ]]; then
        while IFS= read -r app_id; do
            # Skip empty lines or comments
            [[ -z "$app_id" || "$app_id" =~ ^# ]] && continue
            print_info "Installing Flatpak: $app_id"
            flatpak install -y --system flathub "$app_id" || print_warn "Failed to install $app_id"
        done < "$SOURCE_DIR/flatpaks.txt"
        print_success "All Flatpaks processed successfully."
    else
        print_warn "flatpaks.txt not found or empty."
    fi
else
    print_warn "Flatpak is not installed on this system. Skipping Flatpak deployment."
fi

# --- Step 6: System Cleanup ---
print_info "[6/6] Performing system cache cleanup..."
apt-get clean -qq
apt-get autoremove -y -qq

echo -e "\n${GREEN}${BOLD}==================================================${NC}"
echo -e "${GREEN}${BOLD}==> AntherOS system transformation complete!${NC}"
echo -e "${BLUE}${BOLD}==> Reboot to see the changes!${NC}"
echo -e "${GREEN}${BOLD}==================================================${NC}\n"
