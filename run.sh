#!/usr/bin/env bash

# ./run.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

source ./utils.sh
ordena_lletres_dia $1

# Generem llistat de lletres excloses a partir de les lletres base i vocals accentuades
# Això ens permetrà obtenir paraules amb accents més endavant
excloses=$(echo $abecedari_accentuat | sed "s/[$lletres_dia_accentuades]//g")
llargaria_lletres_dia=${#lletres_dia}

echo "MESTRA: $mestra RESTA: $resta_ordenada EXCLOSES: $excloses"

# Si la mestra és una vocal, volem els seus accents per la futura expresió regular
mestra=$(accentua_lletra $mestra)

# Genera l'arxiu de solucions filtrades per la combinació del dia
gawk "/[$mestra]/" parsed/filtrades.txt \
  | gawk "! /[$excloses]/" \
  > results/$combo-filtrades.txt

# Genera l'arxiu de solucions (totes) per la combinació del dia
gawk "/[$mestra]/" parsed/totes.txt \
  | gawk "! /[$excloses]/" \
  > results/$combo-totes.txt

# Generem el llistat d'expresions regulars per trobar els Tutis
# Un tuti ha d'incloure totes les lletres del dia
# Poden incloure vocals accentuades
tutis="! /[$excloses]/"
for (( index=0; index<llargaria_lletres_dia; index++ )); do
  letter=$(accentua_lletra ${lletres_dia:index:1})
  tutis+=" && /[${letter}]/"
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
