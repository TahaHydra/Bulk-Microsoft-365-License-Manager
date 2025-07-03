# Bulk Add/Remove Microsoft 365 Licenses from TXT input with Bulk/Individual Modes and Logging

# Connect to Microsoft Graph
Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All, Directory.Read.All

# Fetch available licenses
$licenses = Get-MgSubscribedSku

# Load users from TXT file
$userList = Get-Content -Path "users.txt"

# Logging setup
$logPath = "license_script_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

function Log-Action($message) {
    $message | Out-File -FilePath $logPath -Append
}

$mode = Read-Host "Choose mode: Bulk (B) or Individual (I)? (B/I)"

if ($mode -eq 'B') {
    $action = Read-Host "Bulk Action: Add (A) or Remove (R)? (A/R)"

    Write-Host "Available licenses:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $licenses.Count; $i++) {
        Write-Host "$($i + 1) - $($licenses[$i].SkuPartNumber)"
    }

    $choice = [int](Read-Host "Enter the number of the license") - 1
    $skuId = $licenses[$choice].SkuId

    foreach ($user in $userList) {
        Write-Host "Processing user: $user" -ForegroundColor Cyan
        Log-Action "Processing user: $user"

        $mgUser = Get-MgUser -UserId $user -ErrorAction SilentlyContinue

        if (!$mgUser) {
            Write-Host "User $user not found." -ForegroundColor Red
            Log-Action "User $user not found."
            continue
        }

        $currentLicenses = Get-MgUserLicenseDetail -UserId $user
        $hasLicense = $currentLicenses | Where-Object { $_.SkuId -eq $skuId }

        if ($action -eq 'A' -and !$hasLicense) {
            Set-MgUserLicense -UserId $user -AddLicenses @(@{SkuId = $skuId}) -RemoveLicenses @()
            Write-Host "License added to $user" -ForegroundColor Green
            Log-Action "License added to $user"
        }
        elseif ($action -eq 'R' -and $hasLicense) {
            Set-MgUserLicense -UserId $user -AddLicenses @() -RemoveLicenses @($skuId)
            Write-Host "License removed from $user" -ForegroundColor Green
            Log-Action "License removed from $user"
        }
        else {
            Write-Host "No action needed for $user." -ForegroundColor Yellow
            Log-Action "No action needed for $user."
        }
    }
}

elseif ($mode -eq 'I') {
    foreach ($user in $userList) {
        do {
            Write-Host "Processing user: $user" -ForegroundColor Cyan
            Log-Action "Processing user: $user"

            $mgUser = Get-MgUser -UserId $user -ErrorAction SilentlyContinue

            if (!$mgUser) {
                Write-Host "User $user not found." -ForegroundColor Red
                Log-Action "User $user not found."
                break
            }

            $currentLicenses = Get-MgUserLicenseDetail -UserId $user

            if ($currentLicenses.Count -eq 0) {
                Write-Host "User $user has no licenses." -ForegroundColor Yellow
            }
            else {
                Write-Host "Current licenses for ${user}:" -ForegroundColor Yellow
                $licenseArray = @()
                for ($i = 0; $i -lt $currentLicenses.Count; $i++) {
                    $sku = $licenses | Where-Object SkuId -eq $currentLicenses[$i].SkuId
                    Write-Host "$($i + 1) - $($sku.SkuPartNumber)"
                    $licenseArray += $currentLicenses[$i].SkuId
                }
            }

            $action = Read-Host "Do you want to (A)dd, (R)emove licenses, (S)kip user or (E)xit? (A/R/S/E)"

            if ($action -eq 'A') {
                Write-Host "Available licenses:" -ForegroundColor Cyan
                for ($j = 0; $j -lt $licenses.Count; $j++) {
                    Write-Host "$($j + 1) - $($licenses[$j].SkuPartNumber)"
                }
                $choice = [int](Read-Host "Enter the number of the license to add") - 1
                $skuId = $licenses[$choice].SkuId

                Set-MgUserLicense -UserId $user -AddLicenses @(@{SkuId = $skuId}) -RemoveLicenses @()
                Write-Host "License added to $user" -ForegroundColor Green
                Log-Action "License added to $user"

            } elseif ($action -eq 'R' -and $currentLicenses.Count -gt 0) {
                $choice = [int](Read-Host "Enter the number of the license to remove") - 1
                $skuId = $licenseArray[$choice]

                Set-MgUserLicense -UserId $user -AddLicenses @() -RemoveLicenses @($skuId)
                Write-Host "License removed from $user" -ForegroundColor Green
                Log-Action "License removed from $user"

            } elseif ($action -eq 'R' -and $currentLicenses.Count -eq 0) {
                Write-Host "User $user has no licenses to remove." -ForegroundColor Red
                Log-Action "User $user has no licenses to remove."

            } elseif ($action -eq 'S') {
                Write-Host "Skipping user $user." -ForegroundColor Blue
                Log-Action "Skipped user $user."
                break

            } elseif ($action -eq 'E') {
                Write-Host "Exiting script as requested." -ForegroundColor Magenta
                Log-Action "Script exited by user."
                exit

            } else {
                Write-Host "Invalid action chosen." -ForegroundColor Red
            }

        } while ($true)
    }
}
else {
    Write-Host "Invalid mode selected. Exiting script." -ForegroundColor Red
    Log-Action "Invalid mode selected. Script exited."
}
