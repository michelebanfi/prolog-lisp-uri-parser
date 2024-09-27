# Lisp

The purpose of this project was to create a URI parser that could take a URI as input, as a string, and divide it into its parts according to a simplified model of the [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986) specification. Specifically, the URI can be decomposed into:

- Scheme
- Userinfo
- Host
- Port
- Path
- Query
- Fragment

The function that performs the parsing and grammar checking is `uri-parse`, which can be called as follows:

```
CL prompt> (defparameter disco (uri-parse ”http://disco.unimib.it”))
DISCO
```

Using the appropriate methods, you can print the desired part of the URI to the screen:

```
CL prompt> (uri-scheme disco)
”http”
```

Additionally, for better readability, the `uri-display` method was implemented as follows:

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

If you want to save the result to a file:

```
ES
```
