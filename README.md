# Bulk Microsoft 365 License Manager (PowerShell + Microsoft Graph SDK)

This PowerShell script allows you to **bulk add or remove Microsoft 365 licenses** to users by reading their usernames from a `.txt` file. It uses the **Microsoft Graph SDK**, ensuring modern, secure, and compliant access to M365 resources.

---

## 🚀 Features

- ✅ Reads users from a simple `users.txt` file  
- 🔍 Checks if users exist or are deleted in Microsoft 365  
- 🔐 Lists current licenses and available licenses for each user  
- ➕ Adds licenses via prompt  
- ➖ Removes licenses via prompt  
- 🛑 Option to skip or exit per user  
- 🔁 Iterates through all users in a loop  
- 🧠 Intelligent handling of deleted or non-existent users  

---

## 📦 Prerequisites

- PowerShell 7.2 or later  
- Microsoft Graph PowerShell SDK:
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- Required Graph API permissions:
  - `User.ReadWrite.All`
  - `Directory.Read.All`
  - `Organization.Read.All`

> 🔐 Admin consent is required to grant these scopes.

---

## 📁 File Structure

- `bulk_license_script.ps1`: Main script  
- `users.txt`: Plaintext file with one UPN/email per line  

Example `users.txt`:
```
user1@domain.com
user2@domain.com
```

---

## 🛠️ Usage

1. **Prepare your user list**:  
   Add users to `users.txt`, one per line.

2. **Run the script**:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   .\bulk_license_script.ps1
   ```

3. **Interact per user**:  
   The script will walk you through each user found and allow you to:
   - Add licenses
   - Remove licenses
   - Skip the user
   - Exit early

---

## 🧠 Why This Script Is Better

| Feature                             | This Script                   | Classic CSV Methods           | Admin Center Manual           |
|------------------------------------|-------------------------------|-------------------------------|-------------------------------|
| Interactive License Management     | ✅ Yes                         | ❌ Static Only                 | ✅ But time-consuming          |
| Handles Deleted Users              | ✅ Yes                         | ❌ No                          | ❌ No                          |
| Graph API Compliance               | ✅ Yes                         | ❌ Often Legacy Cmdlets        | ✅ GUI only                    |
| Flexible Actions Per User          | ✅ Yes (A/R/S/E)               | ❌ Bulk Only                   | ✅ Manual                      |
| No Need to Modify Scripts per Run  | ✅ Reads users from `.txt`     | ❌ Often hardcoded             | ❌ Not applicable              |
| Supports Logging / Logging Ready   | 🔜 Easy to add with `Transcript` | ❌ Harder to trace            | ❌ No Export                   |

---

## 🧱 Customization Ideas

- 🔁 Convert prompts to automatic CSV-based decisions  
- 📊 Add logging of actions to CSV or file  
- 🧪 Add unit testing for license assignment logic  
- 🧭 Support CSV with license actions included per user  

---

## 📜 License

This script is provided under the MIT License. Feel free to fork, adapt, and improve it.

---

## 👨‍💻 Author

Made with ❤️ by [Taha Laachari](mailto:taha.laachari@outlook.com)
