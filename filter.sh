#!/usr/bin/env bash

# Veure README

while getopts p:t:e:l:m:i:c:f: option
do
  case "${option}" in
    p) lletres=${OPTARG};;
    t) mots=${OPTARG};;
    e) equal=${OPTARG};;
    l) less=${OPTARG};;
    m) more=${OPTARG};;
    i) inici=${OPTARG};;
    c) conte=${OPTARG};;
    f) final=${OPTARG};;
    *)
      echo "Arguments incorrectes, veure README" >&2
      exit 1
      ;;
  esac
done

source ./utils.sh

if [ -z "$lletres" ]; then
  err "La opció -p és obligatòria (cal saber quines són les lletres del dia)"
fi

ordena_lletres_dia $lletres

if ! [ -s "results/$combo-filtrades.txt" ];then
  err "L'arxiu de solucions no existeix, cal executar './run.sh $lletres' abans de filtrar."
fi

echo -ne "\n${YEL}Calculant filtres...${RST}\n"

# Generem el llistat d'expresions regulars per excloure
# les paraules que passem via paràmetre -t
if [ "$mots" ]; then
  trobades=$(echo $mots | sed -e $'s/ o /,/g' | sed -e $'s/,/ /g')
  trobades_arr=($trobades)
  llarg=${#trobades_arr[@]}

  excloses="! /^${trobades_arr[0]}$/"
  for (( index=1; index<llarg; index++ )); do
    excloses+=" && ! /^${trobades_arr[index]}$/"
  done
fi

fn_mots() {
  if [ "$mots" ]; then
    gawk "$excloses"
  else
    gawk '{ print $0 }'
  fi
}

fn_equal() {
  if [ "$equal" ]; then
    gawk "length == $equal"
  else
    gawk '{ print $0 }'
  fi
}

fn_less() {
  if [ "$less" ]; then
    gawk "length < $less" \
      | gawk '{print length($0)"\t"$0}' \
      | sort -n \
      | cut -f2
  else
    gawk '{ print $0 }'
  fi
}

fn_more() {
  if [ "$more" ]; then
    gawk "length > $more" \
      | gawk '{print length($0)"\t"$0}' \
      | sort -n \
      | cut -f2
  else
    gawk '{ print $0 }'
  fi
}

# Si la cadena a filtrar conté algún accent, la mantenim
# Si no conté cap accent, els generem com a regex
if [ "$inici" ]; then
  if [[ $(conte_accent $inici) == "false" ]]; then
    inici=$(accentua_cadena_regex $inici)
  fi
fi

fn_inici() {
  if [ "$inici" ]; then
    gawk "/^$inici/"
  else
    gawk '{ print $0 }'
  fi
}

# Si la cadena a filtrar conté algún accent, la mantenim
# Si no conté cap accent, els generem com a regex
if [ "$conte" ]; then
  if [[ $(conte_accent $conte) == "false" ]]; then
    conte=$(accentua_cadena_regex $conte)
  fi
fi

fn_conte() {
  if [ "$conte" ]; then
    gawk "/$conte/"
  else
    gawk '{ print $0 }'
  fi
}

# Si la cadena a filtrar conté algún accent, la mantenim
# Si no conté cap accent, els generem com a regex
if [ "$final" ]; then
  if [[ $(conte_accent $final) == "false" ]]; then
    final=$(accentua_cadena_regex $final)
  fi
fi

fn_final() {
  if [ "$final" ]; then
    gawk "/$final$/"
  else
    gawk '{ print $0 }'
  fi
}


resultats=$(cat results/$combo-filtrades.txt \
  | fn_mots \
  | fn_equal \
  | fn_less \
  | fn_more \
  | fn_inici \
  | fn_conte \
  | fn_final \
  | sort)

mostra_resultats "$resultats"
