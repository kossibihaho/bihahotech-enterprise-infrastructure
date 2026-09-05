# Procédure de sauvegarde et de restauration — BorgBackup

## Architecture de sauvegarde

SRV-LINUX01 (source) MONITOR01 (copie secondaire)
├── Dumps DB (Nextcloud, │
│ Wiki.js) │
├── Config Docker │
└── BorgBackup (chiffré, ──rsync/SSH──► Copie répliquée
dédupliqué, local) du dépôt Borg


Stratégie inspirée du principe **3-2-1** : au moins 2 copies (locale + MONITOR01), sur 2 supports différents (2 VM distinctes).

## Sauvegarde automatisée

- **Script** : `scripts/backup.sh`, exécuté quotidiennement via `cron` (2h du matin) sur SRV-LINUX01.
- **Étapes** : dump MariaDB (Nextcloud) et PostgreSQL (Wiki.js) → mode maintenance Nextcloud → création de l'archive Borg (compression lz4) → sortie du mode maintenance → purge selon rétention (7 jours / 4 semaines / 6 mois) → réplication rsync vers MONITOR01 via clé SSH dédiée.
- **Dépôt Borg** : chiffré (`repokey-blake2`), passphrase gérée hors dépôt Git.

## Procédure de restauration — testée et validée

### Restauration locale (SRV-LINUX01)

```bash
export BORG_PASSPHRASE='<passphrase>'
borg list ~/backups/borg-repo
borg extract ~/backups/borg-repo::<nom-archive>
```

### Restauration depuis la copie distante (MONITOR01) — scénario de reprise après sinistre

Simule la perte totale de SRV-LINUX01 :

```bash
export BORG_PASSPHRASE='<passphrase>'
borg extract ssh://<alias-ssh-monitor01>/~/backups-srv-linux01/borg-repo::<nom-archive>
```

Ce scénario a été testé avec succès : extraction complète des dumps de bases de données et des configurations Docker, uniquement à partir de la copie hébergée sur MONITOR01.

## Sauvegarde de la configuration pfSense

Export manuel régulier (chiffré) via `Diagnostics > Backup & Restore`, stocké localement hors dépôt Git (`docs/Network/backups/`, exclu via `.gitignore` — jamais poussé sur GitHub, y compris après un incident de commit accidentel corrigé par retrait du suivi Git).

## Limite assumée

Le service **Samba** initialement prévu comme serveur de fichiers n'a pas été implémenté — aucun partage réseau supplémentaire à sauvegarder au-delà des services Docker.
