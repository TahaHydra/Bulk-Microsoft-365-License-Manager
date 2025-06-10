# Bulk Add/Remove Microsoft 365 Licenses from TXT input
# Connect to Microsoft Graph
Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All, Directory.Read.All

# Fetch available licenses
$licenses = Get-MgSubscribedSku

# Load users from TXT file
$userList = Get-Content -Path "users.txt"

foreach ($user in $userList) {
    Write-Host "Processing user: $user" -ForegroundColor Cyan

    # Check if user exists
    $mgUser = Get-MgUser -UserId $user -ErrorAction SilentlyContinue

    if (!$mgUser) {
        # Check if user exists in deleted users (no -Filter param, filter in PowerShell)
        $deletedUsers = Get-MgDirectoryDeletedUser -All
        $deletedMatch = $deletedUsers | Where-Object { $_.UserPrincipalName -eq $user }
        if ($deletedMatch) {
            Write-Host "User $user is in deleted users." -ForegroundColor Red
        } else {
            Write-Host "User $user cannot be found and is not in deleted users." -ForegroundColor Red
        }
        if ($user -eq $userList[-1]) {
            Write-Host "User $user was the last in the list. Exiting program." -ForegroundColor Magenta
            break
        }
        continue
    }

    # Fetch current licenses
    $currentLicenses = Get-MgUserLicenseDetail -UserId $user

    if ($currentLicenses.Count -eq 0) {
        Write-Host "User $user exists but has no licenses." -ForegroundColor Yellow
    } else {
        Write-Host "Current licenses for ${user}:" -ForegroundColor Yellow
        $licenseArray = @()
        $i = 1

        foreach ($lic in $currentLicenses) {
            $sku = $licenses | Where-Object SkuId -eq $lic.SkuId
            Write-Host "$i - $($sku.SkuPartNumber)"
            $licenseArray += $lic.SkuId
            $i++
        }
    }

    $action = Read-Host "Do you want to (A)dd, (R)emove licenses, (S)kip user or (E)xit? (A/R/S/E)"

    if ($action -eq 'A') {
        Write-Host "Available licenses:"
        $j = 1
        foreach ($lic in $licenses) {
            Write-Host "$j - $($lic.SkuPartNumber)"
            $j++
        }
        $choice = [int](Read-Host "Enter the number of the license to add") - 1
        $skuId = $licenses[$choice].SkuId

        Set-MgUserLicense -UserId $user -AddLicenses @(@{SkuId = $skuId}) -RemoveLicenses @()
        Write-Host "License added to ${user}" -ForegroundColor Green

    } elseif ($action -eq 'R' -and $currentLicenses.Count -gt 0) {
        $choice = [int](Read-Host "Enter the number of the license to remove") - 1
        $skuId = $licenseArray[$choice]

        Set-MgUserLicense -UserId $user -AddLicenses @() -RemoveLicenses @($skuId)
        Write-Host "License removed from ${user}" -ForegroundColor Green

    } elseif ($action -eq 'R' -and $currentLicenses.Count -eq 0) {
        Write-Host "Cannot remove licenses from user $user as no licenses are assigned." -ForegroundColor Red

    } elseif ($action -eq 'E') {
        Write-Host "Exiting script as requested." -ForegroundColor Magenta
        break

    } elseif ($action -eq 'S') {
        Write-Host "Skipping user ${user} as requested." -ForegroundColor Blue
        continue
    }
    else {
        Write-Host "Invalid action chosen." -ForegroundColor Red
    }
}
