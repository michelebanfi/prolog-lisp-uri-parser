uri_parse --> uri, call(_URI).

uri --> scheme, ':', authorithy, ['/', [path], ['?', query], ['#', fragment]];
        scheme, ':', ['/'], [path], ['?', query], ['#', fragment];
        scheme, ':', scheme_syntax.


scheme --> identificatore.

authorithy --> '//', [userinfo, '@' ], host, [':', port].

userinfo --> identificatore.

host --> identificatore_host, ['.', identificatore_host].

port --> digit.

indirizzo_IP --> digit, digit, digit, '.', digit, digit, digit, '.',
                 digit, digit, digit, '.', digit, digit, digit.

path --> identificatore, ['/', identificatore].

query --> {char(_C)\= '#'}.

fragment --> char(_C).

identificatore --> {char(C) \= '/'}, {char(C) \= '?'}, {char(C) \= '@'},
                   {char(C) \= ':'}, query.

identificatore_host --> char(_C \= '.'), identificatore.

digit --> '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'.

scheme_syntax --> userinfo, ['@', host].

scheme_syntax --> host.

scheme_syntax --> userinfo.




