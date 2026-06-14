# 🎥 OBS Safe Launch Utility

<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-Automation-blue?style=for-the-badge&logo=powershell" />
  <img src="https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows" />
   <img src="https://img.shields.io/badge/OBS-Studio-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Network-Utility-green?style=for-the-badge&logo=icloud" />
  <img src="https://img.shields.io/badge/Status-Stable-brightgreen?style=for-the-badge" />
</p>

<p align="center">
  <strong>Security-focused launcher for OBS Studio that validates plugin integrity, applies temporary firewall protections, verifies installation state, and safely manages OBS sessions.</strong>
</p>

---

## 🏗️ Architecture Overview

<p align="center">
  <img src="https://raw.githubusercontent.com/tcdoverlord/obs-safe-launch-utility/main/OBS%20Safe%20Launch%20Utility%20overview.png" alt="OBS Safe Launch Utility Architecture Overview" width="100%">
</p>

---

# 🚀 Features

## 🔒 Plugin Integrity Protection

* SHA256 plugin hash validation
* Baseline generation and verification
* Detection of new plugins
* Detection of modified plugins
* Detection of missing plugins
* OBS version awareness

---

## 🛡️ Session Security

* Temporary firewall rule management
* OBS outbound rule creation
* OBSBOT inbound protection
* Automatic cleanup of temporary rules

---

## 📋 Logging

* Security event logging
* Plugin validation events
* Launch tracking
* Session completion records

---

## ▶️ Safe Launch Process

* Validates OBS installation
* Verifies plugin state
* Checks version changes
* Applies temporary protections
* Launches OBS Studio
* Cleans up security rules after exit

---

# 🚀 Quick Start

## Step 1

Create:

```text
C:\Update Code
```

## Step 2

Place:

```text
OBS-Safe-Launch.ps1
```

inside:

```text
C:\Update Code
```

## Step 3

Open PowerShell as Administrator.

## Step 4

Run:

```powershell
cd "C:\Update Code"
Unblock-File .\OBS-Safe-Launch.ps1
.\OBS-Safe-Launch.ps1
```

Or run everything at once:

```powershell
cd "C:\Update Code"; Unblock-File .\OBS-Safe-Launch.ps1; .\OBS-Safe-Launch.ps1
```

---

# 🏁 First Launch

When executed for the first time, the utility creates a trusted baseline of installed OBS plugins.

Generated files:

```text
OBS-Plugin-Hashes.json
OBS-Version.txt
OBS-Security.log
```

These files are generated automatically and should not normally be committed to source control.

---

# 🔄 Startup Workflow

```text
Validate OBS Installation
        ↓
Check OBS Version
        ↓
Verify Plugin Integrity
        ↓
Apply Temporary Firewall Rules
        ↓
Launch OBS Studio
        ↓
Monitor Session
        ↓
Remove Temporary Rules
        ↓
Exit
```

---

# 📂 Log Location

Security events are recorded in:

```text
C:\Update Code\OBS-Security.log
```

The log contains:

* Plugin validation events
* Security alerts
* Launch activity
* Firewall actions
* Session completion records

---

# ⚠️ Important Notes

* Do not manually edit generated hash files
* Do not replace plugins without rebuilding the baseline
* Do not commit generated logs to source control
* Do not disable Windows Firewall while using this utility

---

# 🏗️ Project Purpose

This project demonstrates:

* PowerShell Automation
* Application Integrity Validation
* Windows Firewall Administration
* Security Monitoring
* Secure Application Launching
* Security Event Logging

---

# 📁 Repository Structure

```text
obs-safe-launch-utility/
│
├── OBS-Safe-Launch.ps1
├── README.md
├── LICENSE
└── OBS Safe Launch Utility overview.png
```

---

# 👨‍💻 Author

**TCDOverLord**

GitHub: https://github.com/tcdoverlord

---

# 📜 License

Licensed under the MIT License.
