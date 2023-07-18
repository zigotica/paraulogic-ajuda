#!/usr/bin/env bash

# Preparació de directoris
# ------------------------

mkdir parsed parsed/parcials results


# Pre-processat de varis arxius del Diccionari Arrel
# --------------------------------------------------

# Adjectius
# Tot el que tenim darrera del `=categories` ho eliminarem.
# Després filtrem linies que comencin per una lletra minúscula.
# Després cal processar-ho en linies de 1 o 2 paraules.
# Ens genera linies en blanc i linies que no comencen per una lletra, això ho filtrarem més endavant.

awk -F'=' '{print $1}' orig/adjectius-fdic.txt \
  | awk '{print $1, $2}' \
  | awk '$0 ~ /^[[:lower:]]/' \
  |  awk 'BEGIN { FS = " "; OFS = "\n" } { print $1, $2 }' \
  > parsed/parcials/adjectius.txt

# Adverbis
# Primer concatenar arxius, després filtrem linies que comencin per una lletra minúscula.
# En tots dos casos agafarem la primera columna

cat orig/adverbis* \
  | awk '$0 ~ /^[[:lower:]]/' \
  | awk '{print $1}' \
  > parsed/parcials/adverbis.txt

# Mots classificats (locucions i poc usuals)
# Procés similar als adjectius, tot i que més simple.
# Per començar calia processar manualment els blocks de l'arxiu i quedar-nos exclusivament amb `locucions`
# i el tercer bloc de la secció `Poc usual`.
# Aprofitem per reemplaçar manualment els `=` per `;` i partim en columnes per `;`.
# Després ens quedem la primera paraula i filtrem linies que comencin per una lletra minúscula.  

awk -F';' '{print $1}' orig/mots-classificats.txt \
  | awk '{print $1}' \
  | awk '$0 ~ /^[[:lower:]]/' \
  > parsed/parcials/locucions-i-poc-usuals.txt

# Noms
# Procés similar als adjectius, tot i que més simple.
# Tot el que tenim darrera del `=categories` ho eliminarem.
# Després filtrem linies que comencin per una lletra minúscula.
# Després cal processar-ho en linies de 1 o 2 paraules.
# Ens genera linies en blanc i linies que no comencen per una lletra, això ho filtrarem més endavant.

awk -F'=' '{print $1}' orig/noms-fdic.txt \
  | awk '{print $1, $2}' \
  | awk '$0 ~ /^[[:lower:]]/' \
  | awk 'BEGIN { FS = " "; OFS = "\n" } { print $1, $2 }' \
  > parsed/parcials/noms.txt

# Resta
# Procés similar als noms, tot i que encara més simple.
# Tot el que tenim darrera del `=categories` ho eliminarem.
# Després filtrem linies que comencin per una lletra minúscula.
# El llistat ja hauria de ser de paraula única.

awk -F'=' '{print $1}' orig/resta-lt.txt \
  | awk '$0 ~ /^[[:lower:]]/' \
  | awk '{print $1}' \
  > parsed/parcials/resta.txt

# Verbs
# Procés similar als noms, tot i que encara més simple.
# Tot el que tenim darrera del `=categories` ho eliminarem.
# Després filtrem linies que comencin per una lletra minúscula.
# El llistat ja hauria de ser de paraula única (l'infinitiu).

awk -F'=' '{print $1}' orig/verbs-fdic.txt \
  | awk '$0 ~ /^[[:lower:]]/' \
  | awk '{print $1}' \
  > parsed/parcials/verbs.txt

# Generar arxius amb totes o filtrades sense variacions
# -----------------------------------------------------
# Concatenar arxius,
# reemplaçar accents per l'equivalent sense accent,
# eliminar linies que no comencin per minúscula,
# eliminar duplicats,
# eliminar paraules de menys de 3 lletres,
# ordenar:

accents="āáǎàēéěèīíǐìïōóǒòūúǔùǖǘǚǜüĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛÜ"
equival="aaaaeeeeiiiiioooouuuuuuuuuaaaaeeeeiiiioooouuuuuuuuu"

cat parsed/parcials/* \
  | sed -e "y/$accents/$equival/" \
  | awk '$0 ~ /^[[:lower:]]/' \
  | awk '!visited[$0]++' \
  | awk 'length > 2' \
  | sort \
  > parsed/filtrades.txt

cat orig/diccionari.txt parsed/parcials/locucions-i-poc-usuals.txt \
  | awk '{print $1}' \
  | sed -e "y/$accents/$equival/" \
  | awk '$0 ~ /^[[:lower:]]/' \
  | awk '!visited[$0]++' \
  | awk 'length > 2' \
  | sort \
  > parsed/totes.txt

