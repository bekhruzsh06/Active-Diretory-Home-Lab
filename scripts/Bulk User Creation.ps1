Import-Module ActiveDirectory

$csvPath = "Users.csv"
$domain = "bek.local"
$domainPath = "DC=bek,DC=local"

$requiredOUs = @(
    @{ Name = "IT Department"; Path = $domainPath },
    @{ Name = "IT_Users"; Path = "OU=IT Department,$domainPath" },
    @{ Name = "Marketing"; Path = $domainPath },
    @{ Name = "HR"; Path = $domainPath },
    @{ Name = "Finance"; Path = $domainPath },
    @{ Name = "Sales"; Path = $domainPath },
    @{ Name = "Engineering"; Path = $domainPath }
)

Write-Host "Checking Organizational Unit Structure" -ForegroundColor Cyan
foreach ($ou in $requiredOUs) {
    $expectedDN = "OU=$($ou.Name),$($ou.Path)"
    
    # Check if the OU already exists
    $ouExists = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$expectedDN'"
    
    if (-not $ouExists) {
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path
        Write-Host "[CREATED] OU: $($ou.Name)" -ForegroundColor Yellow
    } else {
        Write-Host "[EXISTS] OU: $($ou.Name)" -ForegroundColor DarkGray
    }
}
Write-Host "Bulk User Creation`n" -ForegroundColor Cyan


$users = Import-Csv -Path $csvPath -Delimiter ","

foreach ($user in $users) {
    $UPN = $user.Username + "@" + $domain
    $Password = ConvertTo-SecureString -String $user.Password -AsPlainText -Force

    $isVulnerable = [bool]::Parse($user.DoesNotRequirePreAuth)

    $userAttributes = @{
        Name = "$($user.FirstName) $($user.LastName)"
        GivenName = $user.FirstName
        Surname = $user.LastName
        SamAccountName = $user.Username
        UserPrincipalName = $UPN
        Department = $user.Department
        Path = $user.OUPath
        AccountPassword = $Password
        Enabled = $true
        ChangePasswordAtLogon = $false
    }

    try {
        New-ADUser @userAttributes
        
        if ($isVulnerable -eq $true) {
            Set-ADAccountControl -Identity $user.Username -DoesNotRequirePreAuth $true
        }
        
        Write-Host "[SUCCESS] User created: $($user.Username) | AS-REP Vulnerable: $isVulnerable" -ForegroundColor Green
    } catch {
        Write-Host "[FAILED] Could not create user: $($user.Username) | Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}