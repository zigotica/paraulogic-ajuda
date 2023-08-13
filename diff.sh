#!/usr/bin/env bash

# ./filter.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

source ./utils.sh
ordena_lletres_dia $1

if ! [ -s "results/$combo-filtrades.txt" ];then
  err "L'arxiu de solucions no existeix, cal executar './run.sh $combo' abans de veure les diferències entre el diccionari filtrat i complet."
fi

echo -ne "\n${YEL}Calculant diferències...${RST}\n"

# El llistat de diferències es construeix
# juntant els arxius de solucions del dia
# (el total i el filtrat sense variacions gramaticals i conjugacions de verbs)
# ordentant les línies
# quedant-nos amb les paraules que no estan repetides
resultats=$(cat results/$combo-filtrades.txt results/$combo-totes.txt \
  | sort \
  | uniq -i -u)

if [ "$resultats" ]; then
  count=$(echo $resultats | wc -w | xargs)
  echo -ne "\n${GRN}Resultats... ($count)${RST} \n"
  echo $resultats
else
  echo -ne "\n${RED}No hi ha resultats${RST}"
fi
