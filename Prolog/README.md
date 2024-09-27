# Prolog

The purpose of this project was to create a URI parser that could take a URI as input, as a string, and divide it into its parts according to a simplified model of the [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986) specification. Specifically, the URI can be decomposed into:

- Scheme
- Userinfo
- Host
- Port
- Path
- Query
- Fragment

The function that performs the parsing and grammar checking is `uri_parse`, which can be called as follows:

```
?- uri_parse(”http://disco.unimib.it”, URI).
URI = uri(http, [], ’disco.unimib.it’, 80, [], [], [])
```

To query the structure:

```
?- uri_parse(”http://disco.unimib.it”,
 uri(https, _, _, _, _, _, _)).
No
?- uri_parse(”http://disco.unimib.it”,
 uri(_ ,_ , Host, _, _, _, _)).
Host = ’disco.unimib.it’
```

As shown in the example above, the structure is as follows:

```
URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).
```

Finally, the results can be displayed using: `uri_display/1` e `uri_display/2`, used as follows:

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

With `uri_display/2`, you can print to a file as follows:

```
?- open('otuput.txt', write, Stream), uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", URI), uri_display(URI, Stream).

Stream = <stream>(0x6000037e9400),
URI = uri(https, michele, 'disco.unimib', '8080', 'folder/b', 'search=ciao', frag).
```
