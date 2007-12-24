(cl:defpackage #:teepeedee2.system
  (:use #:cl))
(in-package #:teepeedee2.system)

(loop for addon in (directory "addons/*/") do
      (pushnew addon asdf:*central-registry* :test #'equal))

(asdf:defsystem :teepeedee2
  :name "teepeedee2"
  :author "John Fremlin <john@fremlin.org>"
  :version "prerelease"
  :description "Multiprotocol fast networking framework"

  :components (
	       (:module :src
			:components (
				     (:file "packages")
				     (:module :lib
					      :depends-on ("packages")
					      :components (
							    (:file "macros" :depends-on ("once-only" "one-liners")) 
							    (:file "once-only")
							    (:file "one-liners")
							    (:file "utils" :depends-on ("macros" "once-only" "byte-vector"))
							    (:file "strcat" :depends-on ("macros" "utils"))
							    (:file "my" :depends-on ("macros" "once-only" "strcat" "one-liners"))
							    (:file "byte-vector" :depends-on ("macros"))
							    (:file "regex" :depends-on ("byte-vector"  "callcc"))
							    (:file "callcc")))
				     
				     (:module :io
					       :depends-on (:lib)
					       :components (
							    (:file "peer-info")
							    (:file "socket")
							    (:file "recvbuf" :depends-on ("posix-socket"))
							    (:file "sendbuf" :depends-on ("posix-socket"))
							    (:file "posix-socket" :depends-on ("syscalls" "socket"))
							    (:file "con" :depends-on ("peer-info" "sendbuf" "recvbuf"))
							    (:file "mux" :depends-on ("con"))
							    (:file "epoll" :depends-on ("syscalls" "mux"))
							    (:file "syscalls")
							    (:file "protocol" :depends-on ("socket"))))

				     (:module :http
					      :depends-on (:lib :io)
					      :components (
							   (:file "encoding")
							   (:file "headers")
							   (:file "serve" :depends-on ("encoding" "headers"))
							   (:file "request" :depends-on ("headers"))))))

	       (:module :t 
			:depends-on (:src)
			:components (
				     (:file "suite")
				     (:file "io" :depends-on ("suite"))
				     (:file "regex" :depends-on ("suite")))))
  :depends-on (
	       #+sbcl :babel
		      :trivial-garbage
		      :cl-cont
		      :cffi
		      :iterate
		      :fiveam
		      :parenscript
		      :cl-utilities))
