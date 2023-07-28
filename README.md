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

## Filtrat de paraules del dia

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

## Agraïments

A l'equip de [Softcatala](https://github.com/Softcatala), especialment a [Jaume Ortolà](https://github.com/jaumeortola) i [Toni Hermoso](https://github.com/toniher), i a l'equip del Paraulògic pel divertiment.
