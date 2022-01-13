# Prolog

Lo scopo di questo progetto é stato quello di creare un parser uri che potesse prendere in input un uri, come strina, e dividerlo nelle sue parti secondo un modello semplificato della specifica [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986). In particolare l'uri puó essere scomposto in:

- Scheme
- Userinfo
- Host
- Port
- Path
- Query
- Fragment

La funzione che esegue il parsing e il controllo della grammatica é `uri_parse` puó essere chiamata nel seguente modo:

```
?- uri_parse(”http://disco.unimib.it”, URI).
URI = uri(http, [], ’disco.unimib.it’, 80, [], [], [])
```

Invece per interrogare la struttura:

```
?- uri_parse(”http://disco.unimib.it”,
 uri(https, _, _, _, _, _, _)).
No
?- uri_parse(”http://disco.unimib.it”,
 uri(_ ,_ , Host, _, _, _, _)).
Host = ’disco.unimib.it’
```

Come nell'esempio sopra mostrato la struttura é la seguente:

```
URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).
```

Infine si puó mostrare i risultati tramite: `uri_display/1` e `uri_display/2`

usati nel seguente modo:

```
?-uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", URI), uri_display(URI).

Scheme:https
Userinfo:michele
Host:disco.unimib
Port:8080
Path:folder/b
Query:search=ciao
Fragment:frag
URI = uri(https, michele, 'disco.unimib', '8080', 'folder/b', 'search=ciao', frag).
```

invece con `uri_display/2` si puó stampare su file cosi:

```
?- open('otuput.txt', write, Stream), uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", URI), uri_display(URI, Stream).

Stream = <stream>(0x6000037e9400),
URI = uri(https, michele, 'disco.unimib', '8080', 'folder/b', 'search=ciao', frag).
```
