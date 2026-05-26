## Installation et configuration de Wazuh  

> #### :bulb: Voici les recommandations matérielles pour faire tourner Wazuh :

![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 111641.png>)

### 🔵 Installation OS 
>✅ J'ai installé **Ubuntu 24.04** avec GUI qui fait partie des OS recommandés avec une carte en bridge.  

>✅ Je mets à jour la liste des paquets et je mets à jour ensuite le système
`sudo apt update && sudo apt upgrade -y`  

### Installation Wazuh serveur
>:gear: Installation de Wazuh avec curl (après instll de curl)  
`curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh && sudo bash ./wazuh-install.sh -a`  

> :bulb: A la fin de l'installation le username et un password fort sont générés automatiquement.  
> ![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 115039.png>)


> :bulb: Je peux ensuite me connecter avec l'interface Web : **`127.0.0.1`** et me connecter 
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 115859.png>)

>:bulb: Les user/password sont stockés dans un ficher compressé accessible avec : `sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt`  

> :bulb: Désactivation des mises à jour de Wazuh pour éviter les mises à jour accidentelles susceptibles de perturber l'environnement :  
`sudo sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list`  
`sudo apt update`  


#### ✅ L'installation du SIEM Wazuh est terminée, nous pouvons passer à l'installation de l'agent sur les endpoints pour surveiller leur activité 😹.  

---

## 🔵 Installation Wazuh agent
> :gear: L'agent Wazuh est important sur les machines clientes, c'est lui qui va permettre de faire remonter les logs vers le serveur Wazuh.  

```bash
# Prérequis
sudo apt install -y gnupg apt-transport-https

# Clé GPG
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

# Dépôt (écraser avec > pour éviter les doublons)
sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list'

# Installer avec l'IP du serveur Wazuh
sudo apt update
sudo WAZUH_MANAGER="192.168.1.19" apt install -y wazuh-agent

# Corriger l'IP dans la config (si MANAGER_IP n'a pas été remplacé)
sudo sed -i 's/MANAGER_IP/192.168.1.19/' /var/ossec/etc/ossec.conf

# ============================================
# 3. CONFIGURER SURICATA DANS WAZUH
# ============================================

# Ajouter les logs Suricata dans la config Wazuh
sudo nano /var/ossec/etc/ossec.conf
# → Ajouter avant </ossec_config> :
# <localfile>
#   <log_format>json</log_format>
#   <location>/var/log/suricata/eve.json</location>
# </localfile>

# ============================================
# 4. DÉMARRER LES SERVICES
# ============================================
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
sudo systemctl status wazuh-agent
```

![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 150635.png>)

> **✅ L'agent Wazuh est maintenant installé sur la machine cliente**


![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-26 150257.png>)
> **✅ La machine cliente est maintenant visible sur le dashboard du serveur**

> :bulb: Désactiver les mises à jour de Wazuh sur l'agent pour garder les compatibilités

```bash
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/wazuh.list
apt-get update
echo "wazuh-agent hold" | dpkg --set-selections
```

---

## 🔵 Installation NIDS Suricata  
> :gear: J'installe l'agent Suricata sur la VM cliente Kali qui contient l'agent Wazuh.    

```bash
# 1. Installer le paquet nécessaire pour add-apt-repository (inutile au final, mais nécessaire pour diagnostiquer)
sudo apt update && sudo apt install -y software-properties-common

# 2. Installer Suricata directement via les dépôts Kali (les PPA Ubuntu ne sont pas compatibles)
sudo apt update && sudo apt install -y suricata --fix-missing

# 3. Vérifier l'installation
suricata --version
```

> **✅ L'agent est installé et fonctionnel.**

> :bulb: Télécharger et extraire le jeu de règles Emerging Threats Suricata :
>```bash
>cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
>sudo tar -xvzf emerging.rules.tar.gz && sudo mkdir /etc/suricata/rules && sudo mv rules/*.rules /etc/>suricata/rules/
>sudo find /etc/suricata/rules -name "*.rules" -exec chmod 777 {} \;
>```

![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 124506.png>)


>:gear: Modifier les paramètres de Suricata dans le `/etc/suricata/suricata.yaml` :  
```yaml
HOME_NET: "<UBUNTU_IP>"
EXTERNAL_NET: "any"

default-rule-path: /etc/suricata/rules
rule-files:
- "*.rules"

# Global stats configuration
stats:
enabled: yes

# Linux high speed capture support
af-packet:
  - interface: eth0 # Bien mettre le nom de sa carte réseau
```
> :gear: Redémarrer le service Suricata pour prendre en compte ls modif :  
`sudo systemctl restart suricata`  

#### Ajout de la config à `/var/ossec/etc/ossec.conf`, qui permettra à Wazuh agent de lire le fichier de journaux Suricata :

```ini
<ossec_config>
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
</ossec_config>
```

> :bulb: On redémarre l'agent pour la prise en compte des modif :  
`sudo systemctl restart wazuh-agent` : le service doit être running  


### Émulation d'attaque
On lance des pings depuis le serveur vers le client : `ping 192.168.1.145` :  
Sur le Dashboard on voit les paquets ICMP dans les journaux d'évènements  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-26 163901.png>)  

---

## 🔵 Surveillance de l'intégrité de répertoires/fichiers sensibles :  
> :gear: Pour configurer l'agent Wazuh afin qu'il surveille les modifications du système de fichiers dans le répertoire :  

>**:bulb: Adaptation pour Kali qui ne fonctionne pas comme Ubuntu pour les agents...**  
```bash
# 1. Installer auditd (requis pour whodata)
sudo apt install -y auditd
sudo systemctl start auditd
sudo systemctl enable auditd
```

Modifier : `/var/ossec/etc/ossec.conf` pour ajouter :  
Dans le bloc \<syscheck> :  
`<directories check_all="yes" report_changes="yes" whodata="yes">/root</directories>`  

Dans le bloc \<syscheck> :  
`<frequency>5</frequency>` pour update toutes les 5 secondes  

`sudo systemctl restart wazuh-agent`  


> :gear: Création dans la racine d'un fichier, modif et suppression :  
>```bash
>touch /root/test.txt
>nano /root/test.txt
>rm /root/test.txt
>```



> ✅ Sur le dashboard, les logs de création, modif et suppression apparaissent bien  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 182459.png>)


---

## 🔵 Détection d'attaques bruteforce

### Configuration

> :bulb: Sur la machine cliente ciblée il faut un serveur SSH activé 
> ![alt text](image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/blabla.png)

> :bulb: Côté attaquant, Hydra est déjà installé.   


### Émulation d'attaque
> :gear: Créez un fichier texte contenant 10 mots de passe aléatoires  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 192929.png>)

> :gear: Côté attaquant je lance le bruteforce avec  passwords aléatoires  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 193718.png>)


> ✅ Côté serveur, je vois les logs :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 193633.png>)


---

## 🔵 Détection de processus non autorisés




---

## Schéma de l’architecture de supervision
## Documentation d’installation et de configuration de Wazuh
## Captures d’écran du fonctionnement de la plateforme
## Documentation des règles de détection configurées
## Rapport d’analyse des incidents détectés
## Rapport de tests des différents cas d’usage
## Procédure de déploiement et d’exploitation
