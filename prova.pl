%%prova DCG
ur

uri(S, I, H, Port, Path,  Q, F) :-


return_scheme([':' | Xs], Y, Y, Xs).

return_scheme([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_scheme(Xs, L, S, R).

return_authority(['/', '/' | Xs], Y, Y, Xs).

return_host([], Y, Y, []).
return_host(['@' | Xs], Y, Y, Xs) :-
    return_userinfo(Y).

return_host([X | Xs], Y, S, R) :-
    append(Y, [X], L),
    return_host(Xs, L, S, R).


uri(S, R) :-
    atom_chars(S, L),
    phrase(scheme(L), R).
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






