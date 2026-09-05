# Installation et configuration — PFSENSE01

## Spécifications VM

| Paramètre | Valeur |
|---|---|
| RAM | 1 Go |
| Disque | 20 Go |
| CPU | 1 vCPU |
| Réseau | Adaptateur 1 (WAN) : Bridged — Adaptateur 2 (LAN) : Interne `LAN-BIHAHO` |

## Installation

1. ISO pfSense CE (2.8.1) démarrée, installation standard, partitionnement UFS.
2. Attribution des interfaces en console : WAN = `em0`, LAN = `em1`.
3. Configuration IP LAN en console : `192.168.10.1/24`, DHCP temporaire activé (désactivé une fois DC01 opérationnel).
4. Assistant de configuration initiale (navigateur) : hostname `PFSENSE01`, domaine `bihahotech.local`, DNS `1.1.1.1`/`8.8.8.8`, mot de passe admin changé.

## Sécurisation appliquée

- **Alias IP** : `SRV_DC01`, `SRV_LINUX01`, `SRV_MONITOR01`, `NET_LAN`
- **Alias Ports** : `PORTS_WEB` (80, 443, 8080, 8081, 9000, 9443, 53), `PORTS_AD` (88, 389, 445, 464, 636, 3268, 3269, 53, 123)
- **Règles LAN** (dans l'ordre) : accès AD/DNS/NTP vers DC01 → accès services SRV-LINUX01 → accès supervision MONITOR01 → ping interne → sortie Internet limitée (HTTP/HTTPS/DNS) → blocage final de tout le reste
- **WAN** : Block bogon networks activé, aucune règle "Pass" sauf OpenVPN (1194/UDP)
- **Admin webConfigurator** : HTTPS uniquement, port custom `8443`, verrouillage après échecs de connexion (Login Protection : seuil 20, blocage 300s)
- **MSS Clamping** activé (`System > Advanced > Firewall & NAT`, Maximum MSS = 1400) pour corriger des soucis de fragmentation TLS constatés lors des `docker pull`
- **Logs** : blocages par défaut journalisés

## VPN OpenVPN

- Autorité de certification interne : `BihahoTech-VPN-CA`
- Certificat serveur : `PFSENSE01-VPN-Server`
- Mode : Remote Access SSL/TLS + User Auth
- Réseau tunnel : `10.8.0.0/24`
- Réseau local accessible : `192.168.10.0/24`
- Chiffrement : AES-256-GCM, SHA256
- DNS poussé aux clients : `192.168.10.10`, domaine `bihahotech.local`
- Comptes VPN créés dans `System > User Manager`, avec certificat utilisateur lié à la CA interne

## Sauvegarde de configuration

Configuration exportée régulièrement via `Diagnostics > Backup & Restore` (chiffrée), stockée hors du dépôt Git (exclue via `.gitignore`).
