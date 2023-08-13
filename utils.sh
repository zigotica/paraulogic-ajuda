#!/usr/bin/env bash

# Variables per donar color als outputs
RED="$(tput setaf 1)"
GRN="$(tput setaf 2)"
YEL="$(tput setaf 3)"
RST="$(tput sgr0)"

# Variables per treballar amb vocals accentuades
as="āáǎàä"
es="ēéěèë"
is="īíǐìï"
os="ōóǒòö"
us="ūúǔùǖǘǚǜü"
vocals_desaccentuades="[aeiou]"
vocals_accentuades="$as$es$is$os$us"
abecedari_accentuat="a${as}bcçde${es}fghi${is}jklmno${os}pqrstu${us}vwxyz"

function err() {
  echo -ne "\n${RED}$*${RST}\n" >&2
  exit 1
}

function mostra_resultats() {
  if [ "$1" ]; then
    count=$(echo $1 | wc -w | xargs)
    echo -ne "\n${GRN}Resultats... ($count)${RST} \n"
    echo $1
  else
    echo -ne "\n${RED}No hi ha resultats${RST}"
  fi
}

function minusculitza() {
  # Convertim les lletres passades per l'usuari a minúscules
  echo "$1" | awk '{print tolower($0)}'
}

function desaccentua() {
  echo "$1" | sed "s/[$as]/a/g" | sed "s/[$es]/e/g" | sed "s/[$is]/i/g" | sed "s/[$os]/o/g" | sed "s/[$us]/u/g"
}

function accentua() {
  echo "$1" | sed "s/a/a$as/g" | sed "s/e/e$es/g" | sed "s/i/i$is/g" | sed "s/o/o$os/g" | sed "s/u/u$us/g"
}

function accentua_cadena_regex() {
  echo "$1" | sed "s/a/[a$as]/g" | sed "s/e/[e$es]/g" | sed "s/i/[i$is]/g" | sed "s/o/[o$os]/g" | sed "s/u/[u$us]/g"
}

function conte_accent() {
  if [[ "$1" =~ [$vocals_accentuades] ]]; then
    echo "true"
  else
    echo "false"
  fi
}

function accentua_lletra() {
  prova_accents=$(echo ${1}s)
  if [[ $1 =~ $vocals_desaccentuades ]]; then
    echo "$1${!prova_accents}"
  else
    echo "${1}"
  fi
}

function ordena_lletres_dia() {
  # Convertim a minúscules
  lletres_dia=$(minusculitza $1)
  # Forcem que les "lletres base" (mestra i resta) estiguin sense accents
  lletres_dia=$(desaccentua $lletres_dia)
  # però guardem les possibles combinacions amb accents
  lletres_dia_accentuades=$(accentua $lletres_dia)

  # Generem la lletra mestra (obligatòria a totes les paraules del dia)
  mestra=${lletres_dia:0:1}
  # Treballem la resta de lletres del dia i les ordenem per desar sempre el mateix nom d'arxiu
  resta=${lletres_dia:1}
  resta_ordenada=$(echo $resta | grep -o . | sort | tr -d "\n")
  combo="$mestra$resta_ordenada"
}

