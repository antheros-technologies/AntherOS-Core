# AntherOS
The flagship operating system from **AntherOS Technologies**.

## About
AntherOS is a PopOS-based Linux distribution 
designed for Speed and Gaming.

## Leadership
* **Founder & Lead Developer:** Anagh Barnwal
* **Organization:** AntherOS Technologies

## License
This project is licensed under the GPL-2.0 License - see the LICENSE file for details.

## How to build
If you want to build **AntherOS**, then follow these steps:
* First create a 30 gb space on your hard drive (Or if you have currently PopOS 24.04 LTS, or a slightly older version, then you can skip straight to the code section).
* Then install **PopOS 24.04 LTS** on the newly created partition.
* Then copy-paste these code blocks (while booted from PopOS 24.04 LTS:
  ```
  sudo dpkg --add-architecture i386
  sudo apt update && sudo apt upgrade
  
  cat <<EOF> package.list
  sl
  cmatrix
  cheese
  steam 
  lutris
  gamemode
  mangohud
  goverlay
  vulkan-tools
  vlc
  btop
  neofetch
  timeshift
  libgl1-mesa-dri:i386 libgl1-mesa-glx:i386
  libvulkan1:i386
  plymouth
  plymouth-themes
  initramfs-tools
  openjdk-21-jdk
  EOF
  
  wget -O wallpaper.zip https://github.com/antheros-technologies/AntherOS-Core/raw/refs/heads/main/wallpaper.zip
  sudo rm -rf /usr/share/backgrounds/cosmic/*
  sudo unzip wallpaper.zip /usr/share/backgrounds/cosmic/
  clear
  echo "Now you may need to go to cosmic settings, and then Desktop -> Wallpaper -> Slideshow On/Off, and make sure the new wallpapers are indexed."
  sleep 5
  clear
  
  sudo cat <<EOF> /etc/os-release
  NAME="AntherOS"
  VERSION="24.04 LTS"
  ID=antheros
  ID_LIKE="ubuntu debian"
  PRETTY_NAME="AntherOS 24.04 LTS"
  VERSION_ID="24.04"
  HOME_URL="https://antheros.in"
  SUPPORT_URL="https://antheros.in/support"
  BUG_REPORT_URL="https://antheros.in/issues"
  PRIVACY_POLICY_URL="https://antheros.in/privacy"
  VERSION_CODENAME=noble
  UBUNTU_CODENAME=noble
  LOGO=distributor-logo-antheros-os
  EOF
  
  sudo cat <<EOF>/etc/lsb-release
  DISTRIB_ID=AntherOS
  DISTRIB_RELEASE=24.04
  DISTRIB_CODENAME=noble
  DISTRIB_DESCRIPTION="AntherOS 24.04 LTS Gaming Edition"
  EOF
  
  while read -r package; do
    sudo apt install -y "$package"
  done < package.list
  cat <<EOF> plymouth.sh
  wget https://github.com/anagh9090/Anther-Default-Plymouth/releases/download/1.0.0/Anther-Default-Plymouth.zip
  sudo mv Anther-Default-Plymouth.zip /usr/share/plymouth/themes
  sudo unzip /usr/share/plymouth/themes/Anther-Default-Plymouth.zip
  sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/anther-default/anther-default.plymouth 100
  sudo plymouth-set-default-theme anther-default
  sudo update-initramfs -u
  if [ 2 -eq 0 ]; then
    echo "Anther-Default plymouth theme has been applied succesfully."
  else
    echo "Failed"
  chmod +x plymouth.sh
  ./plymouth.sh

  echo "Done! But this script doesnt have the system level configurations that can break your system!"
  ```
* Run this script (I would recommend to make a `script.sh` file, then paste the entire code block and then type `chmod +x script.sh` and then to run `./script.sh`."
### By Anagh
