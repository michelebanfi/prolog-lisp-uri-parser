%%prova DCG
return_scheme([':' | Xs], Y, Y, Xs).
return_scheme([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_scheme(Xs, L, S, R).

return_fragment(['#' | Xs], Y, Y, Xs).
return_fragment([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_fragment(Xs, L, S, R).

return_query(['?' | Xs], Y, Y, Xs).
return_query([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_query(Xs, L, S, R).

return_authority_path([], Y, Y, []).
return_authority_path(['/' | Xs], Y, Y, Xs).
return_authority_path([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_authority_path(Xs, L, S, R).

uri_pars(uriString):-
    atom_char(uriString, X),
    return_scheme(X, [], Scheme, R1),
    reverse(R1, L1),
    return_fragment(L1, [], Fragment, R2),
    return_query(R2, [], Query, R3),
    reverse(R3, L2),
    return_authority_path(L2, [], Authority, Path),
    print(Scheme), print(Authority), print(Path), print(Query),
    print(Fragment).


%%uri(S, I, H, Port, Path,  Q, F) :-

return_a([], Y, Y, []).
retuna_a(['/' | Xs], Y, Y, ['/'| Xs]).
retuna_a(['?' | Xs], Y, Y, ['?'| Xs]).
retuna_a(['#' | Xs], Y, Y, ['#'| Xs]).

return_authority(['/', '/' | Xs], Y, Y, Xs).

return_host([], Y, Y, []).
return_host(['@' | Xs], Y, Y, Xs) :-
    return_userinfo(Y).

return_host([X | Xs], Y, S, R) :-
    append(Y, [X], L),
    return_host(Xs, L, S, R).


uri(S, R) :-
    atom_chars(S, L),
    reverse(L, X),
    phrase(scheme(X), R).
    %phrase(authority(Rests), Rests , R).

%% Grammatica scheme

scheme(C) --> identificatori(C).

identificatori([]) --> [].

identificatori([C | T]) --> id(C), identificatori(T).

id(C) --> [C],
    {C \= '/',
     C \= '?',
     C \= '#',
     C \= '@',
     C \= ':'}.
% Fine grammatica scheme


authority(C) --> [C],
    {C = '/'}.

authority(C) --> host(C).

host(C) --> identificatori_host(C).

identificatori_host([C | T]) --> id_host(C), identificatori_host(T).

identificatori_host([]) --> [].

id_host(C) --> [C],
    {C \= '.',
     C \= '/',
     C \= '?',
     C \= '#',
     C \= '@',
     C \= ':'}.


% Approccio senza DCG

uriS(S):-
    atom_chars(S, X),
    scheme(X, []).

scheme(X, []) :- identificatore(X, _).

identificatore([X | Xs],  [X | Xs]) :-
    X \= '/',
    X \= '?',
    X \= '#',
    X \= '@',
    X \= ':',
    identificatore(Xs, Xs).

%identificatore([_X | Xs]):- authority(Xs).

authority([X | _Xs]) :-
    X = '/',
    X = '/',
    host(X).

host(X) :- id_host(X).

id_host([]):- id_host(_Xs).

id_host([X | Xs]) :-
    X \= '.',
    X \= '/',
    X \= '?',
    X \= '#',
    X \= '@',
    X \= ':',
    id_host(Xs).






