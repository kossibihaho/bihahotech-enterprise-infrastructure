# =====================================================================
# Script de création de la structure AD - bihahotech.local
# À exécuter sur DC01, dans PowerShell (ISE) en tant qu'Administrateur
# =====================================================================

Import-Module ActiveDirectory

$domain = "bihahotech.local"
$dn     = "DC=bihahotech,DC=local"

# --- 1. OU racine ---------------------------------------------------
New-ADOrganizationalUnit -Name "BIHAHO" -Path $dn -ProtectedFromAccidentalDeletion $true

$base = "OU=BIHAHO,$dn"

# --- 2. Sous-OU -------------------------------------------------------
$ous = @("Direction", "IT", "RH", "Finance", "Serveurs", "Ordinateurs", "Utilisateurs")
foreach ($ou in $ous) {
    New-ADOrganizationalUnit -Name $ou -Path $base -ProtectedFromAccidentalDeletion $true
    Write-Host "OU créée : $ou" -ForegroundColor Green
}

# --- 3. Groupes de sécurité globaux ------------------------------------
New-ADGroup -Name "GG_DIRECTION"       -GroupScope Global -GroupCategory Security -Path "OU=Direction,$base"
New-ADGroup -Name "GG_IT"              -GroupScope Global -GroupCategory Security -Path "OU=IT,$base"
New-ADGroup -Name "GG_RH"              -GroupScope Global -GroupCategory Security -Path "OU=RH,$base"
New-ADGroup -Name "GG_FINANCE"         -GroupScope Global -GroupCategory Security -Path "OU=Finance,$base"
New-ADGroup -Name "GG_ADMINISTRATEURS" -GroupScope Global -GroupCategory Security -Path "OU=IT,$base"
Write-Host "Groupes créés" -ForegroundColor Green

# --- 4. Mot de passe temporaire commun (à changer à la 1re connexion) --
$password = ConvertTo-SecureString "*************" -AsPlainText -Force

# --- 5. Création des utilisateurs --------------------------------------
New-ADUser -Name "Kossi Bihaho" -SamAccountName "k.bihaho" `
    -UserPrincipalName "k.bihaho@$domain" -GivenName "Kossi" -Surname "Bihaho" `
    -Path "OU=Direction,$base" -AccountPassword $password `
    -Enabled $true -ChangePasswordAtLogon $true

New-ADUser -Name "Kodjo Honore" -SamAccountName "kodjo.honore" `
    -UserPrincipalName "kodjo.honore@$domain" -GivenName "Kodjo" -Surname "Honore" `
    -Path "OU=RH,$base" -AccountPassword $password `
    -Enabled $true -ChangePasswordAtLogon $true

New-ADUser -Name "Yao Landry" -SamAccountName "yao.landry" `
    -UserPrincipalName "yao.landry@$domain" -GivenName "Yao" -Surname "Landry" `
    -Path "OU=IT,$base" -AccountPassword $password `
    -Enabled $true -ChangePasswordAtLogon $true

New-ADUser -Name "Kokouvi Denis" -SamAccountName "kokouvi.denis" `
    -UserPrincipalName "kokouvi.denis@$domain" -GivenName "Kokouvi" -Surname "Denis" `
    -Path "OU=Finance,$base" -AccountPassword $password `
    -Enabled $true -ChangePasswordAtLogon $true

Write-Host "Utilisateurs créés" -ForegroundColor Green

# --- 6. Ajout des utilisateurs dans leurs groupes -----------------------
Add-ADGroupMember -Identity "GG_DIRECTION"       -Members "k.bihaho"
Add-ADGroupMember -Identity "GG_RH"              -Members "kodjo.honore"
Add-ADGroupMember -Identity "GG_IT"              -Members "yao.landry"
Add-ADGroupMember -Identity "GG_FINANCE"         -Members "kokouvi.denis"
Add-ADGroupMember -Identity "GG_ADMINISTRATEURS" -Members "yao.landry"

Write-Host "Appartenance aux groupes configurée" -ForegroundColor Green
Write-Host "=== Structure AD bihahotech.local créée avec succès ===" -ForegroundColor Cyan

