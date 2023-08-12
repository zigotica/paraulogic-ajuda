#!/usr/bin/env bash

# Preparació de directoris
# ------------------------

mkdir parsed parsed/parcials results

# Actualitzaceo dels arxius originals
# -----------------------------------

cd orig
for url in https://raw.githubusercontent.com/Softcatala/catalan-dict-tools/master/diccionari-arrel/{adjectius-fdic.txt,adverbis-lt.txt,adverbis-ment-lt.txt,dnv/mots-classificats.txt,noms-fdic.txt,resta-lt.txt,verbs-fdic.txt}; do
  curl -O "$url"
done;
unset url;
curl -O "https://raw.githubusercontent.com/Softcatala/catalan-dict-tools/master/resultats/lt/diccionari.txt"
cd ..

# Pre-processat de varis arxius del Diccionari Arrel
# --------------------------------------------------

# Adjectius
# Tot el que tenim darrera del `=categories` ho eliminarem.
# Després cal processar-ho en linies de 1 o 2 paraules.
# Ens genera linies en blanc i linies que no comencen per una lletra, això ho filtrarem més endavant.

awk -F'=' '{print $1}' orig/adjectius-fdic.txt \
  | awk '{print $1, $2}' \
  | awk 'BEGIN { FS = " "; OFS = "\n" } { print $1, $2 }' \
  > parsed/parcials/adjectius.txt

# Adverbis
# Primer concatenar arxius.
# En tots dos casos agafarem la primera columna

cat orig/adverbis* \
  | awk '{print $1}' \
  > parsed/parcials/adverbis.txt

# Mots classificats
# Procés similar als adjectius, tot i que més complicat perquè fem més tractament.
# Per començar simplifiquem l'arxiu i ens quedar amb el contingut anterior a #Ja acceptats com a multiparaules
# Aprofitem per reemplaçar els `=` per `;`
# Partim en columnes per `;` i ens quedem la primera part.
# Partim en columnes per `[` i ens quedem la primera part.
# A les línies que comencen per # canviem espais i , per punts.
# Partim les línies on hi ha coma en vàries línies
# Partim en columnes per `/` i ens quedem la primera part.
# Finalment les línies amb espai són convertides a multilínia.

cat orig/mots-classificats.txt \
  | sed '/#Ja acceptats com a multiparaules/,$d' \
  | sed "s/=/;/g" \
  | awk -F';' '{print $1}' \
  | awk -F'[' '{print $1}' \
  | sed '/^#/y/,/./' \
  | sed '/^#/y/ /./' \
  | sed "s/, /\n/g" \
  | awk -F',' '{print $1}' \
  | awk -F'/' '{print $1}' \
  | awk '{print $1, $2}' \
  | awk 'BEGIN { FS = " "; OFS = "\n" } { print $1, $2 }' \
  > parsed/parcials/mots-classificats.txt

# Noms
# Procés similar als adjectius, tot i que més simple.
# Tot el que tenim darrera del `=categories` ho eliminarem.
# Després cal processar-ho en linies de 1 o 2 paraules.
# Ens genera linies en blanc i linies que no comencen per una lletra, això ho filtrarem més endavant.

awk -F'=' '{print $1}' orig/noms-fdic.txt \
  | awk '{print $1, $2}' \
  | awk 'BEGIN { FS = " "; OFS = "\n" } { print $1, $2 }' \
  > parsed/parcials/noms.txt

# Resta
# Procés similar als noms, tot i que encara més simple.
# Tot el que tenim darrera del `=categories` ho eliminarem.
# El llistat ja hauria de ser de paraula única.

awk -F'=' '{print $1}' orig/resta-lt.txt \
  | awk '{print $1}' \
  > parsed/parcials/resta.txt

# Verbs
# Procés similar als noms, tot i que encara més simple.
# Tot el que tenim darrera del `=categories` ho eliminarem.
# El llistat ja hauria de ser de paraula única (l'infinitiu).

awk -F'=' '{print $1}' orig/verbs-fdic.txt \
  | awk '{print $1}' \
  > parsed/parcials/verbs.txt

# Generar arxius amb totes o filtrades sense variacions
# -----------------------------------------------------
# Concatenar arxius
# Eliminar: linies que no comencin per minúscula, duplicats, mots amb nombres, paraules de menys de 3 lletres
# Ordenar

eliminacions() {
  awk '$0 ~ /^[[:lower:]]/' \
  | awk '!visited[$0]++' \
  | awk '! /[0-9]/' \
  | awk 'length > 2'
}

cat parsed/parcials/* \
  | eliminacions \
  | sort \
  > parsed/filtrades.txt

cat orig/diccionari.txt parsed/parcials/mots-classificats.txt \
  | awk '{print $1}' \
  | eliminacions \
  | sort \
  > parsed/totes.txt

# Mostra per pantalla informació agregada dels arxius generats
red=$(cat parsed/filtrades.txt | wc -l | xargs)
dic=$(cat parsed/totes.txt | wc -l | xargs)

echo "${red} DICCIONARI REDUÏT parsed/filtrades.txt"
echo "${dic} DICCIONARI COMPLET parsed/totes.txt"
