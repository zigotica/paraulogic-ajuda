#!/usr/bin/env bash

function ordena () {
  # Convertim les lletres passades per l'usuari a minúscules
  str=$(echo "$1" | awk '{print tolower($0)}')

  # Variables per treballar amb vocals accentuades
  as="aāáǎàä"
  es="eēéěèë"
  is="iīíǐìï"
  os="oōóǒòö"
  us="uūúǔùǖǘǚǜü"

  # Forcem que les "lletres base" (mestra i resta) estiguin sense accents
  str=$(echo $str | sed "s/[$as]/a/g" | sed "s/[$es]/e/g" | sed "s/[$is]/i/g" | sed "s/[$os]/o/g" | sed "s/[$us]/u/g")

  # Generem la lletra mestra (obligatòria a totes les paraules del dia)
  mestra=${str:0:1}
  # Treballem la resta de lletres del dia i les ordenem per desar sempre el mateix nom d'arxiu
  resta=${str:1}
  restaordenada=$(echo $resta | grep -o . | sort | tr -d "\n")
  combo="$mestra$restaordenada"
}

