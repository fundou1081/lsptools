(defun c:viewdcl()

    (setq dcl_file (getfiled "Open DCL file" "" "DCL" 2))
    (princ "DCL filename:")(princ dcl_file)

    ;(load_dialog "first.dcl")加载DCL
    (setq dcl_id (load_dialog dcl_file))
    (if (< dcl_id 0) (exit))
    ;加载窗口
    (setq dia_name "first002")
    (if (not (new_dialog dia_name dcl_id))
        (exit)
    )

    ;(setq dd (start_dialog))
    ;(if (= dd 1)
    ;    (action_tile "kk" (done_dialog 2))
    ;)

    (set_tile "box1" "this is box1")
    (set_tile "box2" (itoa 1045))

    (action_tile "accept" "(setq datalist (getDcldata))(done_dialog 1)")

    (setq dd(start_dialog ))
    (cond   ((= dd 1) 
                (princ "\n OK<OK>!!!")(prin1) 
                (setq box1 (car datalist))
                (setq box2 (cadr datalist))
                (princ box1)(prin1)
                (princ (itoa box2))(prin1)
            )
            ((= dd 0) (princ "\n Cancel<Cancel>!!!"))
    )

    ;结束
    ;(unload_dialog dcl_id)

)
(defun getDcldata( / box1 box2 datalist)
    (setq box1 (get_tile "box1"))
    (princ box1)(prin1)
    (setq box2 (atoi (get_tile "box2")))
    (princ (itoa box2))(prin1)
    (setq datalist (list box1 box2 ))
)
