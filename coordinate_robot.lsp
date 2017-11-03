;;; code by haoobo from B1 PNL MASK 2
;;; more tools in github https://github.com/fundou1081/lsptools
;;; 2017.11.3
;;; 126453

(defun c:drawseal( / cmvar osvar ss n en endata entype dataList)

    (setq cmvar (getvar "cmdecho"))
    (setvar "cmdecho" 0)
    (setq osvar (getvar "osmode")).
    (setvar "osmode" 0)

    (setq ss (ssget))
    
    (command "zoom" "e")

    (setq dataList (readData))

    (setq n 0)
    (repeat (sslength ss)
        (setq en (ssname ss n))
        (setq endata (entget en))
        (setq entype (cdr (assoc 0 endata)))
        (if (= entype "INSERT")
            (subfun en dataList)
        )    
        (setq n (+ 1 n))
    )
    (command "zoom" "e")
    (setvar "osmode" osvar);; 绘图结束还原捕捉设置
    (setvar "cmdecho" cmvar)
)


(defun subfun( en dataList / xobj vardata safedata inspoint userucs refpoint fontSize fontColor coords AAX AAY x y i px py pangle pdist target angle offset angleP1 angleP2 dirct)
    (vl-load-com)
    (setq xobj (vlax-ename->vla-object en))
    (setq vardata (vlax-get-property xobj 'InsertionPoint))
    (setq safedata (vlax-variant-value vardata))
    (setq inspoint (vlax-safearray->list safedata))
    (setq userucs (getvar "ucsorg"))

    (setq refpoint (list (- (car inspoint) (car userucs)) (- (cadr inspoint) (cadr userucs))))
    
    (setq fontSize (nth 0 (nth 0 dataList)))
    (setq fontColor (nth 1 (nth 0 dataList)))
    (setq coords (nth 2 (nth 0 dataList)))
    (setq AAX (nth 3 (nth 0 dataList)))
    (setq AAY (nth 4 (nth 0 dataList)))

    (setq x (/ AAX 2 ))
    (setq y (/ AAY 2 ))

    (setq i 1)
    (while (<= i coords)

        (setq px (nth 0 (nth i dataList)))
        (setq py (nth 1 (nth i dataList)))
        (setq pangle (nth 2 (nth i dataList)))
        (setq pdist (nth 3 (nth i dataList)))

        (setq target (list px py 0))
        (setq angle (angtof (rtos pangle 2 6)))
        (setq offset (polar '(0 0 0) angle pdist))

        (setq angleP1 (angtof "90"))
        (setq angleP2 (angtof "270"))
        (if (and (>= angle angleP1) (< angle angleP2))
            (setq dirct "mr")
            ;else
            (setq dirct "ml")
        )
    
        (drawCoords fontSize fontColor refpoint target offset dirct)  
        (setq i (+ i 1))
    )
)

(defun drawCoords ( fontSize fontColor refpoint target offset dirct / osColor rx ry XYZ strx stry strp dx dy XYZ2 en obj)
    
    (vl-load-com)
    (setq osColor (getvar "Cecolor"))

    (setq rx (+ (car refpoint ) (car target ) ) )
    (setq ry (+ (cadr refpoint) (cadr target) ) )
    (setq XYZ (list rx ry 0))

    (setq strx (rtos rx 2 3)); Decimal   precision 
    (setq stry (rtos ry 2 3))
    (setq strp (strcat "X=" strx "\r\n" "Y=" stry))

    (setq dx (car offset)) 
    (setq dy (cadr offset)) 
    (setq XYZ2 (list (+ rx dx) (+ ry dy) 0))

    (command "line" XYZ XYZ2 "")
    (setq en (entlast))
    (setq obj (vlax-ename->vla-object en))
    (vlax-put-property obj 'Color fontColor)

    (setvar "cecolor" (itoa (fix fontColor)))
    (command "mtext" XYZ2 "j" dirct XYZ2 strp "")

    (setq en (entlast))
    (setq obj (vlax-ename->vla-object en))
    (vlax-put-property obj 'Height fontSize)

    (setvar "cecolor" osColor)
)

(defun chcode( en code data / endata old new)
    
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

(defun c:pick( / en obj)
    (vl-load-com)
    (setq en (car (entsel "select:")))
    (setq obj (vlax-ename->vla-object en))
    (vlax-dump-object obj)
)

(defun c:pt( / pt1 point_x point_y point_z)
    (setvar "cmdecho" 0)
    (while (setq pt1 (getpoint "\n请指定点位置:"))
        (setq point_x (rtos (car pt1) 2 2))
        (setq point_y (rtos (cadr pt1) 2 2))
        (setq point_z (rtos (caddr pt1) 2 2))
        (command "_text" pt1 "" "" (strcat "(" point_x "," point_y "," point_z ")"))
    )
    (setvar "cmdecho" 1)
)

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

(defun readData( / result sheetName XLobj wbobj sheetobj sheet cells fontsize fontColor coords AAX AAY coordsList coordi )
    ;;cfg
    (setq sheetName "SealData")
    ;;open excel
    (vl-load-com)
	(setq XLobj (vlax-create-object "Excel.Application"));
	(vla-put-visible XLobj 0);
	(setq wbobj (vlax-invoke-method (vlax-get-property XLobj "WorkBooks") "Open" (getfiled "Open Excel file" "" "xlsx" 20)));
	(setq sheetobj (vlax-get-property wbobj "Sheets"))
	(setq sheet  (vlax-get-property  sheetobj "Item" sheetName))
	(setq cells (vlax-get-property  sheet "Cells"))

    ;;异形屏幕参数设置
    (setq fontsize (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" 3 8)) "Value")));;字体大小
    (setq fontColor (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" 4 8)) "Value")));;字体颜色
    (setq coords (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" 5 8)) "Value")));;坐标个数
    (setq AAX (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" 8 8)) "Value")));;AA X 尺寸
    (setq AAY (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" 9 8)) "Value")));;AA Y 尺寸

    (setq coordsList (list (list fontsize fontColor coords AAX AAY)))
    (setq coords (fix coords))
    (setq coordi 0)
    (while (< coordi coords)
        (setq coordsList (append coordsList (list (readCoorData cells coordi))))
        (setq coordi (+ coordi 1))
    )

    ;;close Excel
    (vlax-invoke-method wbobj "Close" )
    (vlax-release-object XLobj)
    ;;return 
    (setq result coordsList)
)

(defun readCoorData( cells n / result i px py shiftAngle shiftDist)
    ;; start at 13 8
    ;; data = X Y angle dist
    ;;        8 9   11    12
    (setq i (+ 13 n))
    (setq px (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" i 8)) "Value")));; X
    (setq py (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" i 9)) "Value")));; Y
    (setq shiftAngle (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" i 11)) "Value")));; angle
    (setq shiftDist (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property  cells "Item" i 12)) "Value")));; shift
    (setq result (list px py shiftAngle shiftDist))
)


