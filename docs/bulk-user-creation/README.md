# Bulk User Creation


Automating user creation is a critical administration function, that saves a lot of time. This section covers the deployment of a PowerShell script, that

- Parses a CSV file, looping through each entry
- Checks for OU existence and create non-existent ones
- Generates Active Directory user accounts with password
- Some of them will deliberately be vulnerable to AS-REP Roasting
- Places users into their designated OUs


### 1. The CSV Data Source (`users.csv`)

The automation relies on a standardized CSV format containing the user attributes.

**File Format:**

<img width="1181" height="118" alt="изображение" src="https://github.com/user-attachments/assets/439521e9-ee21-490e-880a-b35be95b5115" />

<br>
<br>
>[!Note]
>On some accounts, I intentionally set `DoesNotRequirePreAuth` flag as `True` to practice AS-REP Roasting attack in the following sections
<br>
<br>


### 2. PowerShell Script Writing Process


The script can be divided into 6 parts


```pseudocode
#1. Initialisation 

LOAD AD commands 
SET domain variables ($csvPath, $domain,$domainPath)
DEFINE list of required OUs

#2. OU Setup

for (ou in requiredOUs) {
  CHECK if OU already exists
  if (not exists) {
    CREATE OU
     }
}

#3. Data Loading 
IMPORT csv

#4. Loop of User Creation 
for (user in users) {
 CREATE UPN 
 CREATE Secure Password 
 PARSE vulnerability flag (True/False)

#5. Setting User Attributes 
$UserAttributes = @{
 Name 
 GivenName 
 Surname 
 SamAccountName 
 UserPrincipalName 
 ...
 }

#6. Actual Creating Process 
try { 
CREATE user using data from $UserAttributes
}
catch {
Errors
}

```

#### In PowerShell


```Powershell
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
```

#### Folder Structure

<img width="405" height="167" alt="изображение" src="https://github.com/user-attachments/assets/6261d167-f902-4f54-8990-877b90683ed3" />

### 3. Applying this script on DC

#### 1. Transfer folder from my machine to DC

Created a share and connected from DC

<img width="817" height="400" alt="изображение" src="https://github.com/user-attachments/assets/86267296-f58a-401d-ab83-37370926a59e" />

Firstly got this message:

<img width="1093" height="344" alt="изображение" src="https://github.com/user-attachments/assets/f6669c50-ad2b-4212-9678-9f1f77fb2121" />

<br>
<br>

But then enabled guest access logons from Group Policies:

1.
<br>

<img width="823" height="392" alt="изображение" src="https://github.com/user-attachments/assets/40286284-1d08-4b5d-acf6-ae603da211ad" />

<br>
<br>
2.
<br>


<img width="1400" height="664" alt="изображение" src="https://github.com/user-attachments/assets/1f7339d8-ecce-439f-a2a5-de25f3391ac4" />

<br>
<br>

3.
<br>

<img width="1342" height="523" alt="изображение" src="https://github.com/user-attachments/assets/f5dd6775-650d-476e-9efe-158eac3cf639" />

<br>
<br>

4.
<br>
<img width="1312" height="693" alt="изображение" src="https://github.com/user-attachments/assets/86c41fb9-5cb0-4c27-8832-6ef30734c4b5" />

<br>
<br>

5.
<br>

<img width="1463" height="936" alt="изображение" src="https://github.com/user-attachments/assets/97e7d9d7-49b9-4d91-a1b7-f6cb79b3993f" />


<br>
<br>
6.
<br>

<img width="1598" height="262" alt="изображение" src="https://github.com/user-attachments/assets/0e4493a7-a46b-4a9a-abe4-af5eb11290a1" />

<br>
<br>

7.

<br>

<img width="1358" height="1149" alt="изображение" src="https://github.com/user-attachments/assets/8bf05bbc-7262-4bae-93af-3129c0b812b4" />


<br>
<br>
After that, we will be able to access our share and get the files

<br>
<br>

<img width="1603" height="404" alt="изображение" src="https://github.com/user-attachments/assets/07ab9ef4-010f-40f0-908a-89328211467b" />

<br>
<br>
<br>

#### Password Weakening

To make sure weak passwords go through validation, disable password checks and set minimum password length to 0 in group policy manager

<img width="1719" height="1025" alt="изображение" src="https://github.com/user-attachments/assets/2f132056-9e42-40d5-8a7e-2dd605ac43d5" />




### Script Execution

<br>
<br>
<img width="2510" height="1377" alt="изображение" src="https://github.com/user-attachments/assets/9ab914ba-fd59-49b8-869d-62f1ca39f677" />

<img width="1365" height="1468" alt="изображение" src="https://github.com/user-attachments/assets/c4df3b05-f290-4245-acc4-79039b0ba536" />

<img width="1410" height="995" alt="изображение" src="https://github.com/user-attachments/assets/6b7cc41b-da87-4856-a4ec-35055c5e1a86" />



New Departments:

<img width="1059" height="791" alt="изображение" src="https://github.com/user-attachments/assets/c690f57b-dca1-401b-b237-f66722fd18e4" />
<br>
<br>
<img width="797" height="723" alt="изображение" src="https://github.com/user-attachments/assets/6b77b40b-0459-416b-ae6e-19149cefeb89" />
<br>
<br>

<img width="895" height="731" alt="изображение" src="https://github.com/user-attachments/assets/c85b3987-09f0-4203-91b0-447abd94369f" />
<br>
<br>
<br>


After executing the script, all users have been successfully created and we can move to the next steps of our lab




