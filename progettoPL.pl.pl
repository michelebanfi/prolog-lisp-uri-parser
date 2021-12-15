%%prova DCG
return_scheme([':', '/', '/' | Xs], Y, Y, Xs).
return_scheme([':'| Xs], Y, Y, Xs).
return_scheme([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_scheme(Xs, L, S, R).

return_fragment([], Y, [], Y).
return_fragment(['#' | Xs], Y, Y, Xs).
return_fragment([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_fragment(Xs, L, S, R).

return_query([], Y, [], Y).
return_query(['?' | Xs], Y, Y, Xs).
return_query([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_query(Xs, L, S, R).

return_authority_path([], Y, Y, []).
return_authority_path(['/' | Xs], Y, Y, Xs).
return_authority_path([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_authority_path(Xs, L, S, R).

return_userinfo([], Y, [], Y).
return_userinfo(['@'| Xs], Y, Y, Xs).
return_userinfo([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_userinfo(Xs, L, S, R).

return_host_port([], Y, [], Y).
return_host_port([':'| Xs], Y, Xs, Y).
return_host_port([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_host_port(Xs, L, S, R).


uri_parse(UriString):-
    atom_chars(UriString, X),
    return_scheme(X, [], Scheme, R1),
    reverse(R1, L1),
    return_fragment(L1, [], Fragment, R2),
    return_query(R2, [], Query, R3),
    reverse(R3, L2),
    return_authority_path(L2, [], Authority, Path),
    return_userinfo(Authority, [], Userinfo, R4),
    return_host_port(R4, [], Port, Host),
    print(Scheme),
    print(Userinfo),
    print(Host),
    print(Port),
    print(Path),
    print(Query),
    print(Fragment).

