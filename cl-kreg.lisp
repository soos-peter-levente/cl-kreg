(in-package :k-regular-random-graph-generator)

(defstruct (g (:constructor %make-graph (k n)))
  (edges k :type integer)
  (nodes n :type integer)
  (node-k (make-array n :element-type 'integer :initial-element 0))
  (matrix (make-array (list n n) :element-type 'bit :initial-element 0)))

(defun make-random-graph (&optional (k 3) (n 20))
  (let ((n (if (evenp (* n k)) n (1+ n))))
    (loop for random-graph = (%make-graph k n)
       until (well-formed-p (generate-edges random-graph))
       :finally (return random-graph))))

(defun generate-edges (graph)
  (flet ((connect-nodes (a b)
           (setf (aref (g-matrix graph) a b) 1
                 (aref (g-matrix graph) b a) 1)
           (incf (aref (g-node-k graph) a))
           (incf (aref (g-node-k graph) b))))
    (declare (inline generate-edges))
    (let (random-node)
      (dotimes (node (g-nodes graph) graph)
        (loop while (and (< (aref (g-node-k graph) node) (g-edges graph))
                         (setf random-node (get-random-node node graph)))
           do (connect-nodes node random-node))))))

(defun get-random-node (node graph)
  (let ((nodes (loop for i from node to (1- (g-nodes graph))
                  for value = (aref (g-node-k graph) i)
                  when (and (/= i node) (/= value (g-edges graph))
                            (not (= (aref (g-matrix graph) node i)
                                    (aref (g-matrix graph) i node) 1)))
                  collect i)))
    (when nodes
      (nth (random (length nodes)) nodes))))

(defun well-formed-p (graph) 
  (every #'(lambda (v) (= v (g-edges graph))) (g-node-k graph)))

(defun graph->hash-table (graph)
  (let ((graph-hash-table (make-hash-table :test #'equal)))
    (loop for i from 0 to #1=(1- (g-nodes graph))
       do (setf (gethash i graph-hash-table)
                (loop for j from 0 to #1#
                   when (= 1 (aref (g-matrix graph) i j))
                   collect j))
         :finally (return graph-hash-table))))

(defun graph->list (graph)
  (loop for i from 0 to #1=(1- (g-nodes graph))
     collect (loop for j from 0 to #1#
                when (= 1 (aref (g-matrix graph) i j))
                collect j)))

(defun graph->dot (graph &optional (oname "testgraph.dot"))
  (let ((data (graph->list graph)))
    (with-open-file (o oname :direction :output :if-exists :supersede)
      (format o "graph random {~%graph [splines=true overlap=scale]~%")
      (loop for node in data
         for i from 0 to (length data)
         do (format o "~a [label=\"~a\"];~%" i i)
           (loop for edge in node
              do (format o "~a--~a;~%" i edge)))
      (format o "}"))))
