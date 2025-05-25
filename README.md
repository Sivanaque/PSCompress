# PSCompress

Lui aussi réalisé dans le cadre de mon alternacne, ce script PowerShell a été réalisé pour pouvoir examiner les métadonnées sur des vidéos à compresser par la suite, dans un débit vidéo et une résolution optimale aux solutions de mon entreprise grâce aux logiciels d'`ffmpeg` et la technologie XAML pour l'interface utilisateur.

## Fonctionnalités

- **Sélection de fichiers vidéo** : Permet aux utilisateurs de parcourir et sélectionner un fichier vidéo via un `OpenFileDialog`.
- **Extraction des métadonnées** :
  - Résolution (largeur x hauteur)
  - Ratio d’affichage
  - Débit binaire
  - Détection du format Portrait/Paysage
- **Compression du fichier vidéo** :
  - Utilisation de `ffmpeg` pour encoder la vidéo en H.264
  - Définition du débit binaire et du taux d’images par seconde (24 fps)
  - Maintien du ratio d’affichage si disponible en 9/16 pour les médias portraits, 16/9 pour les paysages
- **Exportation du fichier compressé** 

## Utilisation
Pour l'exécution du script PowerShell, autoriser son exécution de script au sein de votre infrastrcutre AD ou votre machine, puis cliquer sur NI.ps1

Une fois lancée, vous n'avez plus qu'à sélectionner votre vidéo via `Browse Media`, après quelques secondes de traitement, les métadonnées de votre média seront présentes. Cliquer sur Export Media pour sélectionner votre chemin de destination et lancer la compression. À la fin de cette dernière, vous aurez les nouvelles métadonnées de la vidéo compressée.

FFmpeg est configuré dans l'enceinte de ce script pour fixer une vidéo à une fréquence d'image par seconde de 24, une résolution HD ou Full HD, et un débit maximum de 6 000 kbit/s pour leurs optimisations sur des affichages dynamiques et réduire leurs tailles.

## Prérequis

⚠ Assurez-vous d'avoir Powershell 5.1 ou 7 d'installé sur votre ordinateur
Les instances FFmpeg sont inclus au sein de ce repertoire (présents dans le dossier *bin)
