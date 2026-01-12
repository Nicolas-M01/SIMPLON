
![alt text](<Images/Capture d'écran 2026-01-12 173347.png>)




## Analyse de l’infrastructure
• **Analyser l'infrastructure et la configuration des équipements**  
✅😸✅

• **Qu’est-ce que HSRP ? Proposer une définition simple.**  
Host Standby Router Protocol (HSRP) est un protocole propriétaire de Cisco implémenté sur les routeurs et les commutateurs de niveau 3 permettant une continuité de service.  

• **Pourquoi utilise-t-on HSRP et quel problème résout-il ? Expliquer l'intérêt de HSRP dans ce réseau**  
HSRP est principalement utilisé pour assurer la disponibilité de la passerelle par défaut dans un sous-réseau en dépit d'une panne d'un routeur.  


---

## Analyse de la configuration existante
• **Identifier les routeurs primaires et les routeurs de secours HSRP, quels sont leurs rôles respectifs ?**  
La commande `show standby` permet de voir les interfaces actives.  
![alt text](<Images/Capture d'écran 2026-01-12 175124.png>)  

:bulb: **HSRP GROUP 1**  
Sur la photo, exemple avec le routeur `R2` (milieu), il est en écoute mais pas actif sur le réseau 172.30.128.0/24 (HSRP group 1), le routeur actif est le routeur `R1` à l'adresse virtuelle 172.30.128.254 (avec son adresse réelle 172.30.128.251).  
Si `R1` tombe, c'est `R3` qui devient actif, et `R2` deviendra "standby" et ce sera le suivant actif si `R3` tombe.  

:bulb: **HSRP GROUP 2**  
Le `R2` est en standby, le routeur actif est `R3` et `R1` en listen (donc dernier à prendre le relai)  

• **Noter les adresses IP virtuelles (VIP) et physiques (R1, R2, R3) utilisées dans les groupes HSRP, à quoi servent ces différentes adresses ?**  
:bulb: **HSRP GROUP 1**  
VIP : 172.30.128.254/24  
`R1`
`R2`
`R3`


:bulb: **HSRP GROUP 2**  
VIP : 92.60.150.1/24  
`R1`
`R2`
`R3`



• **Identifier les interfaces réseau participant à HSRP sur chaque routeur, leurs priorités, les délais et les autres paramètres HSRP configurés sur les routeurs. Que comprenez-vous ?**  

---

## Configuration HSRP  
• **À l'aide des informations que vous avez collectées, proposer un guide de commandes de configuration HSRP.**  

**Expliquer brièvement le rôle de chaque commande utilisée. Identifier les éléments clés tels que le numéro de groupe HSRP, les adresses IP virtuelles, les priorités, les délais, ainsi que les commandes permettant d'activer HSRP sur l'interface.**  
