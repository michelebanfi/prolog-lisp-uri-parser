;(format nil "~{~A~}" '(A B C))
;(uri-parse "https://michele@disco.unimib:8080/folder/b?search=ciao#frag")
(defun uri-parse (uri)
  (return_scheme (coerce uri 'list) NIL NIL)
)

(defun return_scheme(x y z)
  (if(equal (car x) #\:) 
      (return_fragment (reverse-list (cdr (cdr (cdr x)))) NIL (cons (format nil "~{~A~}" (reverse-list y )) '())) ;(("https")) 
    (return_scheme (cdr x) (cons (car x) y) NIL)))

(defun return_fragment(x y z)
  (if(equal (car x) #\#)
      (return_query (cdr x) NIL (cons z (format nil "~{~A~}"  y)))
    (return_fragment (cdr x) (cons (car x) y) z)))

(defun return_query(x y z)
  (if(equal (car x) #\?)
      (return_authority_path (reverse-list (cdr x)) NIL (cons z (format nil "~{~A~}"  y)))
    (return_query (cdr x) (cons (car x) y) z)))

(defun return_authority_path (x y z)
  (if(equal (car x) #\/)
      (return_userinfo (reverse-list y) NIL (cons z (format nil "~{~A~}" (cdr x))))
    (return_authority_path (cdr x) (cons (car x) y) z)))

(defun return_userinfo (x y z)
  (if(equal (car x) #\@)
      (return_host (cdr x) NIL (cons z (format nil "~{~A~}" (reverse-list y))) )
   (return_userinfo (cdr x) (cons (car x) y) z)))

(defun return_host (x y z)
  (if(equal (car x) #\:)
      (return_port (cdr x) NIL (cons z (format nil "~{~A~}" (reverse-list y))))
    (return_host (cdr x) (cons (car x) y) z)))

(defun return_port(x y z)
  (flatten (cons z (format nil "~{~A~}" x)))
)


(defun uri-scheme (x))

(defun uri-userinfo (x))

(defun uri-host (x))

(defun uri-port (x))

(defun uri-path (x))

(defun uri-query (x))

(defun uri-fragment (x))

(defun uri-display (x))

;; cons-end 
(defun cons-end (element l)
  (if (null l)
      (list element)
    (cons (first l) (cons-end element (rest l)))))

;; reverse a list
(defun reverse-list (l)
  (if (null l)
      nil
    (cons-end (car l) (reverse-list (rest l)))))


(defun flatten (x)
  (cond ((null x) x)
        ((atom x) (list x))
        (T (append (flatten (first x))
                   (flatten (rest x))))))