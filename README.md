# Cy-truck
# Lisez-moi !

Ce code a été conçu par Abdelah SAIDJ, Ahmed AISSAOUI et Nidhal OUARDANI.
Ce code permet d'effectuer divers traitements sur des données provenant d'un fichier CSV en fonction des options spécifiées par l'utilisateur. Il offre plusieurs fonctionnalités, notamment la copie du fichier de données, l'analyse statistique, la génération de visualisations, et l'exécution de programmes C spécifiques.

## Prérequis

Avant d'exécuter le script, assurez-vous que votre système remplit les conditions suivantes :

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
-d1 ou -D1: Effectue le traitement 1 et génère une visualisation.
-d2 ou -D2: Effectue le traitement 2 et génère une visualisation.
-l ou -L: Effectue le traitement "l" et génère une visualisation.
-t ou -T: Compile et exécute le programme C "progt".
-s ou -S: Compile et exécute le programme C "progs", avec des traitements spécifiques.
