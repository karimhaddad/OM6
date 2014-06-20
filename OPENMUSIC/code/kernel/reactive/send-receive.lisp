
(in-package :om)

;;;=====================================
;;; SEND/RECEIVE
;;;=====================================

(defmethod! om-send ((self t) &optional (target :om))
   (let ((boxes (find-receive-boxes target)))
     (mapcar #'(lambda (b)
                 (setf (value b) self)
                 (self-notify b nil))
             boxes)))
                 
(defmethod! om-receive (targetname) :initvals '(:om) t)

(defclass OMRecieveBox (OMBoxCall) ())
(defmethod get-boxcallclass-fun ((self (eql 'om-receive))) 'OMRecieveBox)
(defmethod omNG-box-value ((self OMRecieveBox) &optional (numout 0)) (value self))
  
(defun find-boxes (type)
  (loop for win in (remove-if-not 
                    #'(lambda (w) (equal 'patcheditor (type-of (editor w))))
                    (om-get-all-windows 'editorwindow)) append
        (loop for b in (boxes (object (editor win))) 
              when (equal type (reference b))
              collect b)))

(defun find-receive-boxes (target)
  (let ((boxes (find-boxes 'om-receive)))
    (remove-if-not #'(lambda (b) (equal (value (nth 0 (inputs b))) target))
                   boxes)
    ))


