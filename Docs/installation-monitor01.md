# Installation et configuration — MONITOR01

## Spécifications VM

| Paramètre | Valeur |
|---|---|
| OS | Ubuntu Server 24.04 LTS |
| RAM | 2 Go |
| Disque | 20 Go |
| CPU | 1-2 vCPU |
| Réseau | Interne `LAN-BIHAHO`, IP statique 192.168.10.30 |

## Stack de supervision

Déployée via `configs/docker/monitoring/docker-compose.yml` :

| Composant | Port | Rôle |
|---|---|---|
| Prometheus | 9090 | Collecte des métriques (scrape) |
| Grafana | 3000 | Visualisation, dashboards |
| Alertmanager | 9093 | Gestion des alertes (règles non configurées à ce stade) |
| node-exporter | 9100 | Métriques système de MONITOR01 lui-même |

## Cibles supervisées

Définies dans `configs/docker/monitoring/prometheus.yml` :

- `monitor01` (local, via node-exporter du conteneur)
- `srv-linux01` (192.168.10.20:9100, via `prometheus-node-exporter` installé nativement)
- `dc01` (192.168.10.10:9182, via `windows_exporter`)

## Règles pare-feu associées

- MONITOR01 → SRV-LINUX01 : port 9100 (TCP)
- MONITOR01 → DC01 : port 9182 (TCP)

## Dashboards Grafana

- Source de données Prometheus configurée (`http://prometheus:9090`, résolution par nom de conteneur Docker).
- Dashboard communautaire ID `1860` (Node Exporter Full) importé pour SRV-LINUX01.
- Dashboard DC01 : en cours de finalisation (problème de variables de filtre non résolu à ce stade — cible Prometheus confirmée `UP`, seul l'affichage Grafana reste à ajuster).

## Rôle secondaire — réplication de sauvegarde

MONITOR01 sert également de destination de réplication pour les sauvegardes BorgBackup de SRV-LINUX01 (voir `procedure-restauration-borgbackup.md`), via un accès SSH par clé dédiée.
