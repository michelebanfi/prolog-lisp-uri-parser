# Lisp

Lo scopo di questo progetto é stato quello di creare un parser uri che potesse prendere in input un uri, come strina, e dividerlo nelle sue parti secondo un modello semplificato della specifica [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986). In particolare l'uri puó essere scomposto in:

- Scheme
- Userinfo
- Host
- Port
- Path
- Query
- Fragment

La funzione che esegue il parsing e il controllo della grammatica é `uri-parse` puó essere chiamata nel seguente modo:

```
CL prompt> (defparameter disco (uri-parse ”http://disco.unimib.it”))
DISCO
```

Tramite i metodi appositi si puó stampare a video la parte dell'uri desiderata:

```
CL prompt> (uri-scheme disco)
”http”
```

Inoltre per una maggiore leggibilitá é stato implementato il metodo `uri-display`come segue:

```
CL prompt> (uri-display disco)
Scheme: HTTP
Userinfo: NIL
Host: ”disco.unimib.it”
Port: 80
Path: NIL
Query: NIL
Fragment: NIL
```

Nel caso si voglia salvare il risultato in un file:

```
ES
```
