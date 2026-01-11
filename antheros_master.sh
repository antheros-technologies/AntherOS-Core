#!/bin/bash

echo "🚀 Starting the Ultimate AntherOS Build..."

# 1. IDENTITY & RENAMING
echo "🏷️  Renaming system to AntherOS..."
sed -i 's/Ubuntu/AntherOS/g' /etc/lsb-release
sed -i 's/Ubuntu/AntherOS/g' /etc/os-release
echo "AntherOS" > /etc/hostname

# Rename the Installer icon on the desktop
if [ -f /usr/share/applications/ubiquity.desktop ]; then
    sed -i 's/Name=Install .*/Name=Install AntherOS/g' /usr/share/applications/ubiquity.desktop
fi

# 2. REMOVE BLOATWARE
echo "🧹 Removing bloatware..."
apt purge -y snapd gnome-software-plugin-snap aisleriot gnome-mahjongg gnome-mines gnome-sudoku
apt autoremove -y

# 3. CORE GAMING & SYSTEM TOOLS
echo "🎮 Installing Gaming Essentials..."
add-apt-repository ppa:graphics-drivers/ppa -y
apt update
apt install -y steam-installer wine mesa-utils vulkan-tools git build-essential mangohud zenity wget unzip openjdk-17-jre

# 4. DISCORD INSTALLATION
echo "💬 Installing Discord..."
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
apt install -y /tmp/discord.deb
rm /tmp/discord.deb

# 5. TLAUNCHER INSTALLATION
echo "🧱 Installing TLauncher..."
mkdir -p /opt/tlauncher
wget -O /tmp/tlauncher.zip "https://tlauncher.org/jar"
unzip /tmp/tlauncher.zip -d /opt/tlauncher/
JAR_NAME=$(ls /opt/tlauncher | grep .jar)

# Create TLauncher Desktop Shortcut
cat <<WEOF > /usr/share/applications/tlauncher.desktop
[Desktop Entry]
Name=TLauncher
Comment=Minecraft Launcher
Exec=java -jar /opt/tlauncher/$JAR_NAME
Terminal=false
Type=Application
Icon=controller
Categories=Game;
WEOF

# 6. CUSTOM WALLPAPER
echo "🖼️  Setting custom wallpaper..."
mkdir -p /usr/share/backgrounds/antheros
wget -O /usr/share/backgrounds/antheros/wallpaper.png "https://i.ibb.co/cSvf1Zf9/antheros-wallpaper.png"

# Force wallpaper via GSettings override
cat <<WEOF > /usr/share/glib-2.0/schemas/99_antheros_wallpaper.gschema.override
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/antheros/wallpaper.png'
picture-uri-dark='file:///usr/share/backgrounds/antheros/wallpaper.png'
options='zoom'
WEOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# 7. FIRST-BOOT WELCOME SCRIPT
echo "👋 Creating Welcome Script..."
cat <<'WEOF' > /usr/local/bin/antheros-welcome.sh
#!/bin/bash
sleep 8
zenity --info --title="AntherOS MK1" --text="Welcome to AntherOS!\n\nSteam, Discord, and TLauncher are ready.\n\nEnjoy your custom gaming OS!" --width=350
rm ~/.config/autostart/antheros-welcome.desktop
WEOF
chmod +x /usr/local/bin/antheros-welcome.sh

# Set to autostart for new users (via /etc/skel)
mkdir -p /etc/skel/.config/autostart
cat <<WEOF > /etc/skel/.config/autostart/antheros-welcome.desktop
[Desktop Entry]
Type=Application
Exec=/usr/local/bin/antheros-welcome.sh
Name=AntherOS Welcome
WEOF

echo "✅ ALL DONE! Type 'exit' to finish your ISO."
