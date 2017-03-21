(asdf:defsystem #:cl-kreg
  :name "cl-kreg"
  :author "Soós Péter Levente"
  :license "MIT/X11"
  :description "Generate random regular graphs with k edges and n nodes."

  :components ((:file "package")
               (:file "cl-kreg" :depends-on ("package"))))
