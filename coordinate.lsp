(defun c:pick()
    (vl-load-com)
    (setq en (car (entsel "select:")))
    (setq xobj (vlax-ename->vla-object en))
    (vlax-dump-object xobj)
)

;;(vla-put

(defun c:drawXY()

    ;; get current coordinate
    
    (setq XYZ (getpoint "select point: "))
    (setq rx (car XYZ))
    (setq ry (cadr XYZ))
    (setq strx (rtos rx 2 3))
    (setq stry (rtos ry 2 3))
    (setq strp (strcat "X=" strx "\n" "Y=" stry))
    (setq dx 5)
    (setq dy 5)
    (setq XYZ2 (list (+ rx dx) (+ ry dy) 0))
    
    (command "mleader" "l" "h" "o" "A" "n" "C" "M" "X" XYZ XYZ2 strp "")

)

(defun testfun()
    (setq ss (ssget "select b"))
    
    (setq n 0)
    (repeat (sslength ss)
        (setq en (ssname ss n))
        (setq endata (entget en))
        (setq entype (cdr (assoc 0 endata)))
        (if (= entype "CIRCLE")
            (sub_fun)
        )    
        (setq n (+ 1 n))
    
    )

)
(defun subfun()
    (setq 40_list (assoc 40 entdata))
    (setq new_40_list (cons 40 new_rad))
    (setq endata (subdata new_40_list 40_list endata))
    (entmod endata)
)


(defun c:pt()
  (setvar "cmdecho" 0)
  (while (setq pt1 (getpoint "\n请指定点位置:"))
    (setq point_x (rtos (car pt1) 2 2))
    (setq point_y (rtos (cadr pt1) 2 2))
    (setq point_z (rtos (caddr pt1) 2 2))
    (command "_text" pt1 "" "" (strcat "(" point_x "," point_y "," point_z ")"))
    )
    (princ)
)



(defun acadinfo()
     (vl-load-com)
     (setq acadobj (vlax-get-acad-object))
     (setq dwgobj (vla-get-ActiveDocument acadobj))
     (setq mspace (vla-get-ModelSpace dwgobj))
)

(defun addDimstyles()
    (vl-load-com)
    (setq acadobj (vlax-get-acad-object))
    (setq dwgobj (vla-get-ActiveDocument acadobj))
    (setq dimstylesobj (vla-get-dimstyles dwgobj))
)


(defun addLayouts())
(defun addLinetypes())
(defun addTextStyles())


(defun chactDimstyle())
(defun chactLayer())
(defun chactLayout())
(defun chactLinetype())
(defun chactMaterial())
(defun chactPviewport())
(defun chactSelectionset())
(defun chactSpace())
(defun chactTextstyle())
(defun chactUCS())
(defun chactViewport())
