#!/usr/bin/env bash

# ./run.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

source ./utils.sh
ordena_lletres_dia $1
genera_excloses

echo -ne "\n${GRN}MESTRA${RST} $mestra ${GRN}RESTRA${RST} $resta ${GRN}EXCLOSES${RST} $excloses\n"

# Si la mestra és una vocal, volem els seus accents per la futura expresió regular
echo -ne "\n${YEL}Calculant si la mestra pot tenir accents...${RST}\n"
mestra=$(accentua_lletra $mestra)

# Genera l'arxiu de solucions filtrades per la combinació del dia
echo -ne "\n${YEL}Generant l'arxiu de solucions filtrades per la combinació del dia...${RST} results/$combo-diccionari.txt"
gawk "/[$mestra]/" parsed/diccionari.txt \
  | gawk "! /[$excloses]/" \
  | gawk 'length > 2' \
  > results/$combo-diccionari.txt

# Generem el llistat d'expresions regulars per trobar els Tutis
echo -ne "\n${YEL}Generant les expresions regulars per trobar els tutis...${RST}"
genera_regex_tutis

# Genera l'arxiu de tutis per la combinació del dia
echo -ne "\n${YEL}Generant l'arxiu de tutis per la combinació del dia...${RST} results/$combo-tutis.txt"
gawk "$tutis" parsed/diccionari.txt \
  | gawk 'length > 2' \
  > results/$combo-tutis.txt

# Mostra per pantalla informació agregada dels arxius generats
red=$(cat results/$combo-diccionari.txt | wc -l | xargs)
tut=$(cat results/$combo-tutis.txt | wc -l | xargs)

echo -ne "\n\n${YEL}Informació agregada dels arxius generats${RST}"
echo -ne "\n\t${GRN}${red}${RST}\t Filtrades de la llista reduïda"
echo -ne "\n\t${GRN}${tut}${RST}\t Possibles Tutis"
