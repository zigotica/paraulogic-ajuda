#!/usr/bin/env bash

str=$(echo "$1" | awk '{print tolower($0)}')
mestra=${str:0:1}
resta=${str:1}
excloses=$(echo "abcçdefghijklmnopqrstuvwxyz" | sed "s/[$str]//g")

echo "MESTRA: $mestra RESTA: $resta EXCLOSES: $excloses"

awk "/$mestra/" parsed/filtrades.txt \
  | awk "! /[$excloses]/" \
  > results/$str-filtrades.txt

awk "/$mestra/" parsed/totes.txt \
  | awk "! /[$excloses]/" \
  > results/$str-totes.txt

red=$(cat results/$str-filtrades.txt | wc -l | xargs)
dic=$(cat results/$str-totes.txt | wc -l | xargs)

echo "${red} FILTRADES DE LA LLISTA REDUÏDA results/$str-filtrades.txt"
echo "${dic} FILTRADES DEL DICCIONARI COMPLET results/$str-totes.txt"
