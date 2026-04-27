# CyberChef – Cryptographie appliquée

## 4) Tâches à réaliser
### Partie 1 : Chiffrement de César
#### 1. Avec une « Box Height » de 13, chiffrer la phrase suivante : RENDEZ-VOUS À MIDI
   
##### Quel est le texte chiffré ?
ERAQRM-IBHF À ZVQV 

##### Déchiffrez ce texte pour vérifier le résultat
>RENDEZ-VOUS À MIDI

#### 2. Chiffrer le nom de votre film préféré avec une « Box Height » de votre choix
##### Transmettre le texte chiffré à votre binôme sans lui communiquer la clé
>Mf tfjhofvs eft boofbvy

##### Au sein de votre binôme, essayer de retrouver le message en sens inverse
>V pour Vendetta

## Partie 2 : Vigenère
### Encodez le nom de votre plat préféré avec la clé 'KEY'
#### Quel est le texte chiffré ?
>mnthkkdr qzldm

• Transmettre le texte chiffré à votre binôme
• Transmettre la clé à votre binôme par un autre canal
o Au sein de votre binôme, déchiffrez le message pour découvrir vos plats préférés
respectifs
Mon plat :  
>nouilles ramen

Son plat :  
![1777293315104](image/Cryptographie/1777293315104.png)


## Partie 3 : Chiffrement symétrique AES
Découverte
• Chiffrez la chaîne 'TESTSECRET1234567' avec les paramètres suivants
o Key : c34fa73d7c5f8901a23e4cd98e7f650d9a17d4e8f902fa0d3286d0beaad219b6
o IV :
o Mode : ECB
o Input : mode Raw
o Output : Hex
![1777293612693](image/Cryptographie/1777293612693.png)


• Que constatez-vous si vous modifiez 1 caractère du texte initial ?  
>Le message chiffré change complètement

• Déchiffrez le texte AES chiffré précédemment en adaptant les paramètres
>![1777293714691](image/Cryptographie/1777293714691.png)


o Vous devez retrouver le texte d'origine
### ✅ 🐱 ✅

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
![1777294799293](image/MettreenœuvredesmécanismescryptographiquesdansunSI/1777294799293.png)

Mon équipe :
>![1777295265680](image/MettreenœuvredesmécanismescryptographiquesdansunSI/1777295265680.png)


## Partie 4 : RSA

Dans « CyberChef » utilisez les recettes « Generate RSA Key Pair » « RSA Encrypt » et « RSA Decrypt »  

Génération d’une paire de clés RSA  
• Utilisez Generate RSA Key Pair avec une taille de 1024 bits  
o Que contiennent les clés générées ? (formats, longueur…)  

>-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4sfSKBC6S7bq01foHyDsaBMDb
4RNfC1nADmUFnanUTsDSJqFh8/3iHHchu6J2HYngF/dwg+MiESSAiN8NedTa8Kus
qxFGHeJU7QeLECubCr8QRYn78KcD87pXutJrtOItTGzbbUtSx28SCJuUYnME65HY
0ifXI11tJbuhoNExrQIDAQAB
>-----END PUBLIC KEY-----
>
>-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQC4sfSKBC6S7bq01foHyDsaBMDb4RNfC1nADmUFnanUTsDSJqFh
8/3iHHchu6J2HYngF/dwg+MiESSAiN8NedTa8KusqxFGHeJU7QeLECubCr8QRYn7
8KcD87pXutJrtOItTGzbbUtSx28SCJuUYnME65HY0ifXI11tJbuhoNExrQIDAQAB
AoGAK+LZJPxmZrJHZZXcogHBjWaovvaF6FUln92rwoBarOCDr8vPGBvmbVZvNlxD
98YAD3gSazFjhKJHJqWfPq/+1Bmy2E1QbIfjrdy1PAe4qrR8QtiHVNc6rIKGCJeX
+7ROP02OV3Gx2HrN8ZenSQ9DGUKCJBEnwBi2v0dk4qXC1/8CQQDqECSEG5hrR9v5
VBedLzn1tf6SYhcIJhv3p6UiKG2TwNrbbeFX0SrPzBh8uhnF/CHGOZ+QaeGhEjq/
zDkndlfvAkEAygFU8PxnmpUNNggeCjLtAqxhGLkFmtgnTBDOI2CHcQzgyKOwl3lQ
mkeKnOOhBUt4jVdCvt9NR1QqIpjtxwOUIwJBAMi2dQnQPCDq6yhgQyuoHtSkbxwJ
/2QegecaHJIxBt4oB8UY8Z8Dn+m3Q9xZHdbYQgIg0cLd+PzNjBGCyBQd+IMCQF5P
/N5+mch8aqydYZkVab7jyHmIeOtwm/hRqEywFsxbXN+QPTSbeVxupnLVfCpCsEgd
Q5ZmH2h8DSgWCn3uV80CQQCiYcceS9dMPI3e2mjh/gzxBsNx3kfT+A5Wk9UPJNlR
V38uMbS4K3cdhjGOY72xZqbOCZzNM937LPzpMQykVPt3
>-----END RSA PRIVATE KEY-----

>Longueur : 1024 bits  
>Format : PEM  


Découverte  
• Chiffrez le message suivant avec votre clé publique : LE MESSAGE EST SECRETSIMPLE  
o Quelle est la sortie chiffrée ?  
>![1777296376482](image/MettreenœuvredesmécanismescryptographiquesdansunSI/1777296376482.png)

• Utilisez votre clé privée pour déchiffrer le message
o La sortie est-elle identique au message d’origine ?  
>Oui
>![1777296153963](image/MettreenœuvredesmécanismescryptographiquesdansunSI/1777296153963.png)

Transmission d’un message chiffré à votre binôme  
• Récupérez la clé publique de votre binôme  
• Chiffrez votre réplique préférée avec les paramètres suivants  
o Key : « la clé publique de votre binôme»  
o Encryption scheme : RSA-OAEP  
o Message Digest Algorithm : SHA-1  
• Transmettre le texte chiffré à votre binôme  

>![1777297741601](image/MettreenœuvredesmécanismescryptographiquesdansunSI/1777297741601.png)

o Votre binôme, doit déchiffrer le message à l’aide de sa clé privée pour découvrir votre réplique préférée
o Inversez ensuite les rôles pour que chacun connaisse la réplique privée de son binôme  

>![1777297763392](image/MettreenœuvredesmécanismescryptographiquesdansunSI/1777297763392.png)


## Partie 5 : Hachage
• Utilisez différents algorithmes de hachage sur la chaîne ADMIN123
o SHA-1
o SHA-2 : 256, 512
o SHA-3 : 256, 512
• Quelles sont les tailles des hashs produits ?
o Est-il possible de retrouver le mot de passe à partir du hash ?
o Essayez deux textes légèrement différents (TEST et TESt)
 Que constatez-vous dans les résultats des hashs ?
• Hacher le texte « hello » en SHA1 (80 rounds)
o Crackez le hash sur https://crackstation.net/
 Le hash est cracké en quelques secondes, comment cela est-ce possible ?
• Répéter le point précédent avec SHA1 (50 rounds)
 Le hash est-il cracké ? Pourquoi ?