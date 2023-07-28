#!/usr/bin/env bash

str=$(echo "$1" | awk '{print tolower($0)}')
as="aāáǎàä"
es="eēéěèë"
is="iīíǐìï"
os="oōóǒòö"
us="uūúǔùǖǘǚǜü"
straccented=$(echo $str | sed "s/a/$as/g" | sed "s/e/$es/g" | sed "s/i/$is/g" | sed "s/o/$os/g" | sed "s/u/$us/g")
mestra=${str:0:1}
resta=${str:1}
excloses=$(echo "${as}bcçd${es}fgh${is}jklmn${os}pqrst${us}vwxyz" | sed "s/[$straccented]//g")
strlen=${#str}

echo "MESTRA: $mestra RESTA: $resta EXCLOSES: $excloses"

gawk "/$mestra/" parsed/filtrades.txt \
  | gawk "! /[$excloses]/" \
  > results/$str-filtrades.txt

gawk "/$mestra/" parsed/totes.txt \
  | gawk "! /[$excloses]/" \
  > results/$str-totes.txt

tutis="/$mestra/"
for (( index=1; index<strlen; index++ )); do
  letter=${str:index:1}
  if [[ $letter == "a" ]]; then
    tutis+=" && /[$as]/"
  elif [[ $letter == "e" ]]; then
    tutis+=" && /[$es]/"
  elif [[ $letter == "i" ]]; then
    tutis+=" && /[$is]/"
  elif [[ $letter == "o" ]]; then
    tutis+=" && /[$os]/"
  elif [[ $letter == "u" ]]; then
    tutis+=" && /[$us]/"
  else
    tutis+=" && /${str:index:1}/"
  fi
done

gawk "$tutis" parsed/filtrades.txt \
  | gawk "! /[$excloses]/" \
  > results/$str-tutis.txt

red=$(cat results/$str-filtrades.txt | wc -l | xargs)
dic=$(cat results/$str-totes.txt | wc -l | xargs)
tut=$(cat results/$str-tutis.txt | wc -l | xargs)

echo "${red} FILTRADES DE LA LLISTA REDUÏDA results/$str-filtrades.txt"
echo "${dic} FILTRADES DEL DICCIONARI COMPLET results/$str-totes.txt"
echo "${tut} POSSIBLES TUTIS results/$str-tutis.txt"
