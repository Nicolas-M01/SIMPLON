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

> :gear: Ajout du bloc qui permet d'obtenir périodiquement la liste des processus en cours d'exécution dans `/var/ossec/etc/ossec.conf` :  
```ini
<ossec_config>
  <localfile>
    <log_format>full_command</log_format>
    <alias>process list</alias>
    <command>ps -e -o pid,uname,command</command>
    <frequency>30</frequency>
  </localfile>
</ossec_config>
```
Puis redémarrer l'agent Wazuh...


> :bulb: Sur la machine cliente j'installe (ou je vérifie qu'ils le sont...) "netcat" et "nmap" qui servent respectivement à des ports en TCP/UDP et à écouter les ports ouverts sur un réseau.  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 223103.png>)

> :gear: Côté serveur Wazuh, dans `/var/ossec/etc/rules/local_rules.xml`, pour créer une règle qui se déclenche à chaque lancement du programme Netcat :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 224801.png>)  

> :gear: Sur le client je lance le port 8000 en écoute : `nc -l 8000`  

> ✅ Sur le serveur je peux voir l'évènement du port en écoute :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 225225.png>)

---

## 🔵 Détection de tentatives d'injection SQL
> :bulb: Côté client, vérifier que Apache2 ets bien installé ✅:  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 230408.png>)

> ✅ Apache2 tourne :  
> ![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 230646.png>)


> :gear: Dans `/var/ossec/etc/ossec.conf`, ajouter les lignes ci dessous pour surveiller les journaux d'accès du serveur Apache  
```ini
<ossec_config>
  <localfile>
    <log_format>apache</log_format>
    <location>/var/log/apache2/access.log</location>
  </localfile>
</ossec_config>
```
> :gear: Redémarrer l'agent Wazuh...

> :gear: sur l'attaquant : `curl -XGET "http://<UBUNTU_IP>/users/?id=SELECT+*+FROM+users";`  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-26 232036.png>)

> ✅ Je vois la requête de l'attaquant sur le dashboard :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-26 231912.png>)  


---

## 🔵 Détection de cheval de troie

> :gear: Paramétrage du fichier `/var/ossec/etc/ossec.conf` sur le client :
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 095232.png>)

> :gear: Puis `sudo cp -p /usr/bin/w /usr/bin/w.copy` pour copier le fichier binaire du système puis remplacer système d'origine /usr/bin/w par le script shell suivant :  
```bash
sudo tee /usr/bin/w << EOF
!/bin/bash
echo "`date` this is evil" > /tmp/trojan_created_file
echo 'test for /usr/bin/w trojaned file' >> /tmp/trojan_created_file
Now running original binary
/usr/bin/w.copy
EOF
```
Redémarrer le service Wazuh-agent... 


> ✅ Je vois la détection d'anomalies et de logiciels malveillants sur le dashboard :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 094822.png>)

---

## 🔵 Traitement de malware à travers l'intégration de VirusTotal

#### Côté client

> :gear: Dans `/var/ossec/etc/ossec.conf`, dans bloc `<syscheck>` ajouter la ligne :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 100451.png>)


> :gear: Créer `/var/ossec/active-response/bin/remove-threat.sh` et ajouter :  
```bash
#!/bin/bash

LOCAL=`dirname $0`;
cd $LOCAL
cd ../

PWD=`pwd`

read INPUT_JSON
FILENAME=$(echo $INPUT_JSON | jq -r .parameters.alert.data.virustotal.source.file)
COMMAND=$(echo $INPUT_JSON | jq -r .command)
LOG_FILE="${PWD}/../logs/active-responses.log"

#------------------------ Analyze command -------------------------#
if [ ${COMMAND} = "add" ]
then
 # Send control message to execd
 printf '{"version":1,"origin":{"name":"remove-threat","module":"active-response"},"command":"check_keys", "parameters":{"keys":[]}}\n'

 read RESPONSE
 COMMAND2=$(echo $RESPONSE | jq -r .command)
 if [ ${COMMAND2} != "continue" ]
 then
  echo "`date '+%Y/%m/%d %H:%M:%S'` $0: $INPUT_JSON Remove threat active response aborted" >> ${LOG_FILE}
  exit 0;
 fi
fi

# Removing file
rm -f $FILENAME
if [ $? -eq 0 ]; then
 echo "`date '+%Y/%m/%d %H:%M:%S'` $0: $INPUT_JSON Successfully removed threat" >> ${LOG_FILE}
else
 echo "`date '+%Y/%m/%d %H:%M:%S'` $0: $INPUT_JSON Error removing threat" >> ${LOG_FILE}
fi

exit 0;
```

> :gear: Installation de "jq"  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 100637.png>)

> :gear: Je modifie les droits et la propriété pour obtenir :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 100914.png>)


#### Côté serveur  

> :gear: `/var/ossec/etc/rules/local_rules.xml`, ces règles permettent de signaler les modifications apportées au /rootrépertoire et détectées par les analyses FIM :  
```ini
<group name="syscheck,pci_dss_11.5,nist_800_53_SI.7,">
    <!-- Rules for Linux systems -->
    <rule id="100200" level="7">
        <if_sid>550</if_sid>
        <field name="file">/root</field>
        <description>File modified in /root directory.</description>
    </rule>
    <rule id="100201" level="7">
        <if_sid>554</if_sid>
        <field name="file">/root</field>
        <description>File added to /root directory.</description>
    </rule>
</group>
```


> :gear: Création d'un compte sur VirusTotal et récupération de l'API
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 105015.png>)

> :gear: Dans `/var/ossec/etc/ossec.conf`, pour activer l'intégration VirusTotal
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 105543.png>)

> :gear: Ajouter ce bloc dans <ossec_config> pour activer automatiquement le script "remove-threat" lorsque VirusTotal détecte un fichier malveillant  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 105935.png>)

> :gear: Recevoir des alertes concernant les résultats de la réponse active, dans `/var/ossec/etc/rules/local_rules.xml`, ajouter :  
>  ![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 110724.png>)  

> :bulb: Redémarrer service.  

> :gear: Télécharger fichier depuis la cible dans /root  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 111856.png>)

> ✅ Je vois les alertes dans mon Dashboard avec les bons filtres  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-27 111631.png>)


---

## 🔵 Détection de vulnérabilités

#### Côté serveur  
> :gear: La détection des vulnérabilités est bien activée dans `/var/ossec/etc/ossec.conf`  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 112957.png>)


> :bulb: Redémarrer service...

> :gear: Réduction du temps nécessaire de détection de vuln dans `/var/ossec/etc/ossec.conf` de 1H à 10mn  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 113740.png>)



> ✅ Visualisation dans la détection des vulnérabilités, des CVE de la machine cliente
> ![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 115908.png>)


---

## 🔵 Détection de processus cachés par rootkit

#### Côté client 
> :gear: Le noyau est à jour en root  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 123757.png>)

> :gear: Installation de `gcc` et `git`  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 123539.png>)

> :gear: Config dans `/var/ossec/etc/ossec.conf` pour que l'agent Wazuh exécute des analyses rootcheck toutes les 2mn (au lieu de 12H)  
> ![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 124251.png>)

> :bulb: Redémarrer service...  

> :gear: Installation de Diamorphine depuis le dépôt officiel `git clone https://github.com/m0nad/Diamorphine`
> Puis je vérifie que le rootkit est bien activé. Il tourne en tâche de fond et est peu visible (il faut faire un kill sur PID 63 pour le rendre visible) :
> ![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-27 141859.png>)
> ✅ Le rootkit est actif ✅

> :gear: Je vois le processus "journald" actif (journald pour Kali). Puis je "kill -31 +PID de journald", ce qui le rend invisible.
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 142957.png>)


> **✅ Les alertes concernant le Rootkit remontent ✅**  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-27 144203.png>)

> :bulb: Pour décharger le rootkit il faut le rendre visible  
`kill -63 0`  
Puis décharger  
`sudo rmmod diamorphine`  

---

## 🔵 Détection de commandes malveillantes

#### Côté client

> :gear: auditd est installé
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 150729.png>)

> :gear: Ajouter les règles d'audit au `/etc/audit/audit.rules`, puis rechargement des règles et vérif qu'elles sont en place :    
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d’écran 2026-05-27 152738.png>)
> ✅ Elles sont bien là

> :gear: Ajout de la conf dans `/var/ossec/etc/ossec.conf` qui permet à Wazuh agent de lire le fichier de journaux auditd : 
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 153346.png>)
Redémarrer service ....  



#### Côté serveur
> :bulb: Les paires clé-valeur sont bien présentes dans le fichier de recherche
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 155405.png>)

> :gear: Création de la liste CDB `/var/ossec/etc/lists/suspicious-programs` avec :  
```bash
ncat:yellow
nc:red
tcpdump:orange
```

> :gear: J'ajoute la liste "suspicious-programs" à la <ruleset> dans `/var/ossec/etc/ossec.conf` :
> `<list>etc/lists/suspicious-programs</list>` :  

> :gear: Création d'une règle de haute gravité qui se déclenchera lorsqu'un programme « rouge » est exécuté :  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 161147.png>)
Redémarrer service Wazuh ensuite...  

#### Emulation d'attaque
> :gear: J'installe Netcat sur la machine cliente, ici version openBSD 
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 162609.png>)

> ✅ On voit bien les alertes sur le Dashboard du serveur Wazuh lorsque j'installe et lance "Netcat" sur la machine cliente  
![alt text](<image/Déployer_une_surveillance_de_sécurité_avec_Wazuh_et_détecter_des_incidents/Capture d'écran 2026-05-27 162118.png>)


---

## 🔵 Détection d'attaques shellshock


---

## Schéma de l’architecture de supervision
## Documentation d’installation et de configuration de Wazuh
## Captures d’écran du fonctionnement de la plateforme
## Documentation des règles de détection configurées
## Rapport d’analyse des incidents détectés
## Rapport de tests des différents cas d’usage
## Procédure de déploiement et d’exploitation
