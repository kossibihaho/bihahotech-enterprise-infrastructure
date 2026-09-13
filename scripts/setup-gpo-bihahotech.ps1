# =====================================================================
# Script de configuration des GPO - bihahotech.local
# À exécuter sur DC01, dans PowerShell (ISE) en tant qu'Administrateur
# Nécessite les modules ActiveDirectory et GroupPolicy (déjà présents sur un DC)
# =====================================================================

Import-Module ActiveDirectory
Import-Module GroupPolicy

$domain = "bihahotech.local"
$dn     = "DC=bihahotech,DC=local"
$base   = "OU=BIHAHO,$dn"

# =====================================================================
# 1. Politique de mot de passe et de verrouillage (domaine entier)
# =====================================================================
Write-Host "=== Configuration de la politique de mot de passe du domaine ===" -ForegroundColor Cyan

Set-ADDefaultDomainPasswordPolicy -Identity $domain `
    -MinPasswordLength 12 `
    -PasswordHistoryCount 5 `
    -MaxPasswordAge "90.00:00:00" `
    -MinPasswordAge "1.00:00:00" `
    -ComplexityEnabled $true `
    -LockoutThreshold 5 `
    -LockoutDuration "00:30:00" `
    -LockoutObservationWindow "00:30:00"

Write-Host "Politique de mot de passe appliquée : 12 caractères min, complexité activée, verrouillage après 5 échecs / 30 min" -ForegroundColor Green

# =====================================================================
# 2. Restriction du Panneau de configuration pour RH et Finance
# =====================================================================
Write-Host "=== Création de la GPO de restriction Panneau de configuration ===" -ForegroundColor Cyan

$gpoControlPanel = New-GPO -Name "Restriction-PanneauConfig-RH-Finance" -Comment "Bloque l'accès au Panneau de configuration pour RH et Finance"

Set-GPRegistryValue -Name "Restriction-PanneauConfig-RH-Finance" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" `
    -Type DWord `
    -Value 1

New-GPLink -Name "Restriction-PanneauConfig-RH-Finance" -Target "OU=RH,$base"
New-GPLink -Name "Restriction-PanneauConfig-RH-Finance" -Target "OU=Finance,$base"

Write-Host "GPO Restriction Panneau de configuration créée et liée à RH + Finance" -ForegroundColor Green

# =====================================================================
# 3. Verrouillage automatique de session après inactivité (tous les postes)
# =====================================================================
Write-Host "=== Création de la GPO de verrouillage automatique ===" -ForegroundColor Cyan

$gpoScreenLock = New-GPO -Name "Verrouillage-Session-Automatique" -Comment "Verrouille la session après 10 minutes d'inactivité"

Set-GPRegistryValue -Name "Verrouillage-Session-Automatique" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaveActive" `
    -Type String `
    -Value "1"

Set-GPRegistryValue -Name "Verrouillage-Session-Automatique" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaverIsSecure" `
    -Type String `
    -Value "1"

Set-GPRegistryValue -Name "Verrouillage-Session-Automatique" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaveTimeOut" `
    -Type String `
    -Value "600"

New-GPLink -Name "Verrouillage-Session-Automatique" -Target "OU=Ordinateurs,$base"
New-GPLink -Name "Verrouillage-Session-Automatique" -Target "OU=Direction,$base"
New-GPLink -Name "Verrouillage-Session-Automatique" -Target "OU=IT,$base"
New-GPLink -Name "Verrouillage-Session-Automatique" -Target "OU=RH,$base"
New-GPLink -Name "Verrouillage-Session-Automatique" -Target "OU=Finance,$base"

Write-Host "GPO Verrouillage automatique créée et liée à toutes les OU utilisateurs" -ForegroundColor Green

Write-Host "=== Configuration des GPO terminée ===" -ForegroundColor Cyan
Write-Host "Note : les GPO s'appliquent au prochain rafraîchissement (gpupdate /force sur les clients, ou redémarrage)" -ForegroundColor Yellow

