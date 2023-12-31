#!/usr/bin/env bash

# Veure README

while getopts d:p:e:l:m:i:c:f:t option
do
  case "${option}" in
    d) lletres_dia=${OPTARG};;
    p) paraules=${OPTARG};;
    e) equal=${OPTARG};;
    l) less=${OPTARG};;
    m) more=${OPTARG};;
    i) inici=${OPTARG};;
    c) conte=${OPTARG};;
    f) final=${OPTARG};;
    t) mostra_tutis="true";;
    *)
      echo "Arguments incorrectes, veure README" >&2
      exit 1
      ;;
  esac
done

source ./utils.sh

if [ -z "$lletres_dia" ]; then
  err "La opció -d és obligatòria (cal saber quines són les lletres del dia)"
fi

ordena_lletres_dia $lletres_dia

if ! [ -s "results/$combo-diccionari.txt" ];then
  err "L'arxiu de solucions no existeix, cal executar './run.sh $lletres_dia' abans de filtrar."
fi

echo -ne "\n${YEL}Calculant filtres...${RST}\n"

# Generem el llistat d'expresions regulars per excloure
# les paraules que passem via paràmetre -t
if [ "$paraules" ]; then
  trobades=$(echo $paraules | sed -e $'s/ o /,/g' | sed -e $'s/,/ /g')
  trobades_arr=($trobades)
  llarg=${#trobades_arr[@]}

  filtrades="! /^${trobades_arr[0]}$/"
  for (( index=1; index<llarg; index++ )); do
    filtrades+=" && ! /^${trobades_arr[index]}$/"
  done
fi

fn_paraules() {
  if [ "$paraules" ]; then
    gawk "$filtrades"
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

# Filtra per retornar només els tutis
genera_regex_tutis
fn_tutis() {
  if [ "$mostra_tutis" ]; then
    gawk "$tutis"
  else
    gawk '{ print $0 }'
  fi
}

resultats=$(cat results/$combo-diccionari.txt \
  | fn_paraules \
  | fn_equal \
  | fn_less \
  | fn_more \
  | fn_inici \
  | fn_conte \
  | fn_final \
  | fn_tutis \
  | sort)

mostra_resultats "$resultats"
