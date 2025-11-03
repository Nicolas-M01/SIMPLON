
## Contexte

Il vous est demandé de procéder à l'analyse des protocoles utilisés sur le réseau et de détecter d'éventuelles faiblesses.

à partir du Lab installé, ajouter les services nécessaires et répondre aux questions suivantes

### Rappels

* Quelle est votre adresse IP ? Quelle est sa classe (IPv4) ?  
🔹 
* Quel est votre masque de sous-réseau ?
🔹
* Quelle est l'adresse de votre passerelle ?
🔹

### Questions

0. Quels sont les `flags TCP` ?  
🔹
1. Capturer le processus `DORA` du protocole DHCP
🔹
2. qu’est ce que le `DHCP Starvation` / `snooping` ? `Rogue DHCP` ?
🔹
3. Que ce passe-t-il lors de l'execution de la commande `ipconfig /release` (windows) ? D’un point de vue sécurité quel peut etre l'enjeu ?
🔹
4. Quelle fonctionnalité propose CISCO pour se prémunir des `attaques DHCP` ?
🔹
5. Capturer une `requête DNS` et sa réponse
🔹
6. Qu’est-ce que le `DNS Spoofing` ? Comment s’en protéger ?
🔹
7. Qu’est-ce que `DNSSec` ? `DNS over TLS` ou `DNS over HTTPS` ?
🔹
8. Dans quels cas trouve-t-on du DNS sur TCP ?
🔹
9. Capturer un flux `HTTP`
🔹
10. Qu’est-ce que le `HTTP Smuggling` ? Donner un exemple de `CVE`
🔹
11. Comment mettre en place la confidentialité et l'authenticité pour HTTP ?
🔹
12. Qu’est-ce qu’une `PKI` ?
🔹
13. Capturer un `mot de passe` HTTP via le projet VulnerableLightApp.
🔹
14. Comment mettre en place la `confidentialité` pour ce service ?
🔹
15. Capturer un `handshake TLS`
🔹
16. Qu’est-ce qu’une autorité de certification (`AC`) racine ? Qu'est qu'une `AC intermediaire` ?
🔹
17. Connectez-vous sur `taisen.fr` et affichez la `chaine de confiance` du certificat
🔹
18. Capturer une authentification `Kerberos` (mettre en place le service si nécessaire), identifier l'`AS_REQ`, `AS_REP` et les messages suivants.
🔹
19. Capturer une `authentification RDP` (mettre en place le service si nécessaire), quel est le protocole d'authentification capturé ?
🔹
20. Quelles sont les attaques connues sur `NetLM` ?
🔹
21. Capturer une `authentification WinRM` (Vous pouvez utiliser EvilWinRM si nécessaire côté client.), quel est le protocole d'authentification capturé ?
🔹
22. Capturer une `authentification SSH` ou SFTP (mettre en place le service si nécessaire)
🔹
23. Intercepter un `fichier au travers du protocole SMB`
🔹
24. Comment proteger l'`authenticité` et la `confidentialité` d'un partage SMB ?
🔹
> [!TIP]
> Bonus : **Déchiffrer le traffic TLS** en important la clé privée du certificat dans Wireshark et **reconstituer le fichier** qui à transité sur le réseau à l'aide de Wireshark
