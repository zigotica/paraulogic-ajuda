#!/usr/bin/env bash

# ./run.sh abcdefg
# La primera de les lletres és la obligatòria a totes les paraules del dia

str=$(echo "$1" | awk '{print tolower($0)}')
as="aāáǎàä"
es="eēéěèë"
is="iīíǐìï"
os="oōóǒòö"
us="uūúǔùǖǘǚǜü"
straccented=$(echo $str | sed "s/a/$as/g" | sed "s/e/$es/g" | sed "s/i/$is/g" | sed "s/o/$os/g" | sed "s/u/$us/g")
mestra=${str:0:1}
resta=${str:1}
restaordenada=$(echo $resta | grep -o . | sort | tr -d "\n")
combo="$mestra$restaordenada"
excloses=$(echo "${as}bcçd${es}fgh${is}jklmn${os}pqrst${us}vwxyz" | sed "s/[$straccented]//g")
strlen=${#str}

echo "MESTRA: $mestra RESTA: $restaordenada EXCLOSES: $excloses"

accentmestra=$(echo ${mestra}s)
if [[ $mestra =~ [aeiou] ]]; then
  mestra="${!accentmestra}"
else
  mestra="${mestra}"
fi

gawk "/[$mestra]/" parsed/filtrades.txt \
  | gawk "! /[$excloses]/" \
  > results/$combo-filtrades.txt

gawk "/[$mestra]/" parsed/totes.txt \
  | gawk "! /[$excloses]/" \
  > results/$combo-totes.txt

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

gawk "$tutis" parsed/filtrades.txt \
  > results/$combo-tutis.txt

red=$(cat results/$combo-filtrades.txt | wc -l | xargs)
dic=$(cat results/$combo-totes.txt | wc -l | xargs)
tut=$(cat results/$combo-tutis.txt | wc -l | xargs)

echo "${red} FILTRADES DE LA LLISTA REDUÏDA results/$combo-filtrades.txt"
echo "${dic} FILTRADES DEL DICCIONARI COMPLET results/$combo-totes.txt"
echo "${tut} POSSIBLES TUTIS results/$combo-tutis.txt"
