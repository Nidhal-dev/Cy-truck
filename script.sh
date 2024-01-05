#!/bin/bash

echo "rentrer le chemin du fichier CSV :"

read chemin

echo "rentrer le tri voulu :"

read tri

if [ -f "/home/nidou/cy-truck/progc" ];then
echo "Le .c existe";
fi


if [ ! -f "/home/nidou/cy-truck/progc" ];then
echo "Le .c n'existe pas, compilation";
fi

if [ ! -d "/home/nidou/cy-truck/image" ];then
echo "Création de image";
mkdir /home/nidou/cy-truck/image
fi

if [ -d "/home/nidou/cy-truck/temp" ];then
echo "supression contenu de temp";
rm -r /home/nidou/cy-truck/temp
mkdir /home/nidou/cy-truck/temp
fi

if [ ! -d "/home/nidou/cy-truck/temp" ];then
echo "Création de temp";
mkdir /home/nidou/cy-truck/temp
fi

start_time=$(date +%s.%N)
awk -F ';' '!seen[$6,$1]++ { count[$6]++ } END { for (name in count) print name ";" count[name] }' data.csv | sort --parallel=8 -t';' -k2,2nr | head -n 10
end_time=$(date +%s.%N)

elapsed_time=$(echo "$end_time - $start_time" | bc)
echo "Temps écoulé : $elapsed_time secondes"
