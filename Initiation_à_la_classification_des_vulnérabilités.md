# Initiation à la classification des vulnérabilités
---

<details>
  <summary><h2>💡 Définition de CVE, CVSS et EPSS</h2></summary>  
  
🧩 **CVE – Common Vulnerabilities and Exposures**

Identifiant unique attribué à une faille de sécurité connue.  
Chaque CVE correspond à une vulnérabilité précise, répertoriée publiquement (ex. : CVE-2017-0144).  
→ But : permettre de parler de la même faille partout dans le monde.

⚙️ **CVSS – Common Vulnerability Scoring System**

Système de notation standardisé qui évalue la gravité technique d’une vulnérabilité.  
Score de 0 à 10, basé sur la facilité d’exploitation et l’impact (confidentialité, intégrité, disponibilité).  
→ But : mesurer à quel point une faille est dangereuse.  

📈 **EPSS – Exploit Prediction Scoring System**

Indicateur de probabilité qu’une vulnérabilité soit exploitée dans la nature.  
Score de 0 à 1 (ou 0 % à 100 %), calculé à partir de données réelles d’exploitation et de modèles statistiques.  
→ But : estimer le risque qu’une faille soit effectivement attaquée.  

</details>

## 🔷 Eternal Blue

* **Donnez la référence CVE**  

CVE-2017-0144  


* **Décrire la vulnérabilité en une phrase**  
  
C'est un exploit développé par la NSA qui utilise une faille de sécurité présente dans la première version de SMB (SMBv1). Cette faille a été exploité par le ransomware "WannaCry".  


* **Citez des éléments d'infrastructure pouvant être concernés**  

Les serveurs SMBv1 sous Microsoft Windows Vista SP2; Windows Server 2008 SP2 and R2 SP1; Windows 7 SP1; Windows 8.1; Windows Server 2012 Gold and R2; Windows RT 8.1; and Windows 10 Gold, 1511, and 1607; and Windows Server 2016  

* **Trouvez, mettez à jour ou calculez le score base CVSS (dernière version)**  
  
Le score Base CVSS v3.1 pour CVE-2017-0144 est 8,80 (High)  

* **Déterminer si un exploit est disponible publiquement, si oui en prendre connaissance et le citer en référence.**  

Microsoft Windows 7/8.1/2008 R2/2012 R2/2016 R2 - 'EternalBlue' SMB Remote Code Execution (MS17-010)  
Microsoft Windows 7/2008 R2 - 'EternalBlue' SMB Remote Code Execution (MS17-010)  
Microsoft Windows 8/8.1/2012 R2 (x64) - 'EternalBlue' SMB Remote Code Execution (MS17-010)  


* **Trouver si un score EPSS existe pour cette vuln**  

Oui, un score EPSS existe : autour de 0,94318 (soit ~94,3 %) : forte probabilté d'exploitation  


---

## 🔷 Krack

* **Donnez la référence CVE**

CVE-2017-13077 (CVE-2017-13077,CVE-2017-13078,CVE-2017-13079,CVE-2017-13080,CVE-2017-13081,CVE-2017-13082,CVE-2017-13084, CVE-2017-13086,CVE-2017-13087,CVE-2017-13088)

* **Décrire la vulnérabilité en une phrase**

KRACK est l'acronyme de Key Reinstallation Attack (attaque de réinstallation de clé). L'attaque KRACK est une attaque par rejeu sévère sur le protocole d'accès protégé Wi-Fi (WPA2) qui sécurise vos connexions sans fil.
Les attaquants qui utilisent l'attaque KRACK peuvent accéder aux noms d'utilisateur, aux mots de passe et aux données stockées sur les appareils. Les pirates peuvent lire les emails et voir des photos des données transmises, puis utiliser ces informations pour faire du chantage aux utilisateurs ou les vendre sur le Dark Web.  

* **Citez des éléments d'infrastructure pouvant être concernés**

Tous les appareils connectés en WiFi.  

* **Trouvez, mettez à jour ou calculez le score base CVSS (dernière version)**

CVSS score 3.0 : 6.8/10  

* **Déterminer si un exploit est disponible publiquement, si oui en prendre connaissance et le citer en référence.**

[https://github.com/omaidf/KRACK-toolkit](https://github.com/omaidf/KRACK-toolkit)

* **Trouver si un score EPSS existe pour cette vuln**

EPSS : 0.77% : Peu de chance

---

## 🔷 log4shell

* **Donnez la référence CVE**  
CVE-2021-44228 (CVE-2021-45046 et CVE-2021-45105) 

* **Décrire la vulnérabilité en une phrase**  

Vulnérabilité d’exécution de code à distance (RCE, remote code execution) qui permet à des acteurs malveillants d’exécuter un code Java arbitraire, en prenant le contrôle d’un serveur cible.  

* **Citez des éléments d'infrastructure pouvant être concernés**  

Tout appareil connecté à Internet exécutant Apache Log4j versions 2.0 à 2.14.1. Les versions concernées sont incluses dans Apache Struts, Apache Solr, Apache Druid, Elasticsearch, Apache Dubbo et VMware vCenter.  


* **Trouvez, mettez à jour ou calculez le score base CVSS (dernière version)**  
  
CVSS Score 3.1 : 10/10  

* **Déterminer si un exploit est disponible publiquement, si oui en prendre connaissance et le citer en référence.**  

AD Manager Plus 7122 - Remote Code Execution (RCE)  
Apache Log4j2 2.14.1 - Information Disclosure  
Apache Log4j 2 - Remote Code Execution (RCE)  

* **Trouver si un score EPSS existe pour cette vuln**  
  
EPSS: 94.36%  

---

## 🔷 Looney-tunables

* **Donnez la référence CVE**  
  
CVE-2023-4911  

* **Décrire la vulnérabilité en une phrase**  
  
La bibliothèque C du projet GNU est affectée par une faille de sécurité baptisée "Looney Tunables" ! En l'exploitant, un attaquant en local peut élever ses privilèges afin d'obtenir les droits "root" sur la machine Linux ! Voici ce qu'il faut savoir.  

* **Citez des éléments d'infrastructure pouvant être concernés**  
  
Elle affecte les distributions les plus populaires : Debian, Ubuntu, Fedora, Red Hat Enterprise Linux : Fedora 37 et 38, Ubuntu 22.04 et 23.04, et Debian 12 et 13  

* **Trouvez, mettez à jour ou calculez le score base CVSS (dernière version)**  
  
CVSS version 3.1: 7.8/10  

* **Déterminer si un exploit est disponible publiquement, si oui en prendre connaissance et le citer en référence.**

[https://github.com/hadrian3689/looney-tunables-CVE-2023-4911](https://github.com/hadrian3689/looney-tunables-CVE-2023-4911)


* **Trouver si un score EPSS existe pour cette vuln**
  
EPSS : 78.36%   

---


## 🔷 Une vulnérabilité récente de votre choix issue du site du CERT-Fr : *Multiples vulnérabilités dans Microsoft SharePoint*

* **Donnez la référence CVE**  

CVE-2025-53771 (CVE-2025-53770)

* **Décrire la vulnérabilité en une phrase**  

Attaque de type *Path traversal*, affectant SharePoint Enterprise Server 2016, SharePoint Server 2019 et SharePoint Server Subscription Edition. L'éditeur indique que la vulnérabilité CVE-2025-53770 permet à un attaquant de provoquer une désérialisation de données non fiables entrainant une exécution de code arbitraire à distance. L'éditeur indique que la vulnérabilité CVE-2025-53771 permet à un attaquant de provoquer une usurpation d'identité sur un réseau.  

* **Citez des éléments d'infrastructure pouvant être concernés**  

Microsoft SharePoint Enterprise Server 2010 toutes versions
Microsoft SharePoint Enterprise Server 2013 toutes versions
Microsoft SharePoint Enterprise Server 2016 versions antérieures à 16.0.5513.1001
Microsoft SharePoint Server 2019 versions antérieures à 16.0.10417.20037
Microsoft SharePoint Server Subscription Edition versions antérieures à 16.0.18526.20508


* **Trouvez, mettez à jour ou calculez le score base CVSS (dernière version)**  

CVSS Score 3.1: 9.8/10  

* **Déterminer si un exploit est disponible publiquement, si oui en prendre connaissance et le citer en référence.**  

Microsoft SharePoint Server 2019 (16.0.10383.20020) - Remote Code Execution (RCE) (CVE-2025-53770)  

* **Trouver si un score EPSS existe pour cette vuln**  

EPSS: 86.34%  

---
