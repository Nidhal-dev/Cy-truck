# Cy-truck
# Lisez-moi pour votre script Bash

Ce script Bash est conçu pour effectuer divers traitements sur des données provenant d'un fichier CSV en fonction des options spécifiées par l'utilisateur. Il offre plusieurs fonctionnalités, notamment la copie du fichier de données, l'analyse statistique, la génération de visualisations, et l'exécution de programmes C spécifiques.

## Prérequis

Avant d'exécuter le script, assurez-vous que votre système remplit les conditions suivantes :

- Bash est installé.
- gcc est installé
- make est installé
- Gnuplot est installé pour générer des graphiques.
- Le dossier 'data' existe et contient le fichier CSV d'entrée ('data.csv').
- Les dossiers 'images', 'temp', 'demo' et 'progc' existent ou seront créés par le script.

## Utilisation

Pour exécuter le script, utilisez les commande suivante :

chmod 700 script.sh
./script.sh  /chemin/du/fichier/data.csv [OPTIONS]
```bash
## Options disponibles
-h ou -H: Affiche l'aide et les options utilisables
-d1 ou -D1: Effectue le traitement 1 et génère une visualisation.
-d2 ou -D2: Effectue le traitement 2 et génère une visualisation.
-l ou -L: Effectue le traitement "l" et génère une visualisation.
-t ou -T: Compile et exécute le programme C "progt".
-s ou -S: Compile et exécute le programme C "progs", avec des traitements spécifiques.
