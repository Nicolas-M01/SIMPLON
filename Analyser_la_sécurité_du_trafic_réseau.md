
## Contexte

Il vous est demandé de procéder à l'analyse des protocoles utilisés sur le réseau et de détecter d'éventuelles faiblesses.

à partir du Lab installé, ajouter les services nécessaires et répondre aux questions suivantes  

### Rappels  

* Quelle est votre adresse IP ? Quelle est sa classe (IPv4) ?  
🔹 192.168.0.253  
* Quel est votre masque de sous-réseau ?  
🔹masque sous réseau 255.255.255.0 / CIDR: 24  
* Quelle est l'adresse de votre passerelle ?  
🔹Aucune je suis en réseau interne isolé.  

### Questions  

**0. Quels sont les `flags TCP` ?**  
🔹 Il existe 6 flags en TCP  
`SYN` : Utilisé pour initier une communication TCP (un client souhaite se connecter à un serveur)  
`ACK` : Sert à accuser réception d'un paquet reçu. (Du client au serveur puis lui dire "Ok on peut communiquer", ce paquet suit un `SYN+ACK` du serveur vers le client pour dire "Ok j'ai reçu ta demande, je suis prêt")  

    > 💡Les 3 principaux flags TCP utilisés pour le "3 way handshake" sont :  `SYN` puis `SYN+ACK` puis `ACK` et la connection est établie.  


 `FIN` : Fin de connection. L'une des 2 machines envoie ce flag pour stopper la communication. S'en suit un `ACK` par l'autre machine, puis un `FIN` et le premier répond avec `ACK` et la connection est fermée.  
    `RST` : Reset, en cas d'erreur sert à couper brutalement la connection (paquet innatendu, port non ouvert, appli qui plante).  
    `PSH` : Ordonne à la pile TCP d' envoyer immédiatement les données mises en mémoire tampon à l'application au lieu d'attendre que la mémoire tampon soit pleine  
    `URG` : Signale que les données du segment sont urgentes et doivent être traitées avant les autres segments en file d'attente.  
   
---

**1. Capturer le processus `DORA` du protocole DHCP**  
🔹Ma machine cliente windows est en DHCP et un serveur DHCP est installé sur mon serveur Windows. je réalise un `ipconfig /release` pour libérer l'adresse IP, pusi un `ipconfig /renew` pour qu'il recherche une nouvelle IP grâce au serveur DHCP. En filtrant par "dhcp"  
![alt text](<Capture d'écran 2025-11-04 094302.png>)  

---

**2. qu’est ce que le `DHCP Starvation` / `snooping` ? `Rogue DHCP` ?**  
🔹 `DHCP Starvation` : signifie "famine" en anglais. Le principe est qu'un attaquant s'introduise sur un réseau LAN pour épuiser toutes les adresses attribuables du serveur DHCP officiel en envoyant massivement des requêtes : DHCPDISCOVER / DHCPREQUEST.  
Les nouveaux appareils légitimes ne peuvent plus obtenir d’adresse IP → perte de connectivité réseau.  
`snooping` : Sécurité réseau, filtre les messages DHCP sur un switch pour contrôler quels ports peuvent servir de serveur DHCP et quels ports ne le peuvent pas. Les ports fiables ("trusted") : là où se trouve le vrai serveur DHCP. Les ports non fiables ("untrusted") : ports clients, où les appareils normaux demandent une IP.  
`Rogue DHCP` : C'est un faux serveur DHCP qui va founrir les IP avec comme passerelle par défaut, l'adresse de l'attaquant ce qui lui permet par exemple de récupérer/observer le trafice réseau.  

Ce dernier va ensuite installer un serveur DHCP malveillant pour attribuer des adresses IP avec son adresse IP comme passerelle par défaut. Sur le PC de l'attaquant, le routage est activé

---

**3. Que ce passe-t-il lors de l'execution de la commande `ipconfig /release` (windows) ? D’un point de vue sécurité quel peut etre l'enjeu ?**  
🔹Ce qui est bien avec cette commande avec cette option, c'est qu'on libère officiellement l'adresse IP. Le serveur DHCP peut donc la réattribuer à une autre machine. Ce qui limite la saturation du pool d'IP.  

---

**4. Quelle fonctionnalité propose CISCO pour se prémunir des `attaques DHCP` ?**  
🔹Le ``DHCP snooping`` : Il autorise uniquement les réponses DHCP (DHCPOFFER, DHCPACK, etc.) venant de ports de confiance (trusted). Les ports non fiables (untrusted) ne peuvent pas agir comme serveurs DHCP.  

---

**5. Capturer une `requête DNS` et sa réponse**  
🔹Je lance une résolution de nom DNS sur une machine cliente du domaine :  
![alt text](<Capture d'écran 2025-11-04 095856.png>)  
Je lance une capture en filtrant avec "dns" sur mon serveur :  
![alt text](<Capture d'écran 2025-11-04 100639.png>)  

---

**6. Qu’est-ce que le `DNS Spoofing` ? Comment s’en protéger ?**  
🔹C'est une ataque par usurpation. Le but est de remplacer les adresses de serveurs DNS légitimes par de fausses adresses DNS dans le but de renvoyer l'utilisateur vers un site frauduleux. C'est généralement une attaque MITM (mais peut être une attaque de redirection).  

---

**7. Qu’est-ce que `DNSSec` ? `DNS over TLS` ou `DNS over HTTPS` ?**  
🔹`DNSSec` : Sert à assurer l’intégrité et l’authenticité des données DNS. DNSSEC ne chiffre pas les requêtes DNS.  
Il ajoute une signature numérique aux enregistrements DNS (avec des clés publiques/privées).  
Cela permet au résolveur DNS (celui qui interroge les serveurs) de vérifier que la réponse vient bien du bon serveur et n’a pas été modifiée.  
✅ Garantit l’intégrité et l’authenticité des données DNS  
❌ Ne protège pas la confidentialité (les requêtes restent visibles)  

🔹`DNS over TLS` : Sert à chiffrer la communication DNS entre le client et le résolveur.  
Utilise le protocole TLS (Transport Layer Security), le même que pour HTTPS.  
Les requêtes DNS passent par le port 853 (spécifique à DoT).  
Ainsi, personne entre vous et le résolveur (comme un FAI) ne peut voir ou modifier vos requêtes.  
✅ Protège la confidentialité et l’intégrité du canal DNS  
❌ Ne vérifie pas si la réponse est authentique (sauf si combiné avec DNSSEC)  

🔹`DNS over HTTPS` : Sert à chiffrer la communication DNS via le protocole HTTPS.  
Les requêtes DNS sont envoyées dans des requêtes HTTPS classiques (port 443).  
Cela rend le trafic DNS indiscernable du reste du trafic web, donc plus difficile à bloquer ou surveiller.  
De nombreux navigateurs (comme Firefox, Chrome, Edge) prennent en charge DoH directement.  
✅ Chiffre les requêtes DNS  
✅ Se fond dans le trafic HTTPS (difficile à filtrer)  
❌ Peut centraliser les requêtes chez un seul fournisseur (ex. Cloudflare, Google)  

---

**8. Dans quels cas trouve-t-on du DNS sur TCP ?**  
🔹DNS est généralement en UDP port 53, mais il utilise TCP port 53 lorsque les réponses dépassent 512 octets.  

---

**9. Capturer un flux `HTTP`**  
🔹![alt text](<Capture d'écran 2025-11-04 111855.png>)  

---

**10. Qu’est-ce que le `HTTP Smuggling` ? Donner un exemple de `CVE`**  
🔹C'est une technique d'attaque Web, où un attaquant injecte des requêtes HTTP malformées pour jouer sur les différences d'interprétation entre serveurs ou proxies. CVE‑2022‑26377 — Apache HTTP Server  

---

**11. Comment mettre en place la confidentialité et l'authenticité pour HTTP ?**  
🔹Il faut activer HTTPS (TLS), cela permettra de chiffrer les données entre le client et le serveur (confidentialité). Pour cela il faut installer un certificat SSL/TLS sur le serveur web. ça force toutes les connections en HTTPS.  
Il faut ensuite s'assurer que le serveur est authentique : Utiliser un certificat signé par une authorité reconnue (Let's Encrypt ou PKI interne). Le client pourra prétendre que le serveur est bien celui qu'il prétend être (Authenticité).  

---

**12.  Qu’est-ce qu’une `PKI` ?**  
🔹`Public Key Infrastructure` : Infrastructure à clés publiques. Elle inclut les politiques, les rôles, le matériel, les logiciels et les procédures nécessaires pour créer, gérer, distribuer, utiliser, stocker et révoquer les certificats numériques. Basé sur de la crypto asymétrique (clé publique/clé privée).  
Chaque entité (utilisateurs, serveurs, appareils,... ) a une clé publique et une clé privée. Le chiffrement est fait avec la clé publique connue des 2 parties et ne peut être déchiffré qu'avec la clé privée.  
La PKI permet d'assurer : identité, authenticité, intégrité, confidentialité.  

---

**13. Capturer un `mot de passe` HTTP via le projet VulnerableLightApp.**  
🔹![alt text](<Capture d'écran 2025-11-04 152328.png>)  

Je capture l'identifiant et le mot de passe de VulnerableLightApp en http (0.0.0.0:4000) depuis une machine cliente (serveur Windows).    

---

**14.   Comment mettre en place la `confidentialité` pour ce service ?**  
🔹Il faut chiffrer le canal de communication. Il faut donc passer en HTTPS (HTTP+TLS). Pour cela il faut générer un certificat (auto signé ou émis par une autorité), puis utiliser https au lieu de http.  

---

**15.   Capturer un `handshake TLS`**  
🔹

---

**16.   Qu’est-ce qu’une autorité de certification (`AC`) racine ? Qu'est qu'une `AC intermediaire` ?**  
🔹

---

**17.   Connectez-vous sur `taisen.fr` et affichez la `chaine de confiance` du certificat**  
🔹

---

**18.   Capturer une authentification `Kerberos` (mettre en place le service si nécessaire), identifier l'`AS_REQ`, `AS_REP` et les messages suivants.**  
🔹

---

**19.   Capturer une `authentification RDP` (mettre en place le service si nécessaire), quel est le protocole d'authentification capturé ?**  
🔹

---

**20.   Quelles sont les attaques connues sur `NetLM` ?**  
🔹 

---

**21.   Capturer une `authentification WinRM` (Vous pouvez utiliser EvilWinRM si nécessaire côté client.), quel est le protocole d'authentification capturé ?**  
🔹  

---

**22.   Capturer une `authentification SSH` ou SFTP (mettre en place le service si nécessaire)**  
🔹  

---

**23.   Intercepter un `fichier au travers du protocole SMB`**  
🔹  

---

**24.   Comment proteger l'`authenticité` et la `confidentialité` d'un partage SMB ?**  
🔹  

---

> [!TIP]
> Bonus : **Déchiffrer le traffic TLS** en important la clé privée du certificat dans Wireshark et **reconstituer le fichier** qui à transité sur le réseau à l'aide de Wireshark  
