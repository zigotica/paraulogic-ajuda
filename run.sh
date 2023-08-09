#!/usr/bin/env bash

# ./run.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

source ./lletres.sh
ordena $1

# Generem llistat de lletres excloses a partir de les lletres base i vocals accentuades
# Això ens permetrà obtenir paraules amb accents més endavant
straccented=$(echo $str | sed "s/a/$as/g" | sed "s/e/$es/g" | sed "s/i/$is/g" | sed "s/o/$os/g" | sed "s/u/$us/g")
excloses=$(echo "${as}bcçd${es}fgh${is}jklmn${os}pqrst${us}vwxyz" | sed "s/[$straccented]//g")
strlen=${#str}

echo "MESTRA: $mestra RESTA: $restaordenada EXCLOSES: $excloses"

# Si la mestra és una vocal, volem els seus accents per la futura expresió regular
accentmestra=$(echo ${mestra}s)
if [[ $mestra =~ [aeiou] ]]; then
  mestra="${!accentmestra}"
else
  mestra="${mestra}"
fi

# Genera l'arxiu de solucions filtrades per la combinació del dia
gawk "/[$mestra]/" parsed/filtrades.txt \
  | gawk "! /[$excloses]/" \
  > results/$combo-filtrades.txt

# Genera l'arxiu de solucions (totes) per la combinació del dia
gawk "/[$mestra]/" parsed/totes.txt \
  | gawk "! /[$excloses]/" \
  > results/$combo-totes.txt

# Generem el llistat d'expresions regulars per trobar els Tutis
# Un tuti no ha d'incloure cap lletra exclosa, però sí totes
# les lletres que passem via paràmetre
# Poden incloure vocals accentuades, encara que no les haguem passat
tutis="! /[$excloses]/"
for (( index=0; index<strlen; index++ )); do
  letter=${str:index:1}
  accents=$(echo ${letter}s)
  if [[ $letter =~ [aeiou] ]]; then
    tutis+=" && /[${!accents}]/"
  else
    tutis+=" && /${str:index:1}/"
  fi
done

# Genera l'arxiu de tutis per la combinació del dia
gawk "$tutis" parsed/filtrades.txt \
  > results/$combo-tutis.txt

# Mostra per pantalla informació agregada dels arxius generats
red=$(cat results/$combo-filtrades.txt | wc -l | xargs)
dic=$(cat results/$combo-totes.txt | wc -l | xargs)
tut=$(cat results/$combo-tutis.txt | wc -l | xargs)

echo "${red} FILTRADES DE LA LLISTA REDUÏDA results/$combo-filtrades.txt"
echo "${dic} FILTRADES DEL DICCIONARI COMPLET results/$combo-totes.txt"
echo "${tut} POSSIBLES TUTIS results/$combo-tutis.txt"
