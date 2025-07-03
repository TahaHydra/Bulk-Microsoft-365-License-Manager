# 💼 Microsoft 365 License Bulk Management Script

A PowerShell script to **add or remove Microsoft 365 licenses** from users in bulk or individually, using Microsoft Graph PowerShell SDK. It supports logging and flexible interaction per user.

---

## ⚙️ Features

- ✅ Bulk or Interactive (one-by-one) mode
- ✅ Add or remove licenses dynamically
- ✅ Skips empty or invalid users from input
- ✅ Logs all actions per user in a timestamped log file
- ✅ Returns to main menu after each operation set

---

## 📁 Prerequisites

- PowerShell 7+ (recommended)
- Microsoft Graph PowerShell SDK  
  Install via:
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```

---

## 📂 Files

- `users.txt` – A plain text file listing UPNs (user@domain.com), one per line
- `license_script.ps1` – The main script
- `license_script_log_<timestamp>.txt` – Output log file (auto-generated)

---

## 📜 Usage

### 1. Prepare `users.txt`
Example:
```
john.doe@contoso.com
jane.smith@contoso.com
```

### 2. Run the script
```powershell
.\license_script.ps1
```

### 3. Choose Mode
You'll be prompted:
```
Choose mode: Bulk (B), Individual (I), or Exit (E)? (B/I/E)
```

---

## 🔁 Bulk Mode

Select one license to apply to **all users** in the list.

- **Add**: Adds license to users who don’t already have it
- **Remove**: Removes license from users who already have it

You will be prompted like:
```
Bulk Action: Add (A) or Remove (R)? (A/R)
Enter the number of the license
```

---

## 👤 Individual Mode

Processes **each user one by one** with options to:

- Add license
- Remove license
- Skip user
- Exit script

Example prompt:
```
Do you want to (A)dd, (R)emove licenses, (S)kip user or (E)xit? (A/R/S/E)
```

---

## 🪵 Logging

All actions are logged in a file named like:

```
license_script_log_20250703_103500.txt
```

Contents include:
- User being processed
- License added or removed
- Errors or skipped users

---

## 🔐 Permissions Required

The script connects with:

```powershell
Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All, Directory.Read.All
```

Your account must be granted sufficient Microsoft Graph permissions.

---

## 🚫 Notes

- Users not found in Entra ID are skipped (with deleted user check)
- Input is sanitized: trims empty lines and whitespace from `users.txt`
- Invalid actions or input errors won’t crash the script

---

## 🧪 Example Run

```
Choose mode: Bulk (B), Individual (I), or Exit (E)? (B/I/E): B
Bulk Action: Add (A) or Remove (R)? (A/R): A
Available licenses:
1 - ENTERPRISEPACK
2 - EMS
Enter the number of the license: 1
Processing user: john.doe@contoso.com
License added to john.doe@contoso.com
...
```

---

## 📄 License

MIT License
