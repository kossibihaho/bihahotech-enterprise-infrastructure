# Gestion des utilisateurs et groupes — Active Directory

## Structure des unités d'organisation (OU)

BIHAHO
├── Direction
├── IT
├── RH
├── Finance
├── Serveurs
├── Ordinateurs
└── Utilisateurs


## Groupes de sécurité

| Groupe | OU de rattachement | Portée |
|---|---|---|
| GG_DIRECTION | Direction | Global |
| GG_IT | IT | Global |
| GG_RH | RH | Global |
| GG_FINANCE | Finance | Global |
| GG_ADMINISTRATEURS | IT | Global |

## Comptes utilisateurs

| Utilisateur | SamAccountName | OU | Groupe(s) |
|---|---|---|---|
| Kossi Bihaho | k.bihaho | Direction | GG_DIRECTION |
| Kodjo Honoré | kodjo.honore | RH | GG_RH |
| Yao Landry | yao.landry | IT | GG_IT, GG_ADMINISTRATEURS |
| Kokouvi Denis | kokouvi.denis | Finance | GG_FINANCE |

## Compte VPN dédié

Un compte séparé (`vpn-k.bihaho`) a été créé localement sur pfSense (hors annuaire AD) pour l'authentification OpenVPN, avec certificat client lié à la CA interne `BihahoTech-VPN-CA`.

## Automatisation

La création complète de cette structure (OU, groupes, utilisateurs, appartenances) est scriptée dans `scripts/setup-ad-bihahotech.ps1`, exécutable via PowerShell sur DC01. Le mot de passe initial des comptes est défini avec obligation de changement à la première connexion (`ChangePasswordAtLogon`).

## Jonction au domaine

- **WIN11-CLIENT01** : jonction native via l'interface Windows (Système > Domaine).
- **UBUNTU-CLIENT01** : jonction via `realmd` + `sssd` (paquets `realmd`, `sssd`, `sssd-tools`, `adcli`, `samba-common-bin`), avec noms pleinement qualifiés (`utilisateur@bihahotech.local`) et création automatique du dossier personnel (`pam-auth-update`).

