
![alt text](<Images/Capture d'écran 2026-01-12 173347.png>)




## Analyse de l’infrastructure
• **Analyser l'infrastructure et la configuration des équipements**  
✅😸✅

• **Qu’est-ce que HSRP ? Proposer une définition simple.**  
Host Standby Router Protocol (HSRP) est un protocole propriétaire de Cisco implémenté sur les routeurs et les commutateurs de niveau 3 permettant une continuité de service.  

• **Pourquoi utilise-t-on HSRP et quel problème résout-il ? Expliquer l'intérêt de HSRP dans ce réseau**  
HSRP est principalement utilisé pour assurer la disponibilité de la passerelle par défaut dans un sous-réseau en dépit d'une panne d'un routeur. Les endpoints ne connaissent que l'adresse IP virtuelle, c'est leur GW.  


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
>:bulb: **HSRP GROUP 1**  
VIP : 172.30.128.254/24  
`R1`: 172.30.128.251/24  
`R2`: 172.30.128.252/24  
`R3`: 172.30.128.253/24  


>:bulb: **HSRP GROUP 2**  
VIP : 92.60.150.1/24  
`R1`: 92.60.150.2/24  
`R2`: 92.60.150.3/24  
`R3`: 92.60.150.4/24  

>:bulb: Les adresses physiques prennent l'adresse virtuelle de la passerelle par défaut grâce au protocole HSRP.  


• **Identifier les interfaces réseau participant à HSRP sur chaque routeur, leurs priorités, les délais et les autres paramètres HSRP configurés sur les routeurs. Que comprenez-vous ?**  
### `R1`:  
* **HSRP GROUP 1:**
  - GigabitEthernet0/0/0 : 172.30.128.251/24 : Priority 120 donc prioritaire  
  
* **HSRP GROUP 2:**
  - GigabitEthernet0/0/1 : 92.60.150.2/24 : Priority 100  


### `R2`:  
* **HSRP GROUP 1:**
  - GigabitEthernet0/0/0 : 172.30.128.252/24 : Priority 100   

* **HSRP GROUP 2:**
  - GigabitEthernet0/0/1 : 92.60.150.3/24 : Priority 100   


### `R3`:  
* **HSRP GROUP 1:**
  - GigabitEthernet0/0/0 : 172.30.128.253/24 : Priority 100   

* **HSRP GROUP 2:**
  - GigabitEthernet0/0/1 : 92.60.150.4/24 : Priority 100   


>:bulb: Délais : Toutes les 3 secondes le routeur envoie aux autres routeur du HSRP, un message "Hello" pour dire qu'il est bien dispo si besoin. Le hold time est le temps d'attente sans réponse du routeur actif pour qu'un autre routeur prenne le relai.  
Dans le cas d'une priorité équivalente, c'est l'adresse IP la plus élevée qui sera choisie.  

![alt text](<Images/Capture d'écran 2026-01-12 184737.png>)


---

## Configuration HSRP  
• **À l'aide des informations que vous avez collectées, proposer un guide de commandes de configuration HSRP.**  
**Expliquer brièvement le rôle de chaque commande utilisée. Identifier les éléments clés tels que le numéro de groupe HSRP, les adresses IP virtuelles, les priorités, les délais, ainsi que les commandes permettant d'activer HSRP sur l'interface.**  


Si on prend la config de `R1` pour chaque interface :  

* Pour GigabitEthernet0/0/0 :  
``enable`` : mode root  
``conf t`` : mode config  
``interface g0/0/0`` : sélection interface    
``ip address 172.30.128.251 255.255.255.0`` : attribution IP à cette interface  
``standby 1 ip 172.30.128.254`` : Mise en standby du groupe 1 avec IP virtuelle 172.30.128.254 (le groupe se crée ici, groupe 1)  
``standby 1 priority 120`` : Paramétrage de la pritorité  
``standby 1 preempt`` : Le routeur avec la priorité la plus élevée reprend son status actif en fonction des priorités.  
``no shutdown`` : Interface reste allumée  
``exit`` : sortie de l'interface  


* Pour GigabitEthernet0/0/1 :  
``enable``  
``conf t``  
``interface g0/0/1``  
``ip address 92.60.150.4 255.255.255.0``  
``standby 2 ip 92.60.150.4``  
``standby 2 priority 100``  
``standby 2 preempt``  
``no shutdown``  
``exit``  


