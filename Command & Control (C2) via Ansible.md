
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
* `sudo apt install sshpass -y` : Outil qui permet de fournir un mot de passe SSH automatiquement dans un script. (Par défaut, Ansible se connecte aux serveurs en SSH avec des clés SSH (méthode recommandée). Mais si les machines distantes utilisent un mot de passe SSH, Ansible ne peut pas l’envoyer automatiquement sans outil supplémentaire.
➡️ sshpass permet à Ansible d’envoyer le mot de passe automatiquement.)  

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

### Playbook 1 : 1-update-os.yml


```yml
---
- name: Udpate OS
  hosts: all # Cible tous les hôtes de l'inventaire
  become: yes # Exécute les tâches en sudo (nécessaire pour apt)

  tasks:
    - name: Mettre a jour le cache APT et faire un upgrade
      apt:
        update_cache: yes # Équivalent de "apt update
        upgrade: dist # Équivalent de "apt dist-upgrade" (installer/supprimer des dépendances) 
```

`ansible-playbook -i inventory.ini 1-update-os.yml -k`  

Résultat :  
![alt text](<Images/Capture d'écran 2026-03-12 141325.png>)  


### Playbook 2 : 2-create-user.yml  

Générer clés SSH : `ssh-keygen -t rsa -b 4096`  
`nano 2-create-user.yml`  

```yml
---
- name: Creation utilisateur et configuration SSH
  hosts: serveurs_web  # Cible uniquement le groupe "serveurs_web" de l'inventaire  
  become: yes # Exécute en sudo (nécessaire pour créer un utilisateur)  

  tasks:
    - name: Creer utilisateur devops avec un bash
      user:
        name: devops # Nom de l'utilisateur à créer  
        shell: /bin/bash # Shell par défaut (bash)  
        groups: sudo # Ajoute l'utilisateur au groupe sudo (droits d'administration)  
        append: yes # IMPORTANT : ajoute le groupe sans écraser les groupes existants                            # Sans "append: yes", les autres groupes de l'utilisateur seraient supprimés  

    - name: Ajouter la clee publique SSH pour devops
      authorized_key:
        user: devops # Utilisateur pour lequel on autorise la clé
        state: present # S'assure que la clé est bien présente (idempotent)
        key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}" # lookup('file', ...) lit le contenu du fichier local id_rsa.pub
        # et l'insère dans ~/.ssh/authorized_keys de l'utilisateur devops sur la machine distante
        # Équivalent manuel de : ssh-copy-id devops@machine
```

Lancer Playbook : `ansible-playbook -i inventory.ini 2-create-user.yml -k`  

Résultat :  

```yml
PLAY [Creation utilisateur et configuration SSH] *******************************************************************

TASK [Gathering Facts] ********************************************************************
ok: [192.168.1.58]

TASK [Creer utilisateur devops avec un bash] *******************************************************************
changed: [192.168.1.58]

TASK [Ajouter la clee publique SSH pour devops] ********************************************************************
changed: [192.168.1.58]

PLAY RECAP *****************************************************************************
192.168.1.58               : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```


### Playbook 2 : 3-deploy-website.yml  

`mkdir ~/ansible-nginx-demo`, `cd ~/ansible-nginx-demo`  
`cp /etc/ansible/inventory.ini .` : copie du fichier d'inventaire dans le nouveau dossier.  
`curl -L https://github.com/do-community/html_demo_site/archive/refs/heads/main.zip -o html_demo.zip` : téléchargement du site web (installer curl avant).  
`sudo apt install unzip` et `unzip html_demo.zip` :  installe et dezip le fichier téléchargé.  
`ls -la html_demo_site-main` : Pour voir le contenue dézippé.  

`mkdir files`, `nano files/nginx.conf.j2` : Création d'un dossier et du fichier config.  

Ce fichier modèle contient la configuration d'un bloc serveur Nginx pour un site web HTML statique :  
```bash
server {
  listen 80;

  root {{ document_root }}/{{ app_root }};
  index index.html index.htm;

  server_name {{ server_name }};
  
  location / {
   default_type "text/html";
   try_files $uri.html $uri $uri/ =404;
  }
}
```

Création du nouveau playbook :  


```yml
- hosts: all
  become: no
  vars:
    server_name: "{{ ansible_default_ipv4.address }}" # Récupère automatiquement l'IP de la machine distante
    document_root: /var/www/html # Répertoire racine du site web Nginx
    app_root: html_demo_site-main  # Dossier source du site (sur la machine contrôleur)
  tasks:

    - name: Update apt cache and install Nginx
      apt:
        name: nginx # Paquet à installer
        state: latest # S'assure que c'est la dernière version
        update_cache: yes # Fait "apt update" avant l'installation

    - name: Copy website files to the server's document root
      copy:
        src: "{{ app_root }}" # Source : dossier local "html_demo_site-main"
        dest: "{{ document_root }}" # Destination : /var/www/html sur la machine distante
        mode: preserve # Conserve les permissions des fichiers d'origine

    - name: Apply Nginx template
      template:
        src: files/nginx.conf.j2 # Template Jinja2 local (les variables comme server_name y sont injectées)
        dest: /etc/nginx/sites-available/default # Config Nginx sur la machine distante
      notify: Restart Nginx # Déclenche le handler si ce fichier est modifié

    - name: Enable new site
      file:
        src: /etc/nginx/sites-available/default # Fichier de config du site
        dest: /etc/nginx/sites-enabled/default # Lien symbolique pour activer le site
        state: link # Crée un lien symbolique (équivalent de "ln -s")
      notify: Restart Nginx 

    - name: Allow all access to tcp port 80
      ufw:
        rule: allow
        port: '80'
        proto: tcp

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```




#### Contenu de la page Web  

"root@Master-Nico-Ansible:~/ansible-nginx-demo/html_demo_site-main# cat index.html"  
![alt text](<Images/Capture d'écran 2026-03-12 160029.png>)  


**Exécution du playbook :**  

`ansible-playbook -i inventory.ini playbook.yml -u devops`  
![alt text](<Images/Capture d'écran 2026-03-12 162615.png>)  

Connexion depuis une autre machine sur le même réseau vers ma machine cliente.  
![alt text](<Images/Capture d'écran 2026-03-12 165337.png>)

