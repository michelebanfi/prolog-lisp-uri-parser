;(format nil "~{~A~}" '(A B C))
;(uri-parse "https://michele@disco.unimib:8080/folder/b?search=ciao#frag")

;scheme - fragment - query - path - user - host - port

(defun uri-parse (uri)
  (return_scheme (coerce uri 'list) NIL NIL)
)

(defun return_scheme(x y z)
  (if(equal (car x) #\:) 
      (return_fragment (reverse-list (cdr (cdr (cdr x)))) NIL (cons (format nil "~{~A~}" (reverse-list y )) '())) 
    (return_scheme (cdr x) (cons (car x) y) NIL))
)

(defun return_fragment (x y z)
  (cond ((null x) (return_query y NIL (cons z '("-") )))
        ((equal (car x) #\#) (return_query (reverse-list (cdr x)) NIL (cons z (format nil "~{~A~}" y ))))
        (T (return_fragment (cdr x) (cons (car x) y) z))
))

(defun return_query(x y z)
  (cond ((null x) (return_authority_path (reverse-list y) NIL (cons z '("-"))))
      ((equal (car x) #\?) (return_authority_path (reverse-list y) NIL (cons z (format nil "~{~A~}" (cdr x)))))
   (T (return_query (cdr x) (cons (car x) y) z)))
)


(defun return_authority_path (x y z)
(cond((null x)(return_userinfo (reverse-list y) NIL (cons z '("-"))))
      ((equal (car x) #\/)(return_userinfo (reverse-list y) NIL (cons z (format nil "~{~A~}" (cdr x)))))
       (T (return_authority_path (cdr x) (cons (car x) y) z)))
 )

(defun return_userinfo (x y z)
(cond ((null x)(return_port (reverse-list y) NIL (cons z '("-"))))
      ((equal(car x) #\@)(return_port (cdr x) NIL (cons z (format nil "~{~A~}" (reverse-list y)))))
      (T (return_userinfo (cdr x) (cons (car x) y) z)))
)

(defun return_port (x y z)
 (cond ((null x)(return_host y NIL (cons z '("80"))))
       ((equal (car x)#\:)(return_host y NIL (cons z (format nil "~{~A~}" (cdr x) ))))
       (T (return_port (cdr x) (cons (car x) y) z)))
)

(defun return_host(x y z) 
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

(defun uri-display (x)
  (format t "Scheme:     ~S~%" (uri-scheme x))
  (format t "User info:  ~S~%" (uri-userinfo x))
  (format t "Host:       ~S~%" (uri-host x))
  (format t "Port:       ~S~%" (uri-port x))
  (format t "Path:       ~S~%" (uri-path x))
  (format t "Query:      ~S~%" (uri-query x)) 
  (format t "Fragment:   ~S~%" (uri-fragment x))
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