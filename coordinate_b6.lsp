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


(defun subfun( en / xobj vardata safedata inspoint refpoint offset target dirct userucs AA u d l r x y)
    (vl-load-com)
    (setq xobj (vlax-ename->vla-object en))
    (setq vardata (vlax-get-property xobj 'InsertionPoint))
    (setq safedata (vlax-variant-value vardata))
    (setq inspoint (vlax-safearray->list safedata))
    (setq userucs (getvar "ucsorg"))

    (setq refpoint (list (- (car inspoint) (car userucs)) (- (cadr inspoint) (cadr userucs))))

    (setq AA (list 63.504 134.064))

    (setq x (/ (car AA) 2 ))
    (setq y (/ (cadr AA) 2 ))

    (setq p1x -0.154 p1y 0.87 )
    (setq p2x 0.56 p2y -1.65 )
    (setq p3x 0.56 p3y -3.05 )

    (setq p4x 0.56 p4y -5.839 )
    (setq p5x 0.56 p5y -4.439 )
    (setq p6x -3.993 p6y 0.5 )

    (setq p7x -22.371 p7y 0.5 )
    (setq p8x -23.372 p8y -1.305 )
    (setq p9x -26.602 p9y -4.433 )


    ;; up points
    (setq pLUx (list p1x p2x p3x))
    (setq pLUy (list p1y p2y p3y))   

    (setq pn (length pLUx))
    (setq i 0)
    (while (< i pn)
        ;; left up points
        (setq l (nth i pLUx))
        (setq u (nth i pLUy))
        (setq target (list (- 0 x l) (+ y u)))
        (setq dirct "ml")
        (setq offset (list 5 -5))
        (drawCoords refpoint target offset dirct)    

        ;; right up points
        (setq r (nth i pLUx))
        (setq u (nth i pLUy))
        (setq target (list (+ x r) (+ y u) ))
        (setq dirct "mr")
        (setq offset (list -5 -5))
        (drawCoords refpoint target offset dirct)

    )

    ;; down points
    (setq pLDx (list p4x p5x p6x p7x p8x p9x))
    (setq pLDy (list p4y p5y p6y p7y p8y p9y))   

    (setq pn (length pLDx))
    (setq i 0)
    (while (< i pn)
        ;; left down points
        (setq l (nth i pLDx))
        (setq d (nth i pLDy))
        (setq target (list (- 0 x l) (- 0 y d) ))    
        (setq dirct "ml")
        (setq offset (list 5 5))
        (drawCoords refpoint target offset dirct) 

        ;; right down points
        (setq r (nth i pLDx))
        (setq d (nth i pLDy))
        (setq target (list (+ x r) (- 0 y d) ))
        (setq dirct "mr")
        (setq offset (list -5 5))
        (drawCoords refpoint target offset dirct)

    )


)

(defun drawCoords ( refpoint target offset dirct / rx ry XYZ strx stry strp dx dy XYZ2 en obj)

    (setq rx (+ (car refpoint ) (car target ) ) )
    (setq ry (+ (cadr refpoint) (cadr target) ) )
    (setq XYZ (list rx ry 0))

    (setq dx (car offset ) ) 
    (setq dy (cadr offset)) 
    (setq XYZ2 (list (+ rx dx) (+ ry dy) 0))

    (setq strx (rtos rx 2 3))
    (setq stry (rtos ry 2 3))
    (setq strp (strcat "X=" strx "\n" "Y=" stry))

    (setq dx (car offset ) ) 
    (setq dy (cadr offset)) 
    (setq XYZ2 (list (+ rx dx) (+ ry dy) 0))

    (command "line" XYZ XYZ2 "")

    (command "mtext" XYZ2 "j" dirct XYZ2 strp "")

    ;;(command "mleader" "h" "o" "A" "n" "C" "M" "X" XYZ XYZ2 strp "")
    (setq en (entlast))
    (setq obj (vlax-ename->vla-object en))
    (vlax-put-property obj 'Height 1.0)

    (if (= dirct "mr")
        (progn
            (setq en (entlast))
            (setq obj (vlax-ename->vla-object en))
            (vlax-put-property obj 'AttachmentPoint 4)
        )
    )
)

(defun chcode( en code data / endata)
    
    (setq endata (entget en))
    (setq old (assoc code endata))
    (setq new (cons code data))
    (if (= old nil)
        (progn
            (setq endata (cons new endata))
        )
        ;;else
        (progn
            (setq endata (subst new old endata))
        )
    )

    (entmod endata)
)



(defun c:pick()
    (vl-load-com)
    (setq en (car (entsel "select:")))
    (setq obj (vlax-ename->vla-object en))
    (vlax-dump-object obj)
)


(defun c:pt()
    (setvar "cmdecho" 0)
    (while (setq pt1 (getpoint "\n请指定点位置:"))
        (setq point_x (rtos (car pt1) 2 2))
        (setq point_y (rtos (cadr pt1) 2 2))
        (setq point_z (rtos (caddr pt1) 2 2))
        (command "_text" pt1 "" "" (strcat "(" point_x "," point_y "," point_z ")"))
    )
    (setvar "cmdecho" 1)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun openExcelfile( / exlfile)

    (setq sheetName "CADInput")
    (setq cellRange "O3:O12")

    (vl-load-com)
    (setq exlfile (getfiled "Open paneldata file" "" "xlsx" 16))
    (setq exlobj  (vlax-get-or-create-object "Excel.Application"))
    (setq wbobjs (vlax-get-property exlobj "WorkBooks"))
    (setq wbobj  (vlax-invoke-method wbobjs "open" exlfile))
    (setq shobjs (vlax-get-property wbobj "Sheets"))
    (setq shobj  (vlax-get-property  shobjs "Item" sheetName))
    (setq cellobjs (vlax-get-property shobj "Range" cellRange))
    (setq cellVariants (vlax-get-property cellobjs 'Value))
    (setq cellList (vlax-safearray->list (vlax-variant-value cellVariants)))


    (vlax-invoke-method wbobj "Close" )
    (vlax-release-object exlfile)
    (setq result cellList)

)



