# Stratégies de groupe (GPO) — bihahotech.local

<img width="945" height="509" alt="image" src="https://github.com/user-attachments/assets/bb6fca97-1b52-48c9-a61a-55b188c25678" />


## GPO déployées

Automatisées via `scripts/setup-gpo-bihahotech.ps1` (module PowerShell `GroupPolicy`).

### 1. Politique de mot de passe et de verrouillage (domaine entier)

Appliquée via `Set-ADDefaultDomainPasswordPolicy` :

| Paramètre | Valeur |
|---|---|
| Longueur minimale | 12 caractères |
| Historique | 5 mots de passe |
| Âge maximal | 90 jours |
| Âge minimal | 1 jour |
| Complexité | Activée |
| Seuil de verrouillage | 5 tentatives échouées |
| Durée de verrouillage | 30 minutes |

### 2. Restriction du Panneau de configuration

- **Nom** : `Restriction-PanneauConfig-RH-Finance`
- **Liée à** : OU RH, OU Finance
- **Effet** : `NoControlPanel = 1` (clé de registre `HKCU\...\Explorer`), bloque l'accès au Panneau de configuration.

### 3. Verrouillage automatique de session

- **Nom** : `Verrouillage-Session-Automatique`
- **Liée à** : OU Direction, IT, RH, Finance, Ordinateurs
- **Effet** : écran de veille sécurisé activé, verrouillage après 600 secondes (10 minutes) d'inactivité.

## Non implémenté (limite assumée)

- **Stratégie d'audit avancée** (traçabilité des connexions) : envisagée mais non déployée — nécessite une configuration via `GptTmpl.inf` plus complexe à scripter de façon fiable qu'un simple paramètre de registre.

## Vérification

```powershell
Get-ADDefaultDomainPasswordPolicy
Get-GPO -All | Select-Object DisplayName
```

Application immédiate sur un client de test :
```powershell
gpupdate /force
```
