#!/bin/bash
# =====================================================================
# Script de sauvegarde BorgBackup - SRV-LINUX01
# À placer dans ~/backups/backup.sh puis rendre exécutable :
#   chmod +x ~/backups/backup.sh
# =====================================================================

set -e

export BORG_REPO=~/backups/borg-repo
export BORG_PASSPHRASE='********'

DATE=$(date +%Y-%m-%d_%H-%M)
LOGFILE=~/backups/backup.log

echo "=== Sauvegarde démarrée : $DATE ===" >> "$LOGFILE"

# --- 1. Dump des bases de données AVANT la sauvegarde des fichiers ---
# Nextcloud (MariaDB)
docker exec nextcloud-db mysqldump -u nextcloud -p******** nextcloud > ~/backups/dumps/nextcloud-db.sql 2>> "$LOGFILE"

# Wiki.js (PostgreSQL)
docker exec wikijs-db pg_dump -U wikijs wikijs > ~/backups/dumps/wikijs-db.sql 2>> "$LOGFILE"

# --- 2. Mettre Nextcloud en mode maintenance (évite les écritures pendant le dump de fichiers) ---
docker exec -u www-data nextcloud-app php occ maintenance:mode --on >> "$LOGFILE" 2>&1

# --- 3. Créer l'archive Borg ---
borg create \
    --stats \
    --compression lz4 \
    "$BORG_REPO::srv-linux01-$DATE" \
    ~/backups/dumps \
    ~/docker \
    >> "$LOGFILE" 2>&1

# --- 4. Sortir Nextcloud du mode maintenance ---
docker exec -u www-data nextcloud-app php occ maintenance:mode --off >> "$LOGFILE" 2>&1

# --- 5. Purge des anciennes sauvegardes (rétention) ---
borg prune \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=6 \
    "$BORG_REPO" \
    >> "$LOGFILE" 2>&1

echo "=== Sauvegarde terminée : $(date +%Y-%m-%d_%H-%M) ===" >> "$LOGFILE"
