
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

*  `nano inventory.ini` : pour configurer le fichier d'inventaire des machines.   
  

  ```ini
  [serveurs_web]
  192.168.1.16 =root
  ```  

