# Uri parser in prolog

`uri_parse/2`

```
?- uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", URI).
URI = uri("https", "michele", "disco.unimib", "8080", "folder/b", "search=ciao", "frag").
``` 

will print in URI the parsed uri object.
To interrogate the uri just use:

```
?- uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", uri(_,_,Host,_,_,_,_)).

Host = "disco.unimib"
```

You can also verify host part like this: 
 ```
 ?- uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", uri(_,_,'disco.unimib.it',_,_,_,_)).
 
 false.
 ```

---

In the end you can also display the all structure with `uri_display/1` and `uri_display/2`

usage is the following: 
```
?-uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", URI), uri_display(URI).

Scheme:https
Userinfo:michele
Host:disco.unimib
Port:8080
Path:folder/b
Query:search=ciao
Fragment:frag
URI = uri("https", "michele", "disco.unimib", "8080", "folder/b", "search=ciao", "frag").
````
with `uri_display/2` you can print to a file like this: 
```
?- open('otuput.txt', write, Stream), uri_parse("https://michele@disco.unimib:8080/folder/b?search=ciao#frag", URI), uri_display(URI, Stream).

Stream = <stream>(0x6000037e9400),
URI = uri("https", "michele", "disco.unimib", "8080", "folder/b", "search=ciao", "frag").
```