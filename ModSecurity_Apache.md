
### Prérequis et préparation 

Je travaille sur un VM Debian 12 GUI sur mon PC perso avec VirtualBox avec une carte en bridge pour communiquer avec mon PC physique.  
Avec droits sudo (membre du groupe sudoer `getent group sudo` et éviter "root"):  
`sudo apt update && sudo apt upgrade -y`  

#### Installer Apache2
`sudo apt install apache2 -y`  
`sudo systemctl status apache2` : doit renvoyer "Active"  

#### Installer et configurer ufw
`sudo apt install ufw`, `sudo ufw allow 'OpenSSH'`, `sudo ufw allow 80` `sudo ufw allow 443`, `sudo ufw enable`  
> :bulb: Pare feu actif et bien paramétré :  
![alt text](<Images/Capture d'écran 2026-04-02 111517.png>)


#### Installer/Configurer moteur ModSecurity  

`sudo apt install libapache2-mod-security2 -y`
sudo a2enmod security2  
sudo systemctl restart apache2  
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf  


#### Intégration de l'OWASP Core Rule Set (CRS)

``cd /tmp``
``wget "https://github.com/coreruleset/coreruleset/archive/refs/tags/v4.25.0.tar.gz" `` 
``tar -xzvf v4.25.0.tar.gz``  
``sudo mv coreruleset-4.25.0/ /etc/apache2/modsecurity-crs``  
``cd /etc/apache2/modsecurity-crs``  
``sudo cp crs-setup.conf.example crs-setup.conf``  








`sudo nano /etc/modsecurity/modsecurity.conf`  
```bash
SecRuleEngine On   # Activer les règles, retirer "DetectionOnly"  
SecRequestBodyAccess On
SecResponseBodyAccess On
SecAuditEngine RelevantOnly
```










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