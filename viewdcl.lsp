(defun c:viewdcl()

    (if (null dcl_pt)
            (setq dcl_pt '(-1 -1)) 
    )

    (setq dcl_file (getfiled "Open DCL file" "" "DCL" 2))
    (princ "DCL filename:")(princ dcl_file)

    (setq dia_name (getstring "\nDialog name:"))
    (if (= dia_name "") (exit))

    (setq dcl_id (load_dialog dcl_file))
    (new_dialog dia_name dcl_id )
    (action_tile "accept" "(setq dcl_pt (done_dialog 1))")
    (action_tile "cancel" "(done_dialog 0)")
    (setq dd(start_dialog ))
    (cond   ((= dd 1) (princ "\n OK<OK>!!!"))
            ((= dd 0) (princ "\n Cancel<Cancel>!!!"))
    )

)