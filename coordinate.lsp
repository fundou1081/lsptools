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

    (setq AA (list 134.784 67.392 ))
    (setq u 0.8)
    (setq d 0.8)
    (setq l 0.575)
    (setq r 1.725)

    (setq x (/ (car AA) 2 ))
    (setq y (/ (cadr AA) 2 ))
    

    ;; left up point
    (setq target (list (- 0 x l) (+ y u)))
    (setq dirct "ml")
    (setq offset (list 5 -5))
    (drawCoords refpoint target offset dirct)
    ;; right up point
    (setq target (list (+ x r) (+ y u) ))
    (setq dirct "mr")
    (setq offset (list -5 -5))
    (drawCoords refpoint target offset dirct)
    ;; right down point
    (setq target (list (+ x r) (- 0 y d) ))
    (setq dirct "mr")
    (setq offset (list -5 5))
    (drawCoords refpoint target offset dirct)
    ;; left down point
    (setq target (list (- 0 x l) (- 0 y d) ))    
    (setq dirct "ml")
    (setq offset (list 5 5))
    (drawCoords refpoint target offset dirct)

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
    (while (setq pt1 (getpoint "\nselect point:"))
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



