%%prova DCG
atom_list([], []).
atom_list([X | Xs], R):- atom_string([X | Xs], R).
                         %atomic_list_concat([X | Xs], R)

return_scheme([':', '/', '/' | Xs], Y, Y, Xs) :- !.
return_scheme([':'| Xs], Y, Y, Xs) :- !.
return_scheme([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_scheme(Xs, L, S, R).

return_fragment([], Y, [], Y) :- !.
return_fragment(['#' | Xs], Y, Y, Xs) :- !.
return_fragment([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_fragment(Xs, L, S, R).

return_query([], Y, [], Y) :- !.
return_query(['?' | Xs], Y, Y, Xs) :- !.
return_query([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_query(Xs, L, S, R).

return_authority_path([], Y, Y, []) :- !.
return_authority_path(['/' | Xs], Y, Y, Xs) :- !.
return_authority_path([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_authority_path(Xs, L, S, R).

return_userinfo([], Y, [], Y) :- !.
return_userinfo(['@'| Xs], Y, Y, Xs) :- !.
return_userinfo([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_userinfo(Xs, L, S, R).

return_host_port([], Y, [], Y) :- !.
return_host_port([':'| Xs], Y, Xs, Y) :- !.
return_host_port([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_host_port(Xs, L, S, R).


uri_parse(UriString,
          uri(S, U, H, Po, Pa, Q, F)):-
    atom_chars(UriString, X),
    return_scheme(X, [], Scheme, R1),
    reverse(R1, L1),
    return_fragment(L1, [], Fragment, R2),
    return_query(R2, [], Query, R3),
    reverse(R3, L2),
    return_authority_path(L2, [], Authority, Path),
    return_userinfo(Authority, [], Userinfo, R4),
    return_host_port(R4, [], Port, Host),
    %uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment),
    atom_list(Scheme, S),
    atom_list(Userinfo, U),
    atom_list(Host, H),
    atom_list(Port, Po),
    atom_list(Path, Pa),
    atom_list(Query, Q),
    atom_list(Fragment, F).



uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment):-
    %modificare grammatica Host
    phrase(scheme(Scheme), Scheme),
    phrase(userinfo(Userinfo), Userinfo),
    phrase(host(Host), Host),
    phrase(port(Port), Port),
    phrase(path(Path), Path),
    phrase(query(Query), Query),
    phrase(fragment(Fragment), Fragment).

scheme(C) --> identificatori(C).

userinfo(C) --> identificatori(C).

identificatori([]) --> [].
identificatori([C | T]) --> id(C), identificatori(T).
id(C) --> [C],
    {C \= '/',
     C \= '?',
     C \= '#',
     C \= '@',
     C \= ':'}.


host(C) --> identificatore_host(C).

identificatore_host([]) --> [].
identificatore_host([C | T]) --> id_host(C), identificatore_host(T).
id_host(C) --> [C],
    {C \= '/',
     C \= '.',
     C \= '?',
     C \= '#',
     C \= '@',
     C \= ':'}.

port([]) --> [].
port([C | T]) --> digit(C), port(T).

digit(C)-->[C], {C = '0'}.
digit(C)-->[C], {C = '1'}.
digit(C)-->[C], {C = '2'}.
digit(C)-->[C], {C = '3'}.
digit(C)-->[C], {C = '4'}.
digit(C)-->[C], {C = '5'}.
digit(C)-->[C], {C = '6'}.
digit(C)-->[C], {C = '7'}.
digit(C)-->[C], {C = '8'}.
digit(C)-->[C], {C = '9'}.

path([]) --> [].
path([C | T]) --> id(C), path(T). %Sbagliato correggere


query([]) --> [].
query([C | T]) --> [C],{C \= '#'}, query(T).

fragment([]) --> [].
fragment([C | T]) --> [C], fragment(T).
