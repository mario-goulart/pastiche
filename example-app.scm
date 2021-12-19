(include "pastiche.scm")
(import pastiche)
(import awful srfi-1)

(define (captcha-api)
  ;; This is an example on how to use the captcha API.
  (let ((web-eggs '("awful" "pastiche" "spiffy" "uri-common" "uri-generic")))
    (lambda (message)
      (case message
        ((render) `(("Name of a CHICKEN egg for web development: "
                     `(input (@ (type "text")
                                (name "captcha-user-answer")
                                (maxlength 30))))))
        ((valid?) (member ($ 'captcha-user-answer) web-eggs string-ci=?))
        ((consume! define-pages) (void))
        (else (error 'captcha-api "Invalid message" message))))))

(pastiche "/" "paste.db"
          captcha-api: (captcha-api)
          awful-settings:
          (lambda (handler)
            (parameterize
                ((debug-file "/tmp/paste")
                 (page-css "chicken.css")
                 (page-doctype "<!DOCTYPE html>")
                 (page-charset "UTF-8"))
              (handler))))
