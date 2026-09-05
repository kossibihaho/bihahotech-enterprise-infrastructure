# Plan d'adressage IP — BihahoTech

## Segments réseau

| Segment | Réseau | Passerelle | Usage |
|---|---|---|---|
| LAN interne | 192.168.10.0/24 | 192.168.10.1 (pfSense) | Serveurs et postes clients |
| Plage DHCP | 192.168.10.100 – 192.168.10.200 | — | Attribution automatique (clients) |
| VPN OpenVPN | 10.8.0.0/24 | 10.8.0.1 | Accès distant |
| WAN | Dépend du réseau physique (box internet) | IP de la box | Sortie Internet (Bridged Adapter) |

## Adresses IP statiques

| Machine | IP | Attribution |
|---|---|---|
| PFSENSE01 (LAN) | 192.168.10.1 | Statique |
| DC01 | 192.168.10.10 | Statique |
| SRV-LINUX01 | 192.168.10.20 | Statique |
| MONITOR01 | 192.168.10.30 | Statique |
| WIN11-CLIENT01 | 192.168.10.100–200 | DHCP (DC01) |
| UBUNTU-CLIENT01 | 192.168.10.100–200 | DHCP (DC01) |

## Serveur DHCP

Le DHCP est géré par **DC01** (rôle Windows Server DHCP), et non par pfSense. pfSense a servi de DHCP temporaire uniquement pendant la phase d'installation initiale, avant que DC01 ne soit opérationnel.

- Plage : 192.168.10.100 – 192.168.10.200
- Passerelle distribuée : 192.168.10.1
- DNS distribué : 192.168.10.10

## DNS

- **Zone interne** : `bihahotech.local`, hébergée sur DC01
- **Forwarders DC01** : 1.1.1.1, 8.8.8.8 (résolution des noms externes)
- **Enregistrements A internes** (résolus vers SRV-LINUX01, 192.168.10.20) :
  - `nextcloud.bihahotech.local`
  - `wiki.bihahotech.local`
  - `portainer.bihahotech.local`

## Adressage réseau interne VirtualBox

Toutes les VM sont reliées via le réseau **Interne (Internal Network)** nommé `LAN-BIHAHO`, isolé du réseau physique de l'hôte. Seul PFSENSE01 possède un second adaptateur en **Bridged** pour l'accès WAN.
