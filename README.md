# Cy-truck
# Lisez-moi !

Ce code a été conçu par Abdelah SAIDJ, Ahmed AISSAOUI et Nidhal OUARDANI.
Ce code permet d'effectuer divers traitements sur des données provenant d'un fichier CSV en fonction des options spécifiées par l'utilisateur. Il offre plusieurs fonctionnalités, notamment la copie du fichier de données, l'analyse statistique, la génération de visualisations, et l'exécution de programmes C spécifiques.

## Prérequis

Avant d'exécuter le script, assurez-vous que votre système remplit les conditions suivantes :

- télécharger le fichier zip du code :
  Cliquez sur le bouton code et télécharger zip

- Bash est installé :
  sudo apt-get -y install bash
  
- gcc est installé :
  sudo apt install build-essential
  
- make est installé :
  sudo apt install make
  
- awk est installé :
  sudo apt-get install gawk
  
- Gnuplot est installé pour générer des graphiques :
  sudo apt install gnuplot
  
- vous avez un fichier data.csv

## Utilisation

Pour exécuter le script, utilisez les commande suivante :

chmod 700 script.sh

./script.sh  /chemin/du/fichier/data.csv [OPTIONS]

```bash
## Options disponibles
-h ou -H: Affiche les options utilisables
-d1 ou -D1: Les conducteurs avec le plus de trajets
-d2 ou -D2:  Les conducteurs avec leur plus grande distance parcouru
-l ou -L:  Les 10 trajets les plus longs
-t ou -T:  Les 10 villes les plus traversées
-s ou -S: Statistiques sur les étapes
