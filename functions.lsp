;;;选择对象
(setq en1 (entsel ))
(setq en1_data (entget (car en1)))


;;;更改属性 
;;; newr 要更改的属性
;;; mark 旧属性或相邻属性
;;; shift 与相邻属性漂移距离 非负
;;; 属性列表
(defun newsubst ( newr mark shift entdata / i tmp result)
    ;;; newr 要更改的属性
    ;;; mark 旧属性或相邻属性
    ;;; shift 与相邻属性漂移距离 非负
    ;;; 属性列表
    (setq tmp (car entdata));;;get the first property
    (if (= shift 0) 
        (progn 
            (setq entdata (subst newr mark entdata))
            (setq tmp (not tmp)) 
        )
    )
    
    (while tmp
        (if (= (car mark) (car tmp))  
            (progn
                (setq i 0)
                (while (< i shift) 
                    
                    (setq savedata (cons tmp savedata));;; save mark - dst property
                    (setq entdata (cdr entdata));;; delete first property   
                    (setq tmp (car entdata))
                    (setq i (+ 1 i))
                )

                (setq entdata (cons newr entdata));;; write new property
                
                (setq tmp (car savedata))
                (while tmp
                    (setq entdata (cons tmp entdata))
                    (setq savedata (cdr savedata))
                    (setq tmp (car savedata))
                )
                (setq shift 0)
            )
        )

        (if (> shift 0)
            (progn
                (setq savedata (cons tmp savedata));;; save current property
                (setq entdata (cdr entdata));;; delete first property
                (setq tmp (car entdata));;;get new first property
            )
        )

    )

    (setq result entdata)
)

;;; 更改属性
;;; 
(setq en1 (entsel ))
(setq en1_data (entget (car en1)))
(setq oldr (assoc 40 en1_data))
(setq newr (cons 40 23.8))
(setq en1_data (subst newr oldr en1_data))
(entmod en1_data)

;;;默认 Bylayer
;;; 添加属性
(setq d3 (assoc 62 e3))
;;;若不存在 assoc 返回 nil
(setq d4 (cons 62 4))
(setq e3 (cons d4 e3));;; 把属性添加进列表
(entmod e3);;; 数据元素位置被自动调整


;;;设置为bylayer
;;;逐个取走，重新组合成不包含属性的元素



;;;循环
(while (/= en nil))

;;;只选择圆
(setq ss4 (ssget "X" '( (0 . "CIRCLE")))) 