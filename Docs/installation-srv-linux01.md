# Installation et configuration — SRV-LINUX01

## Spécifications VM

| Paramètre | Valeur |
|---|---|
| OS | Ubuntu Server 24.04 LTS |
| RAM | 2 Go |
| Disque | 40 Go |
| CPU | 2 vCPU |
| Réseau | Interne `LAN-BIHAHO`, IP statique 192.168.10.20 (Netplan) |

## Prérequis système

- IPv6 désactivé (`net.ipv6.conf.all.disable_ipv6 = 1`) — évite des échecs `docker pull` liés à une résolution AAAA sans route IPv6.
- Docker Engine + Docker Compose installés depuis le dépôt officiel Docker.

## Services Docker déployés

| Service | Fichier Compose | Port(s) | Base de données |
|---|---|---|---|
| Portainer | `configs/docker/portainer/docker-compose.yml` | 9000, 9443 | — |
| Nextcloud | `configs/docker/nextcloud/docker-compose.yml` | 8080 | MariaDB (conteneur dédié) |
| Wiki.js | `configs/docker/wiki/docker-compose.yml` | 8081 | PostgreSQL (conteneur dédié) |

## Reverse proxy Nginx

Installé nativement (hors conteneur) sur SRV-LINUX01, avec un fichier de configuration par service dans `configs/docker/nginx/` :

- `nextcloud.conf` → `nextcloud.bihahotech.local` → proxy vers `127.0.0.1:8080`
- `wiki.conf` → `wiki.bihahotech.local` → proxy vers `127.0.0.1:8081`
- `portainer.conf` → `portainer.bihahotech.local` → proxy vers `127.0.0.1:9000` (avec support WebSocket)

## HTTPS

Certificat auto-signé multi-domaines (SAN) généré via OpenSSL (`/etc/nginx/ssl/`), couvrant les 3 sous-domaines. Redirection automatique HTTP → HTTPS configurée dans chaque bloc `server`. Nextcloud configuré avec `overwriteprotocol=https` et `trusted_proxies=127.0.0.1`.

> Limite assumée : certificat non approuvé par une autorité reconnue → avertissement navigateur affiché (voir section Sécurité du README).

## DNS

Résolution des 3 sous-domaines assurée par DC01 (enregistrements A pointant vers 192.168.10.20).

## Sauvegarde

Voir `procedure-restauration-borgbackup.md` — sauvegarde quotidienne automatisée (cron, script `scripts/backup.sh`) des dumps de bases de données et des configurations Docker, répliquée vers MONITOR01.
