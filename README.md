# Ajudes pel Paraulògic

Aquest repositori és un conjunt d'eines per incentivar l'acabament del Paraulògic. No proporciona les solucions de forma directa, doncs aquestes són un subconjunt de les possibles paraules trobades per aquesta aplicació, que compleixen les regles del joc. Tampoc pretén automatitzar la introducció de les possibles solucions al navegador.

## Arxius originals

Farem servir arxius del repositori [catalan-dict-tools](https://github.com/Softcatala/catalan-dict-tools/) de [Softcatala](https://github.com/Softcatala/). Ens basarem en un parell de conjunts de dades. 

Per una banda, el [diccionari](https://github.com/Softcatala/catalan-dict-tools/blob/master/resultats/lt/diccionari.txt) pre-generat amb les seves eines. 

D'altra banda, arxius per tipologies de paraules trobats al directori del [Diccionari-Arrel](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel):

* [adjectius](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/adjectius-fdic.txt)
* [adverbis-lt](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/adverbis-lt.txt)
* [adverbis-ment](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/adverbis-ment-lt.txt)
* [mots-classificats](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/dnv/mots-classificats.txt). En aquest cas, i per simplificar l'automatització, primer calia processar manualment els blocs de l'arxiu i quedar-nos exclusivament amb `locucions` i el tercer bloc de la secció `Poc usual`. Aprofitem per reemplaçar manualment els `=` per `;` per simplificar el processament posterior.
* [noms](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/noms-fdic.txt)
* [resta](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/resta-lt.txt)
* [verbs](https://github.com/Softcatala/catalan-dict-tools/blob/master/diccionari-arrel/verbs-fdic.txt)

Aquests arxius es troben a la carpeta `orig` d'aquest repositori.

El diccionari inclou variacions gramaticals i conjugacions de verbs. Molts d'aquests mots no s'accepten al Paraulògic, però mantindrem el llistat de totes formes per contrastar opcions. El llistat processat que construirem a partir del diccionari arrel és molt més reduït.

## Requisits

* awk
* gawk
* sed
* sort
* wc
* xargs
* diff

## Preparació dels llistats

```bash
./update.sh
```

Nota: per simplificar el processament de les dades, s'eliminen els mots de menys de 3 lletres.

## Generar solució de paraules del dia

```bash
./run.sh abcdefg
```

La primera de les lletres és la obligatòria a totes les paraules del dia. Hauriem de rebre un resultat similar:

```
MESTRA: a RESTA: bcdefg EXCLOSES: çhijklmnopqrstuvwxyz
57 FILTRADES DE LA LLISTA REDUÏDA results/abcdefg-filtrades.txt
92 FILTRADES DEL DICCIONARI COMPLET results/abcdefg-totes.txt
```

Com veiem, es generen dos arxius, `resultats/abcdefg-filtrades.txt` i `resultats/abcdefg-totes.txt`.

Idealment totes les paraules del dia han de sortir al llistat de paraules filtrades. Podem treure un llistat de les diferències dels dos llistats si fem:

```bash
./diff.sh abcdefg
```

## Filtrat de paraules del dia

Un cop portem una estona jugant, podem voler saber quines de les possibles solucions ens queden per trobar, sense haver de mirar i cercar a ull dins l'arxiu de solucions del dia. Podem executar aquest script passant opcions per filtrar el resultat.

Com a mínim, hem de passar les lletres del dia, amb l'argument `-p`:

```bash
./filter.sh -p abcdefg"
```

La primera de les lletres és la obligatòria a totes les paraules del dia.

Si no passem més arguments, el filtrat és equivalent a veure l'arxiu de resultats del dia. En tots els casos, el programa retorna el llistat de paraules per pantalla, no escriu cap arxiu.

Podem afegir d'un a quatre arguments extra per filtrar paraules que tinguin un llarg determinat, o que no estiguin dins de la llista de paraules que ja hem trobat prèviament.

Aquests arguments són:

* `-e` per filtrar paraules amb un llarg determinat.
* `-l` per filtrar paraules amb un llarg menor que un valor.
* `-m` per filtrar paraules amb un llarg major que un valor.
* `-i` per filtrar paraules que inicien per una cadena de text.
* `-c` per filtrar paraules que contenen una cadena de text.
* `-f` per filtrar paraules que finalitzen per una cadena de text.
* `-t` per filtrar paraules que no estiguin a un llistat previ. El llistat entre cometes pot ser un copy/paste de les paraules trobades al paraulògic. Normalment cada paraula va separada per coma, però de vegades una coincidència pot incloure dues o més paraules separades per ` o `. Per exemple, "ala o alà, arrel, mal".

Els filtres es van acumulant, de forma que podem filtrar paraules que no estiguin a un llistat previ i que tinguin un llarg determinat. Per exemple:

```bash
./filter.sh -p abcdefg -e 5
```

En aquest cas, el programa retorna el llistat de paraules amb un llarg de 5 lletres.

```bash
./filter.sh -p abcdefg -m 7 -t "ala o alà, arrel, mal"
```

En aquest cas, el programa retorna el llistat de paraules amb un llarg de més de 7 lletres i que no siguin cap de les 4 paraules del llistat (ala o alà, arrel, mal).


```bash
./filter.sh -p abcdefg -m 7 -i "va"
```

En aquest cas, el programa retorna el llistat de paraules amb un llarg de més de 7 lletres i que comencen per "va".

Nota: tot i que internament es fan servir, he volgut simplificar l'ús evitant la necessitat de passar expressions regulars, per això hem separat el filtrat en arguments `-i`, `-c` i `-f`.

## Agraïments

A l'equip de [Softcatala](https://github.com/Softcatala), especialment a [Jaume Ortolà](https://github.com/jaumeortola) i [Toni Hermoso](https://github.com/toniher), i a l'equip del Paraulògic pel divertiment.

## Llicència

Mantenim la llicència LGPL v2.1 i GPL v2 que es fa servir al repositori [catalan-dict-tools](https://github.com/Softcatala/catalan-dict-tools/) de [Softcatala](https://github.com/Softcatala/) mencionat anteriorment. Veure els arxius amb els texts complets a la carpeta `licenses`.
