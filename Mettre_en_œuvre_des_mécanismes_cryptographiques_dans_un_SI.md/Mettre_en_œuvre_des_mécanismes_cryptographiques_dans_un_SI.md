# Mettre en œuvre des mécanismes cryptographiques dans un SI

---
## 💠 TP1-CyberChef 💠
---

### 4) Tâches à réaliser

### Partie 1 : Chiffrement de César

#### 1. Avec une « Box Height » de 13, chiffrer la phrase suivante : RENDEZ-VOUS À MIDI

##### Quel est le texte chiffré ?  

>ERAQRM-IBHF À ZVQV  

##### Déchiffrez ce texte pour vérifier le résultat  

> RENDEZ-VOUS À MIDI  

#### 2. Chiffrer le nom de votre film préféré avec une « Box Height » de votre choix  

##### Transmettre le texte chiffré à votre binôme sans lui communiquer la clé  

> Mf tfjhofvs eft boofbvy  

##### Au sein de votre binôme, essayer de retrouver le message en sens inverse

> V pour Vendetta

## Partie 2 : Vigenère

### Encodez le nom de votre plat préféré avec la clé 'KEY'

#### Quel est le texte chiffré ?

> mnthkkdr qzldm

• Transmettre le texte chiffré à votre binôme  
• Transmettre la clé à votre binôme par un autre canal  
o Au sein de votre binôme, déchiffrez le message pour découvrir vos plats préférés  
respectifs  

>Mon plat :  
>nouilles ramen  

Son plat :  
![alt text](<image/TP1-CyberChef/Capture d'écran 2026-04-27 143431.png>)  


## Partie 3 : Chiffrement symétrique AES

Découverte  
• Chiffrez la chaîne 'TESTSECRET1234567' avec les paramètres suivantso Key :  c34fa73d7c5f8901a23e4cd98e7f650d9a17d4e8f902fa0d3286d0beaad219b6o  
IV :  
o Mode : ECB  
o Input : mode Raw  
o Output : Hex  

• Que constatez-vous si vous modifiez 1 caractère du texte initial ?  

> Le message chiffré change complètement

• Déchiffrez le texte AES chiffré précédemment en adaptant les paramètres  

o Vous devez retrouver le texte d'origine  

### >✅ 🐱 ✅

Transmission d’un message chiffré à votre binôme  
• Générer une clé adéquate  

• Chiffrez le nom de votre équipe de sport préférée avec les paramètres suivants  
o Key : « la clé que vous avez généré »  
o IV :  
o Mode : ECB  
o Input : mode Raw  
o Output : Hex  
• Transmettre le texte chiffré à votre binôme  
• Transmettre la clé à votre binôme par un autre canal  
o Au sein de votre binôme, déchiffrez le message pour découvrir vos équipes de sport préférées respectives  

Son équipe :  
![alt text](<image/TP1-CyberChef/Capture d'écran 2026-04-27 145905.png>)  

Mon équipe :  
![1777303830411](image/TP1-CyberChef/1777303830411.png)  

## Partie 4 : RSA

Dans « CyberChef » utilisez les recettes « Generate RSA Key Pair » « RSA Encrypt » et « RSA Decrypt »

Génération d’une paire de clés RSA• Utilisez Generate RSA Key Pair avec une taille de 1024 bitso Que contiennent les clés générées ? (formats, longueur…)

> -----BEGIN PUBLIC KEY-----
> MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4sfSKBC6S7bq01foHyDsaBMDb
> 4RNfC1nADmUFnanUTsDSJqFh8/3iHHchu6J2HYngF/dwg+MiESSAiN8NedTa8Kus
> qxFGHeJU7QeLECubCr8QRYn78KcD87pXutJrtOItTGzbbUtSx28SCJuUYnME65HY
> 0ifXI11tJbuhoNExrQIDAQAB
> -----END PUBLIC KEY-----  
>
> -----BEGIN RSA PRIVATE KEY-----
> MIICXQIBAAKBgQC4sfSKBC6S7bq01foHyDsaBMDb4RNfC1nADmUFnanUTsDSJqFh
> 8/3iHHchu6J2HYngF/dwg+MiESSAiN8NedTa8KusqxFGHeJU7QeLECubCr8QRYn7
> 8KcD87pXutJrtOItTGzbbUtSx28SCJuUYnME65HY0ifXI11tJbuhoNExrQIDAQAB
> AoGAK+LZJPxmZrJHZZXcogHBjWaovvaF6FUln92rwoBarOCDr8vPGBvmbVZvNlxD
> 98YAD3gSazFjhKJHJqWfPq/+1Bmy2E1QbIfjrdy1PAe4qrR8QtiHVNc6rIKGCJeX
> +7ROP02OV3Gx2HrN8ZenSQ9DGUKCJBEnwBi2v0dk4qXC1/8CQQDqECSEG5hrR9v5
> VBedLzn1tf6SYhcIJhv3p6UiKG2TwNrbbeFX0SrPzBh8uhnF/CHGOZ+QaeGhEjq/
> zDkndlfvAkEAygFU8PxnmpUNNggeCjLtAqxhGLkFmtgnTBDOI2CHcQzgyKOwl3lQ
> mkeKnOOhBUt4jVdCvt9NR1QqIpjtxwOUIwJBAMi2dQnQPCDq6yhgQyuoHtSkbxwJ
> /2QegecaHJIxBt4oB8UY8Z8Dn+m3Q9xZHdbYQgIg0cLd+PzNjBGCyBQd+IMCQF5P
> /N5+mch8aqydYZkVab7jyHmIeOtwm/hRqEywFsxbXN+QPTSbeVxupnLVfCpCsEgd
> Q5ZmH2h8DSgWCn3uV80CQQCiYcceS9dMPI3e2mjh/gzxBsNx3kfT+A5Wk9UPJNlR
> V38uMbS4K3cdhjGOY72xZqbOCZzNM937LPzpMQykVPt3
> -----END RSA PRIVATE KEY-----  

> Longueur : 1024 bits  
> Format : PEM  

Découverte  
• Chiffrez le message suivant avec votre clé publique : LE MESSAGE EST SECRETSIMPLE  
o Quelle est la sortie chiffrée ?  
>![alt text](<image/TP1-CyberChef/Capture d'écran 2026-04-27 152548.png>)  

• Utilisez votre clé privée pour déchiffrer le message  
o La sortie est-elle identique au message d’origine ?  
🏴‍☠️
> Oui
> ![alt text](image/TP1-CyberChef/1777296153963.png)

Transmission d’un message chiffré à votre binôme• Récupérez la clé publique de votre binôme• Chiffrez votre réplique préférée avec les paramètres suivantso Key : « la clé publique de votre binôme»o Encryption scheme : RSA-OAEPo Message Digest Algorithm : SHA-1• Transmettre le texte chiffré à votre binôme  

o Votre binôme, doit déchiffrer le message à l’aide de sa clé privée pour découvrir votre réplique préféréeo Inversez ensuite les rôles pour que chacun connaisse la réplique privée de son binôme  

## Partie 5 : Hachage

• Utilisez différents algorithmes de hachage sur la chaîne ADMIN123o SHA-1  

> 93a6682a45cca19a71a8c9e3015e0c4b3a80e22c  

o SHA-2 : 256, 512  

> 256 bits  
> 5b40171489659251097e7790fc2f1892e2183a72546fe1df283d07865db9149c  

> 512 bits  
>25974977f6b51e4e8707e78281ba9b19ec54357901d51383658c57e3747d72a2fe00b3bb2e20d310cbbe1c49a0b6bb71df9f047a6253875041ea567bc85b2fcd  

o SHA-3 : 256, 512  

> 256 bits  
> 5bddba0700f67dc277fc021c256d888275f9c47f3e8d92752112ddd30edd5743

> 512 bits  
>5d224b1287f5e84fbd9d14e493a14d91179c3111de584a2937f1ec76f82d9dccec4b33dad54dca5ab905443210c2d3067b00367c304be18705d0ff6d1be0399f  

• Quelles sont les tailles des hashs produits ?  

> Réponses au dessus dans les réponses.  

o Est-il possible de retrouver le mot de passe à partir du hash ?  

> Normalement, un hashage est irréversible, on ne peut pas le déchiffrer.
> Mais on peut retrouver un mot de passe par attaque par dictionnaire (en hashant une liste de passwords), par brute force mais très long, par rainbow table (liste de mots de passes avec les hashes précalculés).

o Essayez deux textes légèrement différents (TEST et TESt) Que constatez-vous dans les résultats des hashs ?  

> Les Hashes sont complèement différents.  

• Hacher le texte « hello » en SHA1 (80 rounds)  

> aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d  

o Crackez le hash sur https://crackstation.net/ Le hash est cracké en quelques secondes, comment cela est-ce possible ?  

>![1777304464603](image/TP1-CyberChef/1777304464603.png)  
> C'est possible parce que le mot "hello" est basique et son hash est connu. Un hash est unique.  

• Répéter le point précédent avec SHA1 (50 rounds) Le hash est-il cracké ? Pourquoi ?  

> Non, parce que l'on est plus sur un format standard, donc il est non connu de la base de données.  

## 😹🏴‍☠️😹

---

## 💠 TP2-AES et RSA avec OpenSSL 💠
---

## 🔑 I. Chiffrement symétrique AES 🔑

>💡J'ai choisi de travailler sur une Debian 12 avec GUI et une carte réseau en pont.  
>Installation de Openssl
>`sudo apt install openssl`  


### A. Découverte
**Chiffrez la chaîne 'TESTSECRET1234567' avec les paramètres suivants**  
o Mode de chiffrement AES 256 bits en CBC  
o Sortie en base64  
o Ajouter un sel (salt) pour sécuriser la dérivation de clé  
o Fournir une passphrase (pour dériver la clé)  

>✅![alt text](<image/TP1-CyberChef/Capture d'écran 2026-04-28 100137.png>)

• **Quelle est la clé réelle utilisée et comment est-elle générée ?**
La clé est :  ✅**key=086BDBBF6F91282ADDB4CDF8AFBA0177CEE5E4B6B91FDC47DB70C8E7CC97F811**  
La clé fait 32 octets, 256 bits  
PBKDF2 applique HMAC-SHA256 en boucle 10000 fois sur "passphrase + salt". Le résultat est ensuite coupé en clé + IV.  

• **Déchiffrez le texte AES chiffré précédemment en adaptant les paramètres**  
o Vous devez retrouver le texte d'origine  
>✅ ![1777364105721](image/Mettre_en_œuvre_des_mécanismes_cryptographiques_dans_un_SI/1777364105721.png)  



### B. Transmission d’un message chiffré à votre binôme (passphrase)

• Chiffrez le nom de votre voiture préférée avec les paramètres suivants  
o Mode de chiffrement AES 256 bits en CBC  
o Sortie en base64   
o Ne pas ajouter de sel (salt) pour sécuriser la dérivation de clé  
o Fournir une passphrase (pour dériver la clé)  

>✅ ![1777365096933](image/Mettre_en_œuvre_des_mécanismes_cryptographiques_dans_un_SI/1777365096933.png)  


• Transmettre le texte chiffré à votre binôme  
• Transmettre la passphrase à votre binôme par un autre canal  

o Au sein de votre binôme, déchiffrez le message pour découvrir vos voitures préférées respectives  

>✅ 
>![1777365218171](image/Mettre_en_œuvre_des_mécanismes_cryptographiques_dans_un_SI/1777365218171.png)  



#### Transmission d’un message chiffré à votre binôme   
• Générez une clé de chiffrement et un vecteur d'initialisation (IV) à partir d’une passphrase sans sel  
o Notez les valeurs renvoyées  

>✅ 
>![1777365757621](image/Mettre_en_œuvre_des_mécanismes_cryptographiques_dans_un_SI/1777365757621.png)  

• Chiffrez le nom de votre chanson préférée en utilisant la clé et l’IV générés précédemment  
• Transmettre le texte chiffré à votre binôme  
• Transmettre la clé et l’IV à votre binôme par un autre canal  
>✅
>![1777367022892](image/Mettre_en_œuvre_des_mécanismes_cryptographiques_dans_un_SI/1777367022892.png)



o Au sein de votre binôme, déchiffrez le message pour découvrir votre chanson préférée respective  

> ✅
> ![1777366118344](image/Mettre_en_œuvre_des_mécanismes_cryptographiques_dans_un_SI/1777366118344.png)  

--- 

## 🔑 II. RSA  🔑  

En vous inspirant de l’exercice AES, réalisez l’équivalent avec RSA :  
### A. Génération de la paire de clés RSA  
• Générez une paire de clés RSA de 2048 bits  



### B. Chiffrement d’un message  
• Écrivez un court message (ex. : le nom de votre destination de tourisme préférée)  
• Chiffrez-le avec la clé publique de votre binôme C. Échange et déchiffrement  
• Transmettez le fichier chiffré (message_rsa.bin) à votre binôme.  
• Votre binôme doit déchiffrer le message avec sa clé privée  

## III. BONUS Utilisez le chiffrement hybride pour transmettre à votre binôme les paroles de votre chanson préférée ! 