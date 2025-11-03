# Prairie.ps1


# 1) Vérifiez à l'aide d'un langage de script si vous avez les KB5049622, KB5049625 et Un KB présent de votre choix présent sur votre OS Windows. Le script devra afficher en Vert les KB présents et en rouge les KB absents.


# Liste des KB à vérifier (soit par un tableau, soit pas un fichier texte.)
# $KBincluded = @("KB5049622", "KB5049625", "KB5067360") # On crée un tableau contenant les variables à chercher


# 2) Une fois que votre script fonctionne, placer la liste des KB dans un fichier texte nommé kb_list.txt, le script devra lire ce fichier pour obtenir la liste des KB.
$KBincluded = Get-Content "C:\Users\maert\Documents\kb_list.txt" 

# Rentre dans une variable les KB installés sur mon PC
$KB = Get-HotFix

# On parcourt chaque KB de mon tableau pour vérifier.
foreach ( $a in $KBincluded) {
    
    # On teste si le KB est dans la liste, si oui affiche en vert, si non affiche en rouge    
    if ( $a -in $KB.HotfixID ) {        
        Write-Host "$a" -ForegroundColor Green
    }
    else {        
        Write-Host "$a" -ForegroundColor Red
    }
}


<# 3) Proposer une procédure, à écrire en commentaire du script, pour appliquer ce script sur un parc Windows AD.
Une méthode courante et centralisée est de déployer par GPO.
* Il faut placer le script dans un dossier partagé : chemin en UNC et path en DNS/FQDN pour une authentification Kerberos (pas d'IP, sinon on bascule sur NTLM), ex : \\SRV_FILE.domain.local\NETLOGON\Scripts\Chack_KB.ps1
* Dans la gestion des stratégies de groupe, il faut créer une GPO, le chemin est : Configuration de l'ordinateur>Stratégies>Paramètres Windows>Scripts (démarrage/arrêt),
  cliquer sur "Démarrage", "Ajouter", "Parcourir", puis indiquer le chemin du script, valider et le script est prêt au déployement. Cette méthode permet de lancer un script une fois au démarrage du PC (gpupdate ne marcehra pas)
#>






<# 4) Générer un certificat autosigné
Certificat autosigné rentré dans une variable, le nom sera : Script_KB_PowerShell, valable 5 ans, enregistré dans le magasin personnel de la machine
$SelfSignedCert = New-SelfSignedCertificate -Subject Script_KB_PowerShell -Type CodeSigningCert -CertStoreLocation Cert:\LocalMachine\My -FriendlyName "Signer scripts KB PowerShell" -NotAfter (Get-Date).AddYears(5)


 Pour que la signature numérique soit reconnue, ou plutôt que toute la chaîne soit reconnue, nous devons ajouter ce certificat dans deux autres magasins : 
"Autorités de certification racine de confiance" et "Éditeurs approuvés". Sinon, le script ne pourra pas s'exécuter avec la politique d'exécution "AllSigned".
# Ajouter le certificat dans "Autorités de certification racine de confiance"
# Créer un objet pour représenter le magasin de certificat LocalMachine\Root
$rootStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root", "LocalMachine")
# Ouvrir le magasin en lecture et écriture 
$rootStore.Open("ReadWrite")
# Ajouter le certificat dans le magasin, grâce au contenu de la variable $SelfSignedCert
$rootStore.Add($SelfSignedCert)
# Fermer le magasin de certificats
$rootStore.Close()

# Ajouter le certificat dans "Éditeurs approuvés"
# Créer un objet pour représenter le magasin de certificat LocalMachine\TrustedPublisher
$publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("TrustedPublisher", "LocalMachine")
# Ouvrir le magasin en lecture et écriture 
$publisherStore.Open("ReadWrite")
# Ajouter le certificat dans le magasin, grâce au contenu de la variable $SelfSignedCert
$publisherStore.Add($SelfSignedCert)
# Fermer le magasin de certificats
$publisherStore.Close()

# Lister les certificats de type "CodeSigningCert"
Get-ChildItem -Path Cert:\LocalMachine\My -CodeSigningCert 

# Signer le script Powershell, on indique son emplacement et le certificat auto signé.
Set-AuthenticodeSignature -FilePath "C:\Users\maert\Documents\prairie.ps1" -Certificate $SelfSignedCert

# On vérifie qu ela signature a fonctionné
Get-AuthenticodeSignature -FilePath "C:\Users\maert\Documents\prairie.ps1"
#>









# SIG # Begin signature block
# MIIFfAYJKoZIhvcNAQcCoIIFbTCCBWkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHifYtMvIA+hU0lcmzzhzQDel
# dY+gggMSMIIDDjCCAfagAwIBAgIQeJiQmYFTCYxHE1g6qe5/BDANBgkqhkiG9w0B
# AQsFADAfMR0wGwYDVQQDDBRTY3JpcHRfS0JfUG93ZXJTaGVsbDAeFw0yNTEwMjMx
# NTAyNDNaFw0zMDEwMjMxNTEyNDNaMB8xHTAbBgNVBAMMFFNjcmlwdF9LQl9Qb3dl
# clNoZWxsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2O0PWgD2FQxJ
# ZSJcMvOSarWW81aR/HJpw7gpDbwnrmeit1bocib2q7ezU91fR0l7UXLzVH9Of5We
# h00oV1n2SRe9cp5xwvVa3lJcExKeqZcLCsW+f/V+rU7/PtlMeuymsgzd1vydTRs0
# 65vMoE2P0xgCFVUq/5MsNTsv6gmaq7X4CORMMtiHXScZQMARzNoeZTStDWg8NK6H
# VopW0n61ptDw1+N35MfPfkaqsW0IjQzQA9s1o3loWrbZaFWRClSIYoBbflWk0qQY
# TjES/Mbz1iDYAEH1bu7v50DeeZ7qRv6zK7XPqyTH/nBKgCsS0C/QaFBir8oP52K6
# 2nQQDLQLYQIDAQABo0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFPqCnsxaf6QxZ6ajSkeBhU736MUuMA0GCSqGSIb3DQEB
# CwUAA4IBAQC2BB5M2L64YFzUQm8SMCwmYG1U1dZiPRfWOhvPDVMFO/dVBkNszh+q
# irbeANVQWGvPNb5PbifhK7F603gtI7Aoy+LnPWj0N+lZN4yqrQGQRkAZv1tI93oV
# 7oTUiUJx3T6InAEWeNJdElGSRv08wKuLcm+nC7FQqw+4FN7yDZrhIxiVGJoKfvnn
# jVoBf8aWLWln52Q2ZnuevfS27vU1C8do1c6Mh7BRKKWRrVluguV0qVFx4OH2+DoD
# vEGAcxY86y9r1t0K4KlPhHSqdDhYEKwlFgpEQAQTg9TVczVJgzegRCpB/6dJTZC3
# Q86vaMRfMX8rm0i0U3IgaQNc9Xat+sKfMYIB1DCCAdACAQEwMzAfMR0wGwYDVQQD
# DBRTY3JpcHRfS0JfUG93ZXJTaGVsbAIQeJiQmYFTCYxHE1g6qe5/BDAJBgUrDgMC
# GgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG
# 9w0BCQQxFgQU8GBKnrUyTIxmXe/cxWPwl3cJ5wEwDQYJKoZIhvcNAQEBBQAEggEA
# c7/yxIA4CShHZr3O/eYxq/D41h4w3e4oheLT0Ga+vO7hF/YCa0kcRhx6vTZsZTTZ
# tkIe/YVIQsATzgXIH/TNv2KHyYla+UzTFw2e6SSD+yIzl15K8Wy1ZnKBr9QD0roM
# IrOiVQqh0Hqxfuwnx/OFpyN0Y/EccmOo14xVzgYWLOE3QnUFExNyXGkYUUeaa02a
# RLRhg6OHN+0/bW8HTo1GMTQENCRfkJfPf5xBHdJsqS2/ke+U7xZX9zSc8OWxTHTI
# 4wvsAnTqpGhZb4dfans8WDIa0RE5WRHL/k0ExOp0Kd75NG3U2zny4XYT2JYQX+C/
# IfL8yjkO2dgBpgPyqZyNqg==
# SIG # End signature block


