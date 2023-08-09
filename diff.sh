#!/usr/bin/env bash

# ./filter.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

source ./lletres.sh
ordena $1

if ! [ -s "results/$combo-filtrades.txt" ];then
  echo "L'arxiu de solucions no existeix, cal executar './run.sh $combo' abans de veure les diferències entre el diccionari filtrat i complet."
  exit
fi

# El llistat de diferències es construeix
# juntant els arxius de solucions del dia
# (el total i el filtrat sense variacions gramaticals i conjugacions de verbs)
# ordentant les línies
# quedant-nos amb les paraules que no estan repetides
cat results/$combo-filtrades.txt results/$combo-totes.txt \
  | sort \
  | uniq -i -u

