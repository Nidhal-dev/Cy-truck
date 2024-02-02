#!/bin/bash

# Vérifiez s'il y a au moins un argument
if [ $# -eq 0 ]; then
    echo -e "Aucun arguments\n"
    exit 1
fi

#vérifie si un traitement a été choisi
if [ $# -eq 1 ]; then
    echo -e "Choisissez un traitement\n"
    exit 1
fi


# Récupère le chemin passé en argument
chemin=$1

# Vérifie si le chemin existe
if [ -e "$chemin" ]; then
    # Vérifie si le chemin est un fichier
    if [ -f "$chemin" ]; then
        # Vérifie si le fichier s'appelle "data.csv"
        if [ "$(basename "$chemin")" = "data.csv" ]; then
            echo -e "Le chemin passé est valide et mène au fichier data.csv.\n"
        else
            echo -e "Le chemin existe mais ne mène pas au fichier data.csv.\n"
            exit 0
        fi
    else
        echo -e "Le chemin existe mais n'est pas un fichier.\n"
        exit 0
    fi
else
    echo -e "Le chemin n'existe pas.\n"
    exit 0
fi

# Vérifiez si l'option d'aide est spécifiée
for arg in "$@"; do
    if [ "$arg" == "-h" ] || [ "$arg" == "-H" ]; then
        echo -e "Voici les options utilisable :\n-d1 les conducteurs avec le plus de trajets\n-d2 les conducteurs et leur plus grande distance parcourue\n-l les 10 trajets les plus longs\n-t les 10 villes les plus traversées\n-s statistiques sur les étapes\n"
        exit 0
    fi
done

#vérifie l'existence du dossier data
if [ ! -d "data" ];then
	echo -e "Le dossier /data n'existe pas :\nCréation de data...\n"
	mkdir data
else
	echo -e "Le dossier /data existe\n"
fi


#copie le fichier data.csv depuis le chemin mis en argument
if [ "$chemin" = "data/data.csv" ]; then
	echo -e "data.csv est déja dans le dossier /data\n"
else	 
	echo -e "Copie du fichier data.csv dans le dossier data...\n"
	# Récupère le premier argument séparément
	first_arg=$1
	cp "$first_arg" "data"
fi

#vérifications pour les fichiers temp et images
if [ ! -d "images" ];then
	echo -e "Le dossier /images n'existe pas :\nCréation de images...\n";
	mkdir images
else
	echo -e "Le dossier /images existe\n"
fi

if [ ! -d "temp" ];then
	echo -e "Le dossier /temp n'existe pas :\nCréation de temp...\n";
	mkdir temp
else
	echo -e "Le dossier /temp existe\n"
fi

if [ -d "temp" ];then
	echo -e "Supression des fichiers temporaire...\n";
	rm -r temp
	mkdir temp
fi

#vérifie l'existence du dossier demo et le crée si pas existant
if [ ! -d "demo" ];then
	echo -e "Le dossier /demo n'existe pas :\nCréation de demo...\n"
	mkdir demo
else
	echo -e "Le dossier /demo existe\n"
fi

#déplace les anciens résultats dans le dossier demo
if [ -z "$(ls -A images)" ]; then
	echo -e "le dossier /images est vide aucune action requise\n"
else
	echo -e "Déplacement des résultats précédent dans /demo...\n"
	cd images
	mv * ../demo
	cd ..
fi


read -p "Appuyez sur une touche pour continuer..."
clear

#parcour les arguments et effctue les traitements
for arg in "${@:2}"; do
	if [[ "$arg" != "-d1" && "$arg" != "-D1" && "$arg" != "-d2" && "$arg" != "-D2" && "$arg" != "-l" && "$arg" != "-L" && "$arg" != "-t" && "$arg" != "-T" && "$arg" != "-s" && "$arg" != "-S" ]]; then
        echo -e "Erreur : l'argument '$arg' n'est pas valide. Veuillez utiliser -d1 -D1 -d2 -D2 -l -L -t -T -s -S\n"
        exit 1
    fi
    echo -e "\nArgument: $arg"

    #traitement d1
    if [ "$arg" == "-d1" ] || [ "$arg" == "-D1" ]; then
    	
    	
    	start_time=$(date +%s)
	awk -F ';' '!seen[$6,$1]++ { count[$6]++ } END { for (name in count) print name ";" count[name] }' data/data.csv | sort -t ';' -k2,2nr | head -n 10 > temp/tempd1.txt
	cat temp/tempd1.txt
	end_time=$(date +%s)
	elapsed_time=$(echo "$end_time - $start_time" | bc)
	echo "Temps écoulé : $elapsed_time secondes"
	# Commande Gnuplot
            gnuplot << EOF
            #Définition du style de sortie avec rotation
            set terminal pngcairo enhanced font 'arial,15' size 1100,1000
            set output 'images/Traitement1.png'
            
            #Séparateur pour le using
            set datafile separator ";"
            
            #Titre du graphique
            set ylabel 'Option -d1 : Nb routes = f(Driver)'
            
            #Style de la barre
            set style data histogram
            set style fill solid border -1
            
            #Enlever la légende
            unset key
            
            #Ajustement de la largeur des colonnes et positionnement à gauche
            set style histogram cluster gap 1
            set boxwidth 1.6
            
            #Axe X
            set xlabel 'DRIVER NAMES' rotate by 180
            set y2label 'NB ROUTES'
            
            #Ajustement des xtics
            set xtics rotate
            set y2range [0:250]
            
            #Ajustement des y2tics
            set y2tics rotate
            unset ytics;set y2tics mirror
            
            #Charger les données depuis le fichier temporaire
            plot 'temp/tempd1.txt' using 2:xticlabels(1) axes x1y2 notitle linecolor 2 lt 1
EOF
            convert -rotate 90 images/Traitement1.png images/Traitement1.png
            
            
            # Ouvrir l'image
            xdg-open "images/Traitement1.png"
            
    #traitement d2
    elif [ "$arg" == "-d2" ] || [ "$arg" == "-D2" ]; then
    	
    	start_time=$(date +%s)
        awk -F ';' '
	{
    		driver = $6;  # Colonne du conducteur
    		distance = $5;  # Colonne de la distance

    		if (driver != "" && distance != "") {
        		sum[driver] += distance;
    		}
	}
	END {
    		for (driver in sum) {
        		printf "%s;%.d\n", driver, sum[driver];
    		}
	}' data/data.csv | sort -t';' -k2,2nr | head -n 10 > temp/tempd2.txt
	cat temp/tempd2.txt
        end_time=$(date +%s)
	elapsed_time=$(echo "$end_time - $start_time" | bc)
	echo "Temps écoulé : $elapsed_time secondes"
	
	    gnuplot << EOF
            #Définition du style de sortie avec rotation
            set terminal pngcairo enhanced font 'arial,15' size 1100,1000
            set output 'images/Traitement2.png'
            
            #Séparateur pour le using
            set datafile separator ";"
            
            #Titre du graphique
            set ylabel 'Option -d2 : Distance = f(Driver)'
            
            #Style de la barre
            set style data histogram
            set style fill solid border -1
            
            #Enlever la légende
            unset key
            
            #Ajustement de la largeur des colonnes et positionnement à gauche
            set style histogram cluster gap 1
            set boxwidth 1.6
            
            #Axe X
            set xlabel 'DISTANCE (Km)' rotate by 180
            set y2label 'DRIVER NAMES'
            
            #Ajustement des xtics
            set xtics rotate
            set y2range [0:160000]
            
            #Ajustement des y2tics
            set y2tics rotate
            unset ytics;set y2tics mirror
            
            #Charger les données depuis le fichier temporaire
            plot 'temp/tempd2.txt' using 2:xticlabels(1) axes x1y2 notitle linecolor 2 lt 1
EOF
            convert -rotate 90 images/Traitement2.png images/Traitement2.png
            
            
            # Ouvrir l'image
            xdg-open "images/Traitement2.png"
            
    #traitement l        
    elif [ "$arg" == "-l" ] || [ "$arg" == "-L" ]; then
        
        start_time=$(date +%s)
	   awk -F ';' '{
    		trajet = $1;  # Colonne du trajet
    		distance = $5;  # Colonne de la distance

    		if (trajet != "" && distance != "") {
        		sum[trajet] += distance;
    		}
	}
	END {
    		for (trajet in sum) {
        		printf "%d;%d\n", trajet, sum[trajet];
    		}
	}' data/data.csv | sort -t';' -k2,2nr | head -n 10 | sort -t';' -k1,1nr > temp/templ.txt
	cat temp/templ.txt
	end_time=$(date +%s)
	elapsed_time=$(echo "$end_time - $start_time" | bc)
	echo "Temps écoulé : $elapsed_time secondes"
        
        # Commande Gnuplot
            gnuplot <<EOF
            # Police du graphique
            set terminal pngcairo enhanced font 'Verdana,12'
            # Fichier de sortie du gnuplot
            set output 'images/Traitementl.png'
            # Le plot sera un histogramme
            set style data histograms
            # Remplissage
            set style fill solid border -1
            # Largeur des cases
            set boxwidth 0.8
            # Titre du graphique
            set title 'Option -l : Distance = f(Trajet)'
            # Axe des x horizontal
            set xlabel 'Numéro identifiant de trajet'
            # Axe des y vertical
            set ylabel 'Distance en km'
            # Utiliser ';' comme séparateur
            set datafile separator ';'
            # Définir l'intervalle de l'axe des y et l'incrément des graduations
            set yrange [0:3000]
            set ytics 500
            # Rotation des étiquettes de l'axe des x
            set xtics rotate by -45
            # Plotting the top 10 data without legend
            plot '< head -n 10 temp/templ.txt' using 2:xtic(1) notitle with boxes
EOF
            # Ouvrir l'image
            xdg-open "images/Traitementl.png"
 
    #traitement t
    elif [ "$arg" == "-t" ] || [ "$arg" == "-T" ]; then
     	
     	if [ -e "progc/progt" ]; then
       		echo -e "L'exécutable C du traitement t est déja existant\n"
        else
       		echo -e "Pas de premier exécutable C\n"
       		echo -e "compilation...\n"
       		cd progc
            	make progt
            	cd ..
        fi
        
        start_time=$(date +%s)

        ./progc/progt data/data.csv > temp/finaltemp_t.csv
        cat temp/finaltemp_t.csv
           
        end_time=$(date +%s)
elapsed_time=$(echo "$end_time - $start_time" | bc)
echo "Temps écoulé : $elapsed_time secondes"
gnuplot << EOF
set term pngcairo enhanced size 1200,1000
set output "images/Traitement_t.png"
set encoding utf8
set margins 10, 10, 7, 5
set yrange [-10:3500]
set ytics 1000

set style data histogram
set style histogram cluster gap 4
set style fill transparent solid 1
set boxwidth 3
set grid ytics
set xtics rotate by 45 center font ",12" right
set title "Option -t : Nb routes = f(Towns)" font ",20"
set ylabel "NB ROUTES" font ",15"
set xlabel "TOWN NAMES" font ",15" offset 0,-1
set datafile separator ";"
plot "temp/finaltemp_t.csv" using 2:xtic(1) lc "#00ffff" t "Total routes" , '' using 3 lc "#000fff" t "First town"

set output
EOF
xdg-open "images/Traitement_t.png"
	cd progc
        make clean
        cd ..

    #traitement s
    elif [ "$arg" == "-s" ] || [ "$arg" == "-S" ]; then
       
       if [ -e "progc/progs" ]; then
       		echo -e "L'exécutable C du traitement s est déja existant\n"
       else
       		echo -e "Pas d'exécutable C\n"
       		echo -e "compilation...\n"
       		cd progc
            	make progs
            	cd ..
       fi
       
       start_time=$(date +%s)
       cut -d';' -f1,2,5 "data/data.csv" >> temp/firsttemp.csv
       tail -n +2 temp/firsttemp.csv > temp/secondtemp.csv
       echo "Les statistiques sur les étapes sont : "
            
       ./progc/progs temp/secondtemp.csv

       # Récupérer les 50 premiers 
       head -n 50 temp/output.csv >> temp/finaltemp.csv
       echo "Les 50 premiers sont : "
       # route_id, min, max, moy, diff
       cat temp/finaltemp.csv
       end_time=$(date +%s)
       elapsed_time=$(echo "$end_time - $start_time" | bc)
       echo "Temps écoulé : $elapsed_time secondes"
       
       gnuplot << EOF
set terminal png font "arial,10"
  set output "images/s.png"
  set title "Option -s"
  set style data lines
  set style fill solid 0.5
  set datafile separator ";"
  set xrange [1:*]
  set xtic rotate by 45 right
  set xlabel "ID"
  set ylabel "Distance" rotate by -270
  set title "Option -s "
  plot "temp/finaltemp.csv" using 0:2:3:xtic(2) with filledcurves below title "Distance Min/Max" lc rgb "blue", '' u 0:4 lc rgb "blue" title "Distance Moy"
EOF

    xdg-open "images/s.png"
       
       cd progc
       make clean
       cd ..
       rm temp/output.csv temp/firsttemp.csv temp/secondtemp.csv temp/finaltemp.csv
    fi
done

#"$(realpath data/data.csv)"

