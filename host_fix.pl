%[u, n, i, m, b, ., i, t] --> [unimib, ., it]
atom_list([], []).
atom_list([X | Xs], R):- atom_string([X | Xs], R).
                         %atomic_list_concat([X | Xs], R)

host_fixer([], Y, Temp,  _Temp2, R) :-
    atom_list(Y, Res),
    append(Temp, [Res], R).

host_fixer(['.' | Xs] , Y, Temp, Temp2, R):-
    atom_list(Y, Res),
    append([Res], ['.'], Rap),
    append(Temp, Rap, Temp2),
    host_fixer(Xs, [], Temp2, _Temp, R), !.

host_fixer([X | Xs], Y , Temp, Temp2, R):-
    append(Y, [X], L),
    host_fixer(Xs, L, Temp, Temp2 ,R),!.


path_fixer([], Y, Temp,  _Temp2, R) :-
    atom_list(Y, Res),
    append(Temp, [Res], R).

path_fixer(['/' | Xs] , Y, Temp, Temp2, R):-
    atom_list(Y, Res),
    append([Res], ['/'], Rap),
    append(Temp, Rap, Temp2),
    host_fixer(Xs, [], Temp2, _Temp, R), !.

path_fixer([X | Xs], Y , Temp, Temp2, R):-
    append(Y, [X], L),
    host_fixer(Xs, L, Temp, Temp2 ,R),!.
