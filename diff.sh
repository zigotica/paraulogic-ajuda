#!/usr/bin/env bash

# ./filter.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

source ./lletres.sh
ordena $1

if ! [ -s "results/$combo-filtrades.txt" ];then
  echo "L'arxiu de solucions no existeix, cal executar './run.sh $combo' abans de veure les diferències entre el diccionari filtrat i complet."
  exit
fi

# El llistat de diferències es construeix amb
# els resultats de l'arxiu de solucions total,
# excloent totes les paraules de l'arxiu de solucions filtrades
filtrades=$(cat results/$combo-filtrades.txt | tr '\n' ' ')
trobades_arr=($filtrades)
llarg=${#trobades_arr[@]}

excloses="! /^${trobades_arr[0]}$/"
for (( index=1; index<llarg; index++ )); do
  excloses+=" && ! /^${trobades_arr[index]}$/"
done

cat results/$combo-totes.txt \
  | gawk "$excloses"

