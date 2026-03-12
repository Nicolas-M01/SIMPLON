
<details>

<summary><h1>Contexte et livrables</h1></summary>

### Contexte du projet  
En tant que administrateur d'Infrastructures Sécurisées, dans le cadre de la remédiation et de l'application de la politique de sécurité, les actions suivantes doivent être réalisées :  

Préparation de l'outillage : Déployer un nœud de contrôle Ansible sous Ubuntu 24.  04 pour centraliser la gestion des configurations.  
Durcissement du système (Mise en œuvre de la politique - C9) : Développer et exécuter un Playbook Ansible chargé de forcer la mise à jour complète de l'OS (application des correctifs de sécurité).  
Sécurisation des accès (Mise en œuvre de la politique - C9) : Rédiger un Playbook pour industrialiser la création de comptes de service dédiés, intégrant le déploiement de clés SSH et limitant l'usage des mots de passe.  
Déploiement standardisé : Créer un Playbook pour installer et configurer un service Nginx et déployer une page web de façon reproductible.  
Validation (Mesure et analyse - C8) : Effectuer des tests de connexion post-déploiement (ping SSH sans mot de passe, vérification du statut Nginx) pour analyser et valider que le niveau de sécurité attendu est bien atteint sur la cible.  

### Livrables 
Un dossier compressé (ou un dépôt Git) contenant obligatoirement :  
- Le fichier d'inventaire (inventory.ini)  
- Les 3 playbooks documentés (1-update-os.yml, 2-create-user.yml, 3-deploy-website.yml)  
- Le fichier source de la page web (index.html)  
- Un court fichier README.md expliquant les commandes exactes à taper pour exécuter les playbooks dans le bon ordre  

</details>


### Préparation des VMS dans Proxmox

Création de 2 contenairs Ubuntu22.04 dans Proxmox  

* 503 : Machine "Master" : IP 192.168.1.14/24  
* 504 : Machine "Cliente" : IP 192.168.1.16/24  
Les machines se "pinguent".  

![alt text](<Images/Capture d'écran 2026-03-12 120120.png>)  

Sur chacune : `apt update` pour mettre à jour la liste des paquets.  

**Machine "Master" :**  
* `apt install ansible` : Installer les paquets Ansible  
* `cd /etc`, `mkdir ansible`  
* `apt install openssh-client`, `systemctl daemon-reload`, `systemctl enable ssh`, `systemctl start ssh`, `systemctl status ssh` : install et lancement du service SSH client.  

**Machine Cliente :**  
* `apt install openssh-server`, `systemctl daemon-reload`, `systemctl start sshd`, `systemctl status sshd` : install serveur SSH, lancement...  
* Autoriser `root` du client à se connecter en SSH : `nano /etc/ssh/sshd_config`, `PermitRootLogin yes`, puis relancer le service.  


Tenter une connxion depuis le Master : `ssh root@192.168.1.16`, si ok on passe à la suite, la préparation est terminée.  

### L'inventaire et le "ping"

*  `nano inventory.ini` : pour configurer le fichier d'inventaire des machines.   
  
  ```ini
  [serveurs_web]
  192.168.1.16 ansible_user=root
  ```  
Tester le ping `ansible -i inventory.ini serveurs_web -m ping -k` : si retour positif, retour en "vert" "SUCCESS".  

>* -i inventory.ini → utilise le fichier d'inventaire inventory.ini (liste de tes machines)  
>* all → cible tous les hôtes de l'inventaire  
>* -m ping → exécute le module ping d'Ansible (vérifie que la machine est >joignable et que Python est disponible)  
>* -k → demande le mot de passe SSH au lieu d'utiliser une clé  


