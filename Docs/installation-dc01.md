# Installation et configuration — DC01

## Spécifications VM

| Paramètre | Valeur |
|---|---|
| OS | Windows Server 2025 Evaluation |
| RAM | 4 Go |
| Disque | 60 Go |
| CPU | 2 vCPU |
| Réseau | Interne `LAN-BIHAHO`, IP statique 192.168.10.10 |
| Affichage VirtualBox | Contrôleur graphique VMSVGA, accélération 3D désactivée (corrige un bug d'écran noir après arrêt forcé) |

## Installation

1. Windows Server 2025 Standard (Desktop Experience) installé.
2. IP statique configurée : 192.168.10.10 / 255.255.255.0, passerelle 192.168.10.1, DNS 127.0.0.1.
3. Serveur renommé en `DC01`.

## Rôles installés

- **Active Directory Domain Services** — nouvelle forêt `bihahotech.local`, niveau fonctionnel Windows Server 2016.
- **DNS Server** — installé automatiquement avec AD DS. Forwarders configurés vers `1.1.1.1` et `8.8.8.8`.
- **DHCP Server** — étendue `LAN-BIHAHO`, plage 192.168.10.100–200, passerelle 192.168.10.1, DNS 192.168.10.10. Le DHCP de pfSense a été désactivé une fois ce rôle opérationnel.

## Structure Active Directory

Voir `gestion-utilisateurs-groupes.md` pour le détail des OU, groupes et utilisateurs (script `scripts/setup-ad-bihahotech.ps1`).

## GPO déployées

Voir `gestion-gpo.md` (script `scripts/setup-gpo-bihahotech.ps1`).

## Supervision

Rôle supervisé par MONITOR01 via `windows_exporter` (port 9182), installé en service Windows persistant (`sc.exe create`), avec règle de pare-feu Windows dédiée et règle pfSense autorisant MONITOR01 → DC01 sur ce port.
