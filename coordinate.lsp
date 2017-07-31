(defun c:testfun( / cmvar osvar ss n en endata entype)

    (setq cmvar (getvar "cmdecho"))
    (setvar "cmdecho" 0)
    (setq osvar (getvar "osmode"))
    (setvar "osmode" 0)

    (setq ss (ssget ))
    
    (command "zoom" "e")

    (setq n 0)
    (repeat (sslength ss)
        (setq en (ssname ss n))
        (setq endata (entget en))
        (setq entype (cdr (assoc 0 endata)))
        (if (= entype "INSERT")
            (subfun en)
        )    
        (setq n (+ 1 n))
    )

    (setvar "osmode" osvar);; 绘图结束还原捕捉设置
    (setvar "cmdecho" cmvar)
)

(defun getoffset(/ result)

    (setq result (list 20 20))
)

(defun subfun( en / xobj vardata safedata inspoint refpoint offset target dirct)
    (vl-load-com)
    (setq xobj (vlax-ename->vla-object en))
    (setq vardata (vlax-get-property xobj 'InsertionPoint))
    (setq safedata (vlax-variant-value vardata))
    (setq inspoint (vlax-safearray->list safedata))

    (setq refpoint (list (car inspoint) (cadr inspoint)))
    (setq offset (getoffset))

    ;; left up point
    (setq target (list -100 100))
    (setq dirct (list 1 -1))
    (drawCoords refpoint target offset dirct)
    ;; right up point
    (setq target (list 100 100))
    (setq dirct (list -1 -1))
    (drawCoords refpoint target offset dirct)
    ;; right down point
    (setq target (list 100 -100))
    (setq dirct (list -1 1))
    (drawCoords refpoint target offset dirct)
    ;; left down point
    (setq target (list -100 -100))    
    (setq dirct (list 1 1))
    (drawCoords refpoint target offset dirct)

)

(defun drawCoords ( refpoint target offset dirct / rx ry XYZ strx stry strp dx dy XYZ2)

    (setq rx (+ (car refpoint ) (car target ) ) )
    (setq ry (+ (cadr refpoint) (cadr target) ) )
    (setq XYZ (list rx ry 0))

    (setq strx (rtos rx 2 3))
    (setq stry (rtos ry 2 3))
    (setq strp (strcat "X=" strx "\n" "Y=" stry))
    (setq dx (* (car offset ) (car dirct ) ) )
    (setq dy (* (cadr offset) (cadr dirct) ) )

    (setq XYZ2 (list (+ rx dx) (+ ry dy) 0))
    
    (command "mleader" "l" "h" "o" "A" "n" "C" "M" "X" XYZ XYZ2 strp "")

)


(defun c:pick()
    (vl-load-com)
    (setq en (car (entsel "select:")))
    (setq xobj (vlax-ename->vla-object en))
    (vlax-dump-object xobj)
)


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
