(defpackage :k-regular-random-graph-generator
  (:use :common-lisp) 
  (:nicknames :cl-kreg) 
  (:export :make-random-graph
           :graph->list
           :graph->dot
           :graph->hash-table))
