<div align="center">

# AntherOS

<p align="center">
  <b>A Refined, Open-Source Desktop Operating System Built on Pop!\_OS and COSMIC</b>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#repository-structure">Repository Structure</a> •
  <a href="#prerequisites">Prerequisites</a> •
  <a href="#installation--usage">Build Instructions</a> •
  <a href="#how-it-works">Execution Pipeline</a> •
  <a href="#license">License</a>
</p>

---

</div>

<h2 id="about">About AntherOS</h2>

AntherOS is an open-source, custom Linux distribution transform engine designed to overlay a clean **Pop!\_OS** installation with custom desktop configurations, custom boot animations, curated wallpapers, and automated package and Flatpak management. 

Instead of distributing static pre-baked ISO images, this repository provides a fully reproducible transformation pipeline. Anyone running Pop!\_OS can execute the project automation scripts to transform their environment into an authentic AntherOS desktop instance.

<br>

<h2 id="repository-structure">Repository Structure</h2>

```
AntherOS/
├── AntherOS_PPAs/              # Source code for custom Debian packages and PPA repositories
│   ├── AntherOS/               # Primary AntherOS metapackage definitions
│   └── bolt/                   # System utilities and custom desktop helpers
└── source/                     # System overlay source tree and execution scripts
    ├── anther-default/         # Plymouth boot theme assets and configuration
    ├── wallpapers/             # Official AntherOS background collection
    ├── skel/                   # Skeleton configuration directory for new user profiles
    ├── flatpaks.txt            # System-wide Flatpak application manifest
    ├── installed_packages.txt  # Custom APT package manifest
    ├── removed_packages.txt    # Manifest of upstream packages marked for removal
    ├── modified_system_files.txt # System file override references
    ├── cosmic-desktop-settings.ini # Exported dconf / gsettings overrides
    └── build.sh                # Main automated system transformation script
```

<br>

<h2 id="prerequisites">Prerequisites</h2>

Before deploying the transformation script, ensure your build environment satisfies the following system requirements:

<table>
  <thead>
    <tr>
      <th>Component</th>
      <th>Requirement</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Operating System</b></td>
      <td>Pop!\_OS 22.04 LTS or newer (COSMIC Desktop Environment)</td>
    </tr>
    <tr>
      <td><b>Privileges</b></td>
      <td>Administrative privileges (sudo / root access required)</td>
    </tr>
    <tr>
      <td><b>Package Managers</b></td>
      <td><code>apt</code> and <code>flatpak</code> installed and configured</td>
    </tr>
    <tr>
      <td><b>Network Access</b></td>
      <td>Active internet connection (required for APT and Flathub synchronization)</td>
    </tr>
  </tbody>
</table>

<br>

<h2 id="installation--usage">Installation & Build Instructions</h2>

<ol>
  <li>
    <b>Clone the repository:</b>
    <pre><code>git clone https://github.com/your-username/AntherOS.git
cd AntherOS/source</code></pre>
  </li>
  <li>
    <b>Export your system Flatpak manifest (optional for custom builds):</b>
    <pre><code>{ ls -1 /var/lib/flatpak/app/ 2>/dev/null; ls -1 ~/.local/share/flatpak/app/ 2>/dev/null; } | sort -u > flatpaks.txt</code></pre>
  </li>
  <li>
    <b>Make the build script executable:</b>
    <pre><code>chmod +x build.sh</code></pre>
  </li>
  <li>
    <b>Execute the system transformation:</b>
    <pre><code>sudo ./build.sh</code></pre>
  </li>
</ol>

<br>

<h2 id="how-it-works">Execution Pipeline</h2>

The <code>build.sh</code> script executes a six-stage automated pipeline to convert the host machine into AntherOS:

<dl>
  <dt><b>Stage 1: Wallpaper Deployment</b></dt>
  <dd>Purges existing background files in <code>/usr/share/backgrounds/cosmic/</code> and injects the curated AntherOS wallpaper suite.</dd>
  
  <dt><b>Stage 2: Plymouth Boot Theme Configuration</b></dt>
  <dd>Installs the custom <code>anther-default</code> splash screen theme to <code>/usr/share/plymouth/themes/</code> and regenerates the system <code>initramfs</code>.</dd>

  <dt><b>Stage 3: Desktop Configuration Overrides</b></dt>
  <dd>Deploys custom COSMIC desktop profiles into <code>/etc/skel/.config/cosmic/</code> to guarantee consistent layout defaults for all new system users.</dd>

  <dt><b>Stage 4: APT Package Reconciliation</b></dt>
  <dd>Reads <code>removed_packages.txt</code> to purge specified default packages, then reads <code>installed_packages.txt</code> to install all requested software dependencies.</dd>

  <dt><b>Stage 5: System-Wide Flatpak Deployment</b></dt>
  <dd>Ensures the Flathub remote repository is active and installs all applications listed in <code>flatpaks.txt</code> at the system level.</dd>

  <dt><b>Stage 6: System Cache Cleanup</b></dt>
  <dd>Performs <code>autoremove</code> and purges temporary APT package archives to ensure a clean system state.</dd>
</dl>

<br>

<h2 id="license">License & Attributions</h2>

<ul>
  <li><b>AntherOS Source Scripts & Configuration:</b> Released under the <a href="LICENSE">GPL-3.0 License</a>.</li>
  <li><b>Base Operating System:</b> <a href="https://github.com/pop-os">Pop!\_OS</a>, developed by System76.</li>
  <li><b>Desktop Environment:</b> <a href="https://github.com/pop-os/cosmic-epoch">COSMIC Desktop Environment</a>.</li>
</ul>

---

<div align="center">
  <sub>Maintained by the AntherOS Development Team</sub>
</div>
