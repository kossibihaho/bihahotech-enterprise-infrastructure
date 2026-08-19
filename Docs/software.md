# 📦 Logiciels et images utilisés

Ce projet repose sur une infrastructure virtuelle construite avec VirtualBox. 
Les différents systèmes d'exploitation et logiciels utilisés pour construire et administrer l'infrastructure sont listés ci-dessous.

Les fichiers `.iso` et `.exe` ne sont pas inclus dans le dépôt GitHub en raison de leur taille. Les liens ci-dessous permettent de télécharger les versions utilisées depuis leurs sources officielles.

---

## 1. VirtualBox

**Version :** VirtualBox 7.2.14 r174565  
**Plateforme :** Windows  
**Fichier :** `VirtualBox-7.2.14-174565-Win.exe`

Téléchargement officiel :

https://download.virtualbox.org/virtualbox/7.2.14/VirtualBox-7.2.14-174565-Win.exe

Documentation officielle :

https://download.virtualbox.org/virtualbox/7.2.14/UserManual.pdf

**SHA-256 de l'installateur utilisé :**

`5FB111F32A15763D519BF9EF23E0111153521F641CDE7460E5B8E895CA27A1D2`

---

## 2. pfSense CE

**Version :** pfSense CE 2.6.0  
**Architecture :** AMD64  
**Fichier :** `pfSense-CE-2.6.0-RELEASE-amd64.iso`

Documentation officielle :

https://docs.netgate.com/pfsense/en/latest/

Cette image est utilisée pour déployer la machine virtuelle **PFSENSE01**, qui assure les fonctions de pare-feu, de routage et de services réseau de l'infrastructure.

---

## 3. Windows Server 2025

**Version :** Windows Server 2025  
**Architecture :** x64  
**Support d'installation :** ISO

Téléchargement officiel Microsoft :

https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025

Documentation officielle :

https://learn.microsoft.com/en-us/windows-server/

Windows Server 2025 est utilisé pour mettre en place les services d'infrastructure de l'entreprise, notamment le contrôleur de domaine, Active Directory, DNS et les autres services Windows nécessaires au projet.

---

## 4. Windows 11

**Version :** Windows 11 25H2  
**Architecture :** x64  
**Langue :** Français  
**Fichier :** `Win11_25H2_French_x64.iso`

Téléchargement officiel Microsoft :

https://www.microsoft.com/software-download/windows11

Cette image est utilisée pour déployer la machine virtuelle **WIN11-CLIENT01**, qui représente le poste de travail d'un utilisateur de l'entreprise.

---

## 5. Ubuntu Desktop

**Version :** Ubuntu 24.04.4 LTS  
**Architecture :** AMD64  
**Fichier :** `ubuntu-24.04.4-desktop-amd64.iso`

Téléchargement officiel :

https://releases.ubuntu.com/24.04.4/

Documentation officielle :

https://ubuntu.com/desktop

Ubuntu Desktop est utilisé pour mettre en place un poste ou une machine Linux dans l'environnement d'entreprise et permettre la mise en pratique de l'administration système Linux.

---

## 6. Ubuntu Server

**Version :** Ubuntu 24.04.4 LTS  
**Architecture :** AMD64  
**Fichier :** `ubuntu-24.04.4-live-server-amd64.iso`

Téléchargement officiel :

https://releases.ubuntu.com/24.04.4/

Documentation officielle :

https://ubuntu.com/server

Ubuntu Server est utilisé pour déployer des services Linux au sein de l'infrastructure et mettre en pratique l'administration de serveurs, les services réseau, la sécurisation et la supervision de l'infrastructure.

---

## 📋 Récapitulatif

| Logiciel / Système | Version | Architecture | Utilisation |
|---|---|---|---|
| VirtualBox | 7.2.14 r174565 | Windows | Hyperviseur |
| pfSense CE | 2.6.0 | AMD64 | Pare-feu / Routeur |
| Windows Server | 2025 | x64 | Services d'entreprise / Active Directory |
| Windows 11 | 25H2 | x64 | Poste client |
| Ubuntu Desktop | 24.04.4 LTS | AMD64 | Poste / environnement Linux |
| Ubuntu Server | 24.04.4 LTS | AMD64 | Serveur Linux |

---

## 📌 Gestion des fichiers d'installation

Les images ISO et les installateurs ne sont pas stockés directement dans ce dépôt GitHub.

Le dépôt contient :

- la documentation d'installation ;
- les configurations des différentes machines ;
- les scripts d'automatisation ;
- les schémas d'architecture ;
- les configurations réseau ;
- les procédures de sécurité ;
- les procédures de dépannage.

Les versions exactes des logiciels sont indiquées dans ce document afin de permettre de reproduire l'environnement.
