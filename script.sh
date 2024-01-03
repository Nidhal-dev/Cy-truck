#!/bin/bash

echo "rentrer le chemin du fichier CSV :"

read chemin

echo "rentrer le tri voulu :"

read tri

if [ -f "/home/nidou/cy-truck/progc/prog.c" ];then
echo "Le .c existe";
fi


if [ ! -f "/home/nidou/cy-truck/progc/prog.c" ];then
echo "Le .c n'existe pas, compilation";
fi


if [ -f "/home/nidou/cy-truck/progc/prog.c" ];then
echo "Le .c existe";
fi

if [ ! -d "/home/nidou/cy-truck/image" ];then
echo "Création de image";
mkdir /home/cy-truck/image
fi

if [ -d "/home/nidou/cy-truck/temp" ];then
echo "supression contenu de temp";
rm -r /home/cy-truck/temp
mkdir /home/cy-truck/temp
fi

if [ ! -d "/home/nidou/cy-truck/temp" ];then
echo "Création de temp";
mkdir /home/cy-truck/temp
fi

awk -F';' -f 'data.csv' " print $6" test.txt
