%%%% -*- Mode: Prolog -*-

%%%% Masiero Emanuele 872695
%%%% Banfi Michele 869294

%%%% uri-parse.pl --

uri_parse(UriString,
          uri(Scheme, U, H, Po, Pa, Q, F)):-
    string_lower(UriString, Urilower),
    atom_chars(Urilower, X),
    return_scheme(X, [], S, Resturi),
    S \= [],
    scheme_syntax(S, Resturi, U, H, Po, Pa, Q, F),
    atom_list(S, Scheme).

boia([], []).
boia([_X | Xs], Xs).

%syntax URI1 parsing
return_scheme([':'| Xs], Y, Y, Xs) :- !.
return_scheme([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_scheme(Xs, L, S, R).

return_fragment([], Y, [], Y) :- !.
return_fragment(['#' | Xs], Y, ['#' | Frag], Xs) :-
    reverse(Y, Frag), !.
return_fragment([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_fragment(Xs, L, S, R).

return_query([], Y, [], Y) :- !.
return_query(['?' | Xs], Y, ['?' | Y], Resturi) :-
    reverse(Xs, Resturi), !.
return_query([X | Xs], Y, S, R):-
    append([X], Y, L),
    return_query(Xs, L, S, R).

return_authority_path([], Y, Y, []) :- !.
return_authority_path(['/', '/'| Au], Y, ['/', '/' | S], R):-
    return_authority_path(Au, Y, S, R).
return_authority_path(['/' | P], Y, Y, ['/' | P]) :- !.
return_authority_path([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_authority_path(Xs, L, S, R).

return_userinfo([], Y, [], Y) :- !.
return_userinfo(['/', '/', X | Xs], Y, S, R):-
    !, X \= '@',
    return_userinfo([X | Xs], Y, S, R).
return_userinfo(['@' | Xs], Y, Y, Xs) :- !.
return_userinfo([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_userinfo(Xs, L, S, R).

return_host_port([], Y, ['8', '0'], Y) :- !.
return_host_port(['/', '/' | Xs], Y, S, R):-
    return_host_port(Xs, Y, S, R).
return_host_port([':' | Xs], Y, Xs, Y) :- !.
return_host_port([X | Xs], Y, S, R):-
    append(Y, [X], L),
    return_host_port(Xs, L, S, R).

%special syntax
return_mailto_userhost([], U, U,  []).
return_mailto_userhost(['@' | Host], U, U, ['@' | Host]) :-
    !, U \= [].
return_mailto_userhost([X | Xs], Y, Userinfo, Host):-
    append(Y, [X], L),
    return_mailto_userhost(Xs, L, Userinfo, Host).

scheme_syntax([m ,a ,i ,l ,t ,o], Uri,
              Userinfo, Host, [], [], [], []):-
    !, return_mailto_userhost(Uri, [], U, H),
    H \= ['@'],
    phrase(userinfo, U), !,
    phrase(mailto_host, H), !,
    boia(H, H1),
    atom_list(U, Userinfo),
    atom_list(H1, Host).

scheme_syntax([n, e, w, s], Uri,
              [], Host, [], [], [], []):-
    !, phrase(news_host, Uri),
    atom_list(Uri, Host).

scheme_syntax([t, e, l], Uri,
              Userinfo, [], [], [], [], []):-
    !, phrase(userinfo, Uri), !,
    atom_list(Uri, Userinfo).

scheme_syntax([f, a, x], Uri,
              Userinfo, [], [], [], [], []):-
    !, phrase(userinfo, Uri), !,
    atom_list(Uri, Userinfo).

scheme_syntax([z, o, s], Uri,
              Userinfo, Host, Port, Path, Query, Fragment):-
    reverse(Uri, L1),
    return_fragment(L1, [], F, R2),
    F \= ['#'],
    return_query(R2, [], Q, R3),
    Q \= ['?'],
    return_authority_path(R3, [], Au, Pa),
    Pa \= ['/'],
    boia(Pa, Pa1),
    !, return_userinfo(Au, [], U, R4),
    return_host_port(R4, [], Po, H),
    Po \= [],
    phrase(authority, Au), !,
    phrase(zos_path, Pa1), !,
    zos_check(Pa1),
    phrase(query, Q), !,
    phrase(fragment, F),
    boia(F, F1), boia(Q, Q1),
    atom_list(U, Userinfo),
    atom_list(H, Host),
    atom_list(Po, Port),
    atom_list(Pa1, Path),
    atom_list(Q1, Query),
    atom_list(F1, Fragment), !.

scheme_syntax(Scheme, Uri,
              Userinfo, Host, Port, Path, Query, Fragment):-
    reverse(Uri, L1),
    return_fragment(L1, [], F, R2),
    F \= ['#'],
    return_query(R2, [], Q, R3),
    Q \= ['?'],
    return_authority_path(R3, [], Au, Pa),
    !, return_userinfo(Au, [], U, R4),
    return_host_port(R4, [], Po, H),
    Po \= [],
    !,
    uri_grammar(Scheme, Au, Pa, Q, F),
    boia(F, F1), boia(Q, Q1), boia(Pa, Pa1),
    atom_list(U, Userinfo),
    atom_list(H, Host),
    atom_list(Po, Port),
    atom_list(Pa1, Path),
    atom_list(Q1, Query),
    atom_list(F1, Fragment), !.

zos_check(Path):-
    zos_head(Path, Pah),
    zos_tail(Path),
    zos_length_id44(Pah, Lid44, Rest),
    zos_length_id8(Rest, Lid8),
    Lid44 =< 44,
    Lid8 =< 8.

zos_head([], []) :- !.
zos_head([X | Rest], [X | Rest]) :-
    code_type(X, alnum).

zos_tail([]).
zos_tail([X]) :- !, X \= '.'.
zos_tail([_X | Rest]) :-
    zos_tail(Rest).

zos_length_id44([], 0, []) :- !.
zos_length_id44(['(' | Id8], 0, Id8) :- !.
zos_length_id44([_X | Rest], Lid44, Id8) :-
    zos_length_id44(Rest, L, Id8),
    Lid44 is L + 1.

zos_length_id8([], 0) :- !.
zos_length_id8([')'], 0) :- !.
zos_length_id8([_X | Rest], Lid8) :-
    zos_length_id8(Rest, L),
    Lid8 is L + 1.

uri_grammar(Scheme, Authority, Path, Query, Fragment):-
    phrase(scheme, Scheme),
    phrase(authority, Authority),
    phrase(path_structure, Path),
    phrase(query, Query),
    phrase(fragment, Fragment), !.

uri_display(uri(S, U, H, Po, Pa, Q, F)):-
    write("Scheme": S),
    write("\nUserinfo": U),
    write("\nHost": H),
    write("\nPort": Po),
    write("\nPath": Pa),
    write("\nQuery": Q),
    write("\nFragment": F).

uri_display(uri(S, U, H, Po, Pa, Q, F), Stream):-
    write(Stream,"Scheme": S),
    write(Stream,"\nUserinfo": U),
    write(Stream,"\nHost": H),
    write(Stream,"\nPort": Po),
    write(Stream,"\nPath": Pa),
    write(Stream,"\nQuery": Q),
    write(Stream,"\nFragment": F),
    close(Stream).


%DCG Grammar
scheme --> identificatori.

userinfo --> identificatori.

authority --> [/, /], userinfo, ['@'], host, [':'], port.
authority --> [/, /], host, [':'], port.
authority --> [/, /], userinfo, ['@'], host.
authority --> [/, /], host.
authority --> [], !.

identificatori --> [].
identificatori --> id, identificatori.

id --> [C],
       {C \= '/',
	C \= '?',
	C \= '#',
	C \= '@',
	C \= ':'}, !.

news_host --> host, !.
news_host --> [].

mailto_host --> ['@'], host, !.
mailto_host --> [].

host --> id_host, host.
host --> id_host, ['.'], host.
host --> id_host.
host --> indirizzo_ip.

indirizzo_ip --> number, ['.'], number, ['.'],
		 number, ['.'], number, !.

number --> [D0],
	   {phrase(digit , [D0]),
	    atom_list([D0], X),
	    atom_number(X, Y),
	    Y > 0,
	    Y < 255}.
number --> [D0, D1],
	   {phrase(digit , [D0]),
            phrase(digit , [D1]),
            atom_list([D0, D1], X),
            atom_number(X, Y),
            Y > 0,
            Y < 255}.
number --> [D0, D1, D2],
	   {phrase(digit , [D0]),
	    phrase(digit , [D1]),
	    phrase(digit , [D2]),
	    atom_list([D0, D1, D2], X),
	    atom_number(X, Y),
	    Y >= 0,
	    Y =< 255}.

zos_path --> id44, zos_path.
zos_path --> id44, ['('], id8.
zos_path --> [].
id44 --> [C], {code_type(C, alpha)}.
id44 --> ['.'].
id8 --> [C], {code_type(C, alpha)}, id8.
id8 --> [C], {code_type(C, alpha)}, [')'].

path_structure --> [/], path.
path_structure --> [], !.
path --> id_path, [/], path.
path --> id_path, path.
path --> id_path.

id_host --> [C],
	    {C \= '/',
	     C \= '.',
	     C \= '?',
	     C \= '#',
	     C \= '@',
	     C \= ':'}, !.

id_path --> [C],
	    {C \= '/',
	     C \= '?',
	     C \= '#',
	     C \= '@',
	     C \= ':'}, !.

port --> digit, port.
port --> [].

digit-->[C], {C = '0'}, !.
digit-->[C], {C = '1'}, !.
digit-->[C], {C = '2'}, !.
digit-->[C], {C = '3'}, !.
digit-->[C], {C = '4'}, !.
digit-->[C], {C = '5'}, !.
digit-->[C], {C = '6'}, !.
digit-->[C], {C = '7'}, !.
digit-->[C], {C = '8'}, !.
digit-->[C], {C = '9'}, !.

query --> ['?'], query.
query --> [C],{C \= '#'}, query.
query --> [], !.

fragment --> ['#'], fragment.
fragment --> [C],{code_type(C, alnum)}, fragment.
fragment --> [], !.

atom_list([], []).
atom_list([X | Xs], R):-
    atomic_list_concat([X | Xs], R).

%%%% end of file -- uri-parse.pl --
















