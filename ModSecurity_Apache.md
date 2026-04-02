
### Prérequis et préparation 

Je travaille sur un VM Debian 12 GUI sur mon PC perso avec VirtualBox avec une carte en bridge pour communiquer avec mon PC physique.  
Avec droits sudo (membre du groupe sudoer `getent group sudo` et éviter "root"):  
`sudo apt update && sudo apt upgrade -y`  

#### Installer Apache2
`sudo apt install apache2 -y`  
`sudo systemctl status apache2` : doit renvoyer "Active"  








Pour créer le fichier .htpasswd  :  
`sudo htpasswd -c /etc/apache2/.htpasswd nomutilisateur`



### Protéger accès au site web par username/password

Dans `/var/www/wordpress/.htaccess`  

```bash
Options -Indexes

AuthType Basic
AuthName "development In Progress"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user
```

``systemctl restart apache2``  

Maintenant l'accès au serveur se fait par mot de passe