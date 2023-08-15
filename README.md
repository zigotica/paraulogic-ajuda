# Ajudes pel Paraulògic

Aquest repositori és un conjunt d'eines per incentivar l'acabament del Paraulògic. No proporciona les solucions de forma directa, doncs aquestes són un subconjunt de les possibles paraules trobades per aquesta aplicació, que compleixen les regles del joc. Tampoc pretén automatitzar la introducció de les possibles solucions al navegador.

## Arxius originals

Farem servir arxius del repositori [catalan-dict-tools](https://github.com/Softcatala/catalan-dict-tools/) de [Softcatala](https://github.com/Softcatala/). Ens basarem en arxius per tipologies de paraules trobats al directori del [Diccionari-Arrel](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel):

* [adjectius](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/adjectius-fdic.txt)
* [adverbis-lt](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/adverbis-lt.txt)
* [adverbis-ment](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/adverbis-ment-lt.txt)
* [mots-classificats](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/dnv/mots-classificats.txt). En aquest cas, ens quedem amb les linies inicials fins al bloc `Ja acceptats com a multiparaules` i fem un tractament especial per simplificar el processament posterior.
* [noms](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/noms-fdic.txt)
* [resta](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/resta-lt.txt)
* [verbs](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/verbs-fdic.txt)

Aquests arxius es troben a la carpeta `orig` d'aquest repositori, i s'actualitzen cada cop que executem `./update.sh`.

El [diccionari complet](https://github.com/Softcatala/catalan-dict-tools/blob/master/resultats/lt/diccionari.txt) inclou variacions gramaticals i conjugacions de verbs. Molts d'aquests mots no s'accepten al Paraulògics, per la qual cosa no el fem servir. El diccionari que construirem a partir del diccionari arrel és molt més reduït.

## Requisits

* awk
* gawk
* sed
* sort
* wc
* xargs
* tr
* curl

## Preparació del diccionari

```bash
./update.sh
```

Hauriem de veure missatges a mida que es van descarregant i pre-processant els arxius originals, i al final com a resum, quelcom similar a això:

```
Generant l'arxiu de diccionari filtrat (sense variacions)... parsed/diccionari.txt

Informació agregada de l'arxiu generat
        149284   Diccionari reduït
```

## Generar solució de paraules del dia

```bash
./run.sh GORSNAC
```

La primera de les lletres és la obligatòria a totes les paraules del dia. Hauriem de veure un resultat similar a:

```
MESTRA g RESTRA orsnac EXCLOSES bçdeēéěèëfhiīíǐìïjklmpqtuūúǔùǖǘǚǜüvwxyz

Calculant si la mestra pot tenir accents...

Generant l'arxiu de solucions filtrades per la combinació del dia... results/gacnors-diccionari.txt
Generant les expresions regulars per trobar els tutis...
Generant l'arxiu de tutis per la combinació del dia... results/gacnors-tutis.txt

Informació agregada dels arxius generats
        127      Filtrades de la llista reduïda
        2        Possibles Tutis
```

Com veiem, es generen dos arxius, `resultats/gacnors-diccionari.txt` i `results/gacnors-tutis.txt`.

## Filtrat de paraules del dia

Un cop portem una estona jugant, podem voler saber quines de les possibles solucions ens queden per trobar, sense haver de mirar i cercar a ull dins l'arxiu de solucions del dia. Podem executar aquest script passant opcions per filtrar el resultat.

Com a mínim, hem de passar les lletres del dia, amb l'argument `-d`:

```bash
./filter.sh -d gacnors
```

La primera de les lletres és la obligatòria a totes les paraules del dia.

Si no passem més arguments, el filtrat és equivalent a veure l'arxiu de resultats del dia. En tots els casos, el programa retorna el llistat de paraules per pantalla, no escriu cap arxiu.

Podem afegir arguments extra per filtrar paraules que tinguin un llarg determinat, que continguin un text a alguna posició, o que no estiguin dins de la llista de paraules que ja hem trobat prèviament.

Aquests arguments són:

* `-e` per filtrar paraules amb un llarg determinat.
* `-l` per filtrar paraules amb un llarg menor que un valor.
* `-m` per filtrar paraules amb un llarg major que un valor.
* `-i` per filtrar paraules que inicien per una cadena de text.
* `-c` per filtrar paraules que contenen una cadena de text.
* `-f` per filtrar paraules que finalitzen per una cadena de text.
* `-p` per filtrar paraules que no estiguin a un llistat previ. El llistat entre cometes pot ser un copy/paste de les paraules trobades al paraulògic. Normalment cada paraula va separada per coma, però de vegades una coincidència pot incloure dues o més paraules separades per ` o `. Per exemple, "ala o alà, arrel, mal".
* `-t` (sense cap altre valor) per filtrar els tutis.

Per exemple:

```bash
./filter.sh -d gacnors -e 5
```

En aquest cas, el programa retorna el llistat de paraules amb un llarg de 5 lletres:

```
Calculant filtres...

Resultats... (32)
agràs agror agrós cagar carga conga ganga ganós gansa ganso garra garró garsa garsó gasar gasca gascó gasós gassa gassó gorga gorra gosar gossa grana groga sango sarga sogar sogra sorgo
```

Per trobar tutis

```bash
./filter.sh -d gacnors -t
```

En aquest cas, el programa retorna el llistat de tutis:

```
Calculant filtres...

Resultats... (2)
consagrar consogra
```

Els filtres es poden combinar, de forma que podem filtrar paraules que no estiguin a un llistat previ i que tinguin un llarg determinat. Per exemple:

```bash
./filter.sh -d gacnors -m 4 -p "carga, conga, ganga, gossa, grana"
```

En aquest cas, el programa retorna el llistat de paraules amb un llarg de més de 4 lletres i que no siguin cap de les paraules del llistat (que han d'anar separades per coma i entre cometes). O també:


```bash
./filter.sh -d gacnors -e 5 -i "ga"
```

En aquest cas, el programa retorna el llistat de paraules amb un llarg de 5 lletres i que comencen per "ga":

```
Calculant filtres...

Resultats... (14)
ganga ganós gansa ganso garra garró garsa garsó gasar gasca gascó gasós gassa gassó
```

Nota: tot i que internament es fan servir, he volgut simplificar l'ús evitant la necessitat de passar expressions regulars, per això hem separat el filtrat en arguments `-i`, `-c` i `-f`.

## Agraïments

A l'equip de [Softcatala](https://github.com/Softcatala), especialment a [Jaume Ortolà](https://github.com/jaumeortola) i [Toni Hermoso](https://github.com/toniher), i a l'equip del Paraulògic pel divertiment.

## Llicència

Mantenim la llicència LGPL v2.1 i GPL v2 que es fa servir al repositori [catalan-dict-tools](https://github.com/Softcatala/catalan-dict-tools/) de [Softcatala](https://github.com/Softcatala/) mencionat anteriorment. Veure els arxius amb els texts complets a la carpeta `licenses`.
