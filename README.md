# 🎥 OBS Safe Launch Utility

Security-focused launcher for OBS Studio that validates plugin integrity, applies temporary firewall protections, verifies installation state, and safely manages OBS sessions.

---

# 🚀 Features

## 🔒 Plugin Integrity Protection

➜ SHA256 plugin hash validation

➜ Baseline generation and verification

➜ Detection of new plugins

➜ Detection of modified plugins

➜ Detection of missing plugins

➜ OBS version awareness

---

## 🛡️ Session Security

➜ Temporary firewall rule management

➜ OBS outbound rule creation

➜ OBSBOT inbound protection

➜ Automatic cleanup of temporary rules

---

## 📋 Logging

➜ Security event logging

➜ Plugin validation events

➜ Launch tracking

➜ Session completion records

---

## ▶️ Safe Launch Process

➜ Validates OBS installation

➜ Verifies plugin state

➜ Checks version changes

➜ Applies temporary protections

➜ Launches OBS

➜ Cleans up security rules after exit

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

➜ Plugin validation events

➜ Security alerts

➜ Launch activity

➜ Firewall actions

➜ Session completion records

---

# ⚠️ Important Notes

❌ Do not manually edit generated hash files

❌ Do not replace plugins without rebuilding the baseline

❌ Do not commit generated logs to source control

❌ Do not disable Windows Firewall while using this utility

---

# 🏗️ Project Purpose

This project demonstrates:

➜ PowerShell Automation

➜ Application Integrity Validation

➜ Windows Firewall Administration

➜ Security Monitoring

➜ Secure Application Launching

➜ Security Event Logging

---

# 👨‍💻 Author

**TCDOverLord**

GitHub:
https://github.com/tcdoverlord
