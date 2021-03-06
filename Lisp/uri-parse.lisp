;;;; -*- Mode: Lisp -*-

;;;; Masiero Emanuele 872695 
;;;; Banfi Michele 869294

;;;; uri-parse.lisp --

;;structure: scheme - fragment - query - path - user - port - host

(defun uri-parse (uri)
  (boia-de (return_scheme (coerce uri 'list) NIL))
  )

(defun dialler (x)
  (cond ((equal (first x) "mailto")(mailto x)) 
	((equal (first x) "news")(news x))
        ((equal (first x) "tel")(telfax x))
        ((equal (first x) "fax")(telfax x))
        (T (scheme-grammar (coerce (first x) 'list) x) )
        )
  )

(defun boia-de (x) 
  (cond ((equal (fifth x) "") (error "illegal userinfo")) ;userinfo
        ((equal (second x) "") (error "illegal fragment")) ;fragment
        ((equal (third x) "") (error "illegal query")) ;query
        ((equal (fourth x) "") (error "illegal path")) ;path
        ((equal (sixth x) "") (error "illegal port")) ;port
        ((equal (last (coerce (fourth x) 'list))'(#\/))
         (error "illegal end of path with '/'")) ;path that end with /
        (T (dialler x))
        )
  )

;;scheme - NIL - NIL - NIL - user - NIL - host
(defun mailto (scheme)
  (dialler-mailto (resetter-mailto scheme))
  )

(defun dialler-mailto (scheme)
  (query-grammar (coerce (third scheme) 'list) scheme)
  )

(defun resetter-mailto (scheme)
  (cons (first scheme)
	(cons "NIL"
	      (cons "NIL"
		    (cons "NIL"
			  (cons (fifth scheme)
				(cons "NIL" (cons (seventh scheme) NIL)))))))
  )

;;scheme - NIL - NIL - NIL - NIL - NIL - host
(defun news (scheme)
  (dialler-news (resetter-news scheme))
  )

(defun dialler-news (scheme)
  (query-grammar (coerce (third scheme) 'list) scheme)
  )

(defun resetter-news (scheme)
  (cons (first scheme)
	(cons "NIL"
	      (cons "NIL"
		    (cons "NIL"
			  (cons "NIL"
				(cons "NIL"
				      (cons (seventh scheme) NIL)))))))
  )

;;scheme - NIL - NIL - NIL - host - NIL - NIL
(defun telfax (scheme)
  (dialler-telfax (resetter-telfax scheme))
  )

(defun dialler-telfax (scheme)
  (query-grammar (coerce (third scheme) 'list) scheme)
  )

(defun resetter-telfax (scheme)
  (cons (first scheme)
	(cons "NIL"
	      (cons "NIL"
		    (cons "NIL"
			  (cons (seventh scheme)
				(cons "NIL" (cons "NIL" NIL)))))))
  )

(defun scheme-grammar (scheme uri)
  (cond ((null scheme) (query-grammar (coerce (third  uri) 'list) uri))
        ( (equal (car scheme) #\/)  (error "illegal uri-scheme char found /"))
        ( (equal (car scheme) #\?)  (error "illegal uri-scheme char found ?"))
        ( (equal (car scheme) #\#)  (error "illegal uri-scheme char found #"))
        ( (equal (car scheme) #\@)  (error "illegal uri-scheme char found @"))
        ( (equal (car scheme) #\:)  (error "illegal uri-scheme char found :"))
        (T (scheme-grammar (cdr scheme) uri))
        )
  )

(defun query-grammar (query uri)
  (cond ((and (equal (first uri) "zos") (null query)) 
         (zos-path-grammar (coerce (fourth uri) 'list) '()  uri))
        ((null query) (path-grammar (coerce (fourth uri) 'list)  uri))
        ( (equal (car query) #\#) (error "illegal uri-query char"))
        (T (query-grammar (cdr query) uri)))
  )

(defun zos-path-grammar (path y uri)
  (cond ((null path) 
         (cond ((> (length y) 44)  
                (error "illegal zos id44 length"))
               ((equal (car y) #\.) 
                (error "illegal end of id44. terminated with '.'"))
               ((not (alpha-char-p 
                      (car (last y)))) 
                (error "illegal start of id44 with non alphabetic char"))
               (T (userinfo-grammar (coerce (fifth uri) 'list) uri))
               ))
        ( (equal (car path) #\( ) 
          (cond ((> (length y) 44)  (error "illegal zos id44 length"))
                ((equal (car y) #\.) 
                 (error "illegal end of id44. terminated with '.'"))
                ((not (alpha-char-p (car (last y)))) 
                 (error "illegal start of id44 with non alphabetic char"))
                (T (zos-inside-brackets (cdr path) '() y uri))
                ))
        (T (zos-path-grammar (cdr path) (cons (car path) y) uri))
        )
  )

(defun zos-inside-brackets (path y id44 uri)
  (cond ((null path)(error "illegal zos-scheme missing ')'"))
        ( (equal (car path) #\) ) 
          (cond ( (> (length y) 8) 
                  (error "illegal zos id8 length"))
                ((not (alpha-char-p (car (last y)))) 
                 (error "illegal start of id8 with non alphabetic char"))
                ((not (equal (car (last path)) #\) )) 
                 (error "illegal end of id44 path"))
                (T (userinfo-grammar (coerce (fifth uri) 'list) uri))
                ))
        (T (zos-inside-brackets (cdr path) (cons (car path) y) id44 uri))
        )
  )

(defun path-grammar (path uri)
  (cond ((null path) (userinfo-grammar (coerce (fifth uri) 'list)  uri))
        ( (equal (car path) #\?)  (error "illegal uri-path char found ?"))
        ( (equal (car path) #\#)  (error "illegal uri-path char found #"))
        ( (equal (car path) #\@)  (error "illegal uri-path char found @"))
        ( (equal (car path) #\:)  (error "illegal uri-path char found :"))
        ( (and (equal (car path) #\/) (equal (car path) (car (cdr path)) )) 
          (error "illegal uri-path char sequence //"))
        (T (path-grammar (cdr path) uri))
        )
  )

(defun userinfo-grammar (userinfo uri)
  (cond ((equal userinfo "") (error "boia"))
        ( (null userinfo) (host-grammar (coerce (seventh  uri) 'list) uri))
        ( (equal (car userinfo) #\/)  
          (error "illegal uri-userinfo char found /"))
        ( (equal (car userinfo) #\?)  
          (error "illegal uri-userinfo char found ?"))
        ( (equal (car userinfo) #\#)  
          (error "illegal uri-userinfo char found #"))
        ( (equal (car userinfo) #\@)  
          (error "illegal uri-userinfo char found @"))
        ( (equal (car userinfo) #\:)  
          (error "illegal uri-userinfo char found :"))
        (T (userinfo-grammar (cdr userinfo) uri))
        )
  )

(defun host-grammar (host uri)
  (cond ((null host) (port-grammar (sixth uri)  uri))
        ( (equal (car host) #\?)  (error "illegal uri-host char found ?"))
        ( (equal (car host) #\#)  (error "illegal uri-host char found #"))
        ( (equal (car host) #\@)  (error "illegal uri-host char found @"))
        ( (equal (car host) #\:)  (error "illegal uri-host char found :"))
        ( (equal (last host) '(#\.))  (error "illegal end of scheme"))
        ( (and (equal (car host) #\.) (equal (car host) (car (cdr host)) )) 
          (error "illegal uri-host char sequence .."))
        (T (host-grammar (cdr host) uri))
	)
  )

(defun port-grammar (port uri) 
  (cond ((numberp port) uri)
        ((equal (first uri) "mailto") uri)
        ((equal (first uri) "news") uri)
        ((equal (first uri) "fax") uri)
        ((equal (first uri) "tel") uri)
        )
  )

(defun return_scheme (x y)
  (if(equal (car x) #\:)
      (cond ((equal y '(#\o #\t #\l #\i #\a #\m)) 
             (return_fragment (reverse-list (cdr x)) 
			      NIL 
			      (cons (format nil "~{~A~}"
					    (reverse-list y )) '())))
            ((equal y '(#\s #\w #\e #\n)) 
             (return_fragment (reverse-list (cdr x)) 
			      NIL 
			      (cons (format nil "~{~A~}"
					    (reverse-list y )) '())))
            ((equal y '(#\l #\e #\t))
	     (return_fragment (reverse-list (cdr x)) 
			      NIL 
                              (cons (format nil "~{~A~}"
					    (reverse-list y )) '())))
            ((equal y '(#\x #\a #\f))
	     (return_fragment (reverse-list (cdr x)) 
			      NIL 
			      (cons (format nil "~{~A~}" 
                                            (reverse-list y )) '())))
            (T (return_fragment (reverse-list (scheme_fixer x)) 
                                NIL 
                                (cons (format nil "~{~A~}" 
                                              (reverse-list y )) '())))
            )
    (return_scheme (cdr x) (cons (car x) y)))
  )

(defun scheme_fixer(x)
  (cond ((and (equal (third x) #\/) (null (fourth x))) (error "bad host"))
        ((and (equal (second x) #\/) (null (third x))) (error "bad host"))
        (T (cdr (cdr (cdr x))))
        )
  )

(defun return_fragment (x y z)
  (cond ((null x) (return_query y NIL (cons z "NIL" )))
        ((equal (car x) #\#) (return_query 
                              (reverse-list (cdr x)) 
                              NIL 
                              (cons z (format nil "~{~A~}" y ))))
        (T (return_fragment (cdr x) (cons (car x) y) z)))
  )

(defun return_query (x y z)
  (cond ((null x) (return_authority_path 
                   (reverse-list y) 
                   NIL 
                   (cons z "NIL")))
        ((equal (car x) #\?) (return_authority_path 
                              (reverse-list y) 
                              NIL
                              (cons z (format nil "~{~A~}" (cdr x)))))
	(T (return_query (cdr x) (cons (car x) y) z)))
  ) 

(defun return_authority_path (x y z)
  (cond((null x)(return_userinfo 
                 (reverse-list y) 
                 NIL 
                 (cons z "NIL")))
       ((equal (car x) #\/)(return_userinfo 
                            (reverse-list y) 
                            NIL 
                            (cons z (format nil "~{~A~}" (cdr x)))))
       (T (return_authority_path (cdr x) (cons (car x) y) z)))
  )

(defun return_userinfo (x y z)
  (cond ((null x)(return_port 
                  (reverse-list y) 
                  NIL 
                  (cons z "NIL")))
        ((equal(car x) #\@)(return_port 
                            (cdr x) 
                            NIL 
                            (cons z (format nil "~{~A~}" (reverse-list y)))))
        (T (return_userinfo (cdr x) (cons (car x) y) z)))
  )

(defun return_port (x y z)
  (cond ((null x)(return_host 
                  y
                  (cons z '(80))))
        ((equal (car x)#\:)
         (cond ((null (cdr x))(error "illegal port"))
               (T (return_host
                   y
                   (cons z (parse-integer(format nil "~{~A~}" (cdr x))))
                   ))
               )
         )
        (T (return_port (cdr x) (cons (car x) y) z)))
  )

(defun return_host(x z) 
  (flatten (cons z (format nil "~{~A~}" (reverse-list x))))
  )


(defun uri-scheme (x)
  (first x) 
  )

(defun uri-userinfo (x)
  (fifth x)
  )

(defun uri-host (x)
  (seventh x)
  )

(defun uri-port (x)
  (sixth x) 
  )

(defun uri-path (x)
  (fourth x)
  )

(defun uri-query (x)
  (third x)
  )

(defun uri-fragment (x)
  (second x)
  )

(defun uri-display (x &optional out standard-output)
  (cond ((not (null out)) (open-stream-p out))
        ((not (null standard-output)) (output-stream-p out))
        (T (format t "Scheme:     ~A~%" (uri-scheme x))
           (format t "Userinfo:   ~A~%" (uri-userinfo x))
           (format t "Host:       ~A~%" (uri-host x))
           (format t "Port:       ~A~%" (uri-port x))
           (format t "Path:       ~A~%" (uri-path x))
           (format t "Query:      ~A~%" (uri-query x)) 
           (format t "Fragment:   ~A~%" (uri-fragment x))t)
        )
  )

(defun cons-end (element l)
  (if (null l)
      (list element)
    (cons (first l) (cons-end element (rest l)))))

(defun reverse-list (l)
  (if (null l)
      nil
    (cons-end (car l) (reverse-list (rest l)))))

(defun flatten (x)
  (cond ((null x) x)
        ((atom x) (list x))
        (T (append (flatten (first x))
                   (flatten (rest x))))))

;; remove n-th element
(defun removen (l n)
  (cond ((null l) nil)
	((= n 0) (cdr l))
	(T (cons (car l) (removen (cdr l) (- n 1))))))

;;;; end of file -- uri-parse.lisp
