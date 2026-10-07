Import-Module ActiveDirectory

$csvPath = "Users.csv"
$users = Import-Csv -Path $csvPath -Delimiter ","

Write-Host "--- Initiating Bulk User Deletion ---" -ForegroundColor Cyan

foreach ($user in $users) {
    try {
        # -Confirm:$false prevents PowerShell from asking "Are you sure?" 120 times
        Remove-ADUser -Identity $user.Username -Confirm:$false
        Write-Host "[DELETED] Removed user: $($user.Username)" -ForegroundColor DarkYellow
    } catch {
        Write-Host "[SKIPPED] Could not find or delete: $($user.Username)" -ForegroundColor DarkGray
    }
}

Write-Host "--- Deletion Complete ---" -ForegroundColor Cyan