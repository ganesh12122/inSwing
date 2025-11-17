# Docker Desktop Installation Guide for Windows

## 🎯 Installation Steps

### Option 1: Microsoft Store (Recommended)
1. **Open Microsoft Store** on your Windows
2. **Search for "Docker Desktop"**
3. **Click "Get"** to install
4. **Wait for installation** to complete
5. **Restart your computer** when prompted

### Option 2: Direct Download
1. **Download from Docker Website**: https://docs.docker.com/desktop/setup/install/windows-install/
2. **Run the installer**: Docker Desktop Installer.exe
3. **Follow setup wizard**:
   - ✅ Enable WSL 2 instead of Hyper-V (recommended)
   - ✅ Add to PATH if prompted
4. **Restart computer** when installation completes

## 🔧 Post-Installation Setup

### 1. Launch Docker Desktop
- Start Docker Desktop from Start Menu
- Accept the license agreement
- Sign in with Docker Hub account (optional but recommended)

### 2. Verify Installation
Open PowerShell and run:
```powershell
docker --version
docker run hello-world
```

### 3. WSL 2 Configuration (if needed)
```powershell
# Check WSL version
wsl --version

# Update WSL
wsl --update

# Set WSL 2 as default
wsl --set-default-version 2
```

## 🐳 Docker Compose Setup

Docker Compose is included with Docker Desktop. Verify:
```powershell
docker-compose --version
```

## 📋 System Requirements

**Minimum Requirements:**
- Windows 10 22H2 (build 19045) or Windows 11 23H2 (build 22631)
- 4GB system RAM
- 64-bit processor with SLAT
- Hardware virtualization enabled in BIOS

**Recommended:**
- 8GB+ RAM for smooth operation
- SSD storage for better performance
- Stable internet connection

## 🚨 Troubleshooting

### Common Issues:
1. **WSL 2 not installed**: Install from Microsoft Store
2. **Virtualization disabled**: Enable in BIOS settings
3. **Hyper-V conflicts**: Disable Hyper-V if using WSL 2
4. **Port conflicts**: Check for other services on ports 80, 443

### Need Help?
- Docker Documentation: https://docs.docker.com/desktop/
- Windows Installation Guide: https://docs.docker.com/desktop/setup/install/windows-install/

## ⏱️ Installation Time: ~10-15 minutes

**Status**: Ready to proceed once Docker is installed! 🚀