(defpackage #:rakugobot-utils/jyoseki
  (:use #:cl)
  (:import-from #:assoc-utils
                #:aget)
  (:export #:normalize-hall-name
           #:jyoseki-time
           #:hall-address))
(in-package #:rakugobot-utils/jyoseki)

(defparameter *jyoseki-name-candidates*
  (let ((map (make-hash-table :test 'equal)))
    (loop for (name . candidates)
          in '(("鈴本演芸場" . ("鈴本" "上野鈴本" "上野鈴本演芸場"))
               ("新宿末廣亭" . ("新宿末広亭" "末広亭" "末廣亭" "末広" "末廣"))
               ("浅草演芸ホール" . ("浅草演芸場"))
               ("池袋演芸場" . ())
               ("国立演芸場" . ())
               ("黒門亭" . ()))
          do
             (setf (gethash name map) name)
             (dolist (candidate candidates)
               (setf (gethash candidate map) name)))
    map))

(defparameter *jyoseki-time*
  '(("鈴本演芸場" . (("12:30" . "16:30")
                     ("17:30" . "20:40")))
    ("新宿末廣亭" . (("12:00" . "16:30")
                     ("17:00" . "21:00")))
    ("浅草演芸ホール" . (("11:40" . "16:30")
                         ("16:40" . "21:00")))
    ("池袋演芸場" . (("12:30" . "16:30")
                     ("16:45" . "20:30")))
    ("国立演芸場" . (("12:45" . "16:00")
                     ("17:45" . "21:00")))
    ("黒門亭" . (("12:00" . "13:30")
                 ("14:30" . "16:00")))))

(defvar *hall-addresses*
  '(("鈴本演芸場" . "東京都台東区上野2-7-12")
    ("新宿末廣亭" . "東京都新宿区新宿3-6-12")
    ("池袋演芸場" . "東京都豊島区西池袋1丁目23-1 エルクルーセ")
    ("浅草演芸ホール" . "東京都台東区浅草1-43-12")
    ("国立演芸場" . "東京都千代田区隼町4-1")
    ("黒門亭" . "東京都台東区上野1-9-5")))

(defun normalize-hall-name (hall-name)
  (or (gethash hall-name *jyoseki-name-candidates*)
      (error "Invalid hall name: ~A" hall-name)))

(defun jyoseki-time (hall-name n)
  (let ((hall-name (normalize-hall-name hall-name)))
    (let ((time (aget *jyoseki-time* hall-name)))
      (unless time
        (error "Invalid hall name: ~A" hall-name))
      (let ((times (nth n time)))
        (values (car times)
                (cdr times))))))

(defun hall-address (hall-name)
  (or (aget *hall-addresses* hall-name)
      (error "Invalid hall name: ~A" hall-name)))
