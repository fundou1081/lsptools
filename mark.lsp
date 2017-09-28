;;; mark
;;; haobo
;;; read excel

(defun c:drawmark( / cmvar osvar blkData elsSheet )

    (setq cmvar (getvar "cmdecho"))
    (setvar "cmdecho" 0)
    (setq osvar (getvar "osmode"));;ȡ�õ�ǰ��׽����
    (setvar "osmode" 0);;;;; close cmd output , it can cause wrong input 

    (setq blkData (getBlockData 2 10))
    ;;; blkname basepointX basepointY

    (setq elsSheet (getstring T "������EXCEL����������:"))(prin1)
    (setq elsArea (getElsArea))
    ;;; excel area; lx; ly 
    (setq markPoints (getExcelData elsSheet (car elsArea)))
    (drawBlock blkData elsArea markPoints)
    ;;;(drawText markPoints )


    (setvar "osmode" osvar);; ��ͼ������ԭ��׽����
    (setvar "cmdecho" cmvar)
)

(defun drawBlock(blkData elsArea markPoints /  step blkname blkbase col row px py pnum textflag xmk ymk nmk mmk cmk dmk tD)
;;; draw block
    (command "zoom" "e")

    (setq markX (cadr elsArea))
    (setq markY (caddr elsArea))
    (setq step 3)
    
    (setq blkname (car blkData))
    (setq blkbase (list (cadr blkData) (caddr blkData)))

    (setq textflag (getint "�Ƿ��������(1 to yes/0 to no):"))
    (if (= textflag 1)
        (progn 
            (setq ymk (getint "Q��λY����mark����: "))
            (setq xmk (getint "Q��λX����mark����: "))
            (setq nmk (getint "mark������: "))
            (setq mmk (getint "mark������: "))
            (setq dmk (getint "mark����Ϊ����(1) or ˫��(2) or ����(3) : "))
            (setq cmk 0)
        )
    )

    (setq col 0)
    (setq row 0)

    (while (< col markX)      ;;; the last X should not be readed, cause i+stepX, when i+3   
        (while (< row markY)

            ;;;                                 column   row      
            (setq pnum (vlax-variant-value (nth (+ col 0) (nth row (nth 0 markPoints)))))
            (setq px (vlax-variant-value (nth (+ col 1) (nth row (nth 0 markPoints)))))
            (setq py (vlax-variant-value (nth (+ col 2) (nth row (nth 0 markPoints)))))

            (setq ipoint (list px py))
            ;;(print pnum)(prin1)
            
            (if pnum
                (progn
                    
                    ;; version 2014 insert block name; insert point ; X scale; Y scale ; rotate angle
                    (command "insert" blkname (list px py) "" "" "");;;insert block name ; insert point ; block base point ( do not need in new 2014 version) ; X scale; Y scale ; rotate angle
                    (setq pnum (rtos (fix pnum) 2)) ;;;ʮ����
                    ;;; �ж����� ��Ҫ���� �ѡ���Χ����
                    (if (= textflag 1)
                    (progn
                        (setq tD (textDrc ymk xmk nmk mmk dmk cmk))
                        (insertText pnum px py tD)    
                        (setq cmk (+ cmk 1))                                        
                    )    
                    )

                )
            )
            (setq row (+ row 1))
        )
        (setq row 0)
        (setq col (+ col step))
    )

)

(defun getBlockData( s1 s2 / result ss entdata data1 data2 data3 )
    ;;;
    (prompt "��ѡ���: ")(prin1)
    (setq ss (ssget))
    (setq entdata (entget (ssname ss 0)))
    ;;;ѡ�� ѡ���ж��� ��������
    (setq data1 (cdr (assoc s1 entdata)))
    (setq data2 (car (cdr (assoc s2 entdata))))
    (setq data3 (cadr (cdr (assoc s2 entdata))))
    (setq result (list data1 data2 data3 ))
)

(defun getElsArea( / result pt1chr pt1num pt2chr pt2num area lx ly)
    ;;; get excel area

    (setq pt1chr (getstring T "������EXCEL�е�Ԫ��λ����Ϣ-����-��ĸ: "))(prin1)
    (setq pt1num (getstring T "������EXCEL�е�Ԫ��λ����Ϣ-����-����: "))
    (setq pt2chr (getstring T "������EXCEL�е�Ԫ��λ����Ϣ-����-��ĸ: "))(prin1)
    (setq pt2num (getstring T "������EXCEL�е�Ԫ��λ����Ϣ-����-����: "))
    (setq area (strcat pt1chr pt1num ":" pt2chr pt2num))
    (setq lx (+ 1 (- (ascii pt2chr) (ascii pt1chr))))
    (setq pt1num (atof pt1num))
    (setq pt2num (atof pt2num))
    (setq ly (+ 1 (- pt2num pt1num)))
    (setq result (list area lx ly))
)

(defun getExcelData( elsSheet elsArea / result fileDir elsData )
    ;;; read excel data
    (setq fileDir (getfiled "Open markdata file" "" "xlsx" 16))    ;;; ;;; �������� Ĭ��·�� ��չ�� flag
    (setq elsData (cons (GetCellValueAsList fileDir elsSheet elsArea) elsData))
    (setq result elsData)
)

(defun insertText( str ptx pty mode / pt rad dirc)
    ;;; insert text region=100
    (setq rad 25);;; ƫ�ƾ���
    (setq dirc (list (list 0 0) (list -1 1) (list 0 1) (list 1 1) (list 1 0) (list 1 -1) (list 0 -1) (list -1 -1) (list -1 0) (list 0 0) (list 0 0)));;;directions
    ;;; 0���� 1���� 2�� 3���� 4�� 5���� 6�� 7���� 8�� 9���� 10����
    (setq dirc (append dirc (list (list -2 1) (list -1 2) (list 1 2) (list 2 1) (list 2 -1) (list 1 -2) (list -1 -2) (list -2 -1) )))
    ;;;ϸ�ְ˷��� ˳ʱ��
    ;;; 11 12 13 14 15 16 17 18

    (setq ptx (+ ptx (* rad (car (nth mode dirc)))))
    (setq pty (+ pty (* rad (cadr (nth mode dirc)))))

    (setq pt (list ptx pty))

    (command "mtext" pt "j" "mc" pt str "") 
)

(defun textDrc(ymk xmk nmk mmk dmk cmk / result xgmk ygmk yall parity)
    ;;;
    ;;; 0���� 1���� 2�� 3���� 4�� 5���� 6�� 7���� 8��
    ;;; 11 12 13 14 15 16 17 18
    
    (cond 
    ((= dmk 1);;����
    (progn

    ;;; ��ż�� ��ż��
    (setq xgmk (* xmk (- nmk 1)))
    (if (= xgmk 0) (setq xgmk 1))
    (setq ygmk (* ymk (- mmk 1)))
    (if (= ygmk 0) (setq ygmk 1))
    (setq yall (* ygmk nmk ));;;



    (if (< cmk yall)            
    (progn  ;;;��
        (if (= (- ygmk 1) (/ cmk ygmk))
        (progn
            (cond ;;�Ҳ�
                ((= 0 (rem cmk ymk)) (progn (setq result 17)));;cmk % ymk =0;;�� ����
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 12)));;cmk % ymk = ymk-1;;���� ����ƫ
                (t (progn (setq result 7)));;��     ����ƫ
            )       
        )
        (progn
            (cond ;;���
                ((= 0 (rem cmk ymk)) (progn (setq result 16)));;cmk % ymk =0;;�� ����
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 13)));;cmk % ymk = ymk-1;;���� ����ƫ
                (t (progn (setq result 5)));;��     ����ƫ
            )       
        )
        )             
    )
    ;;else
    (progn  ;;;��
        (setq cmk (- cmk yall))
        (if (= (- xgmk 1) (/ cmk xgmk))
        (progn  ;; ��
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;����   ��ƫ
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; ����     ��ƫ
                (t (progn (setq result 2)));;��             ��ƫ
            )
        )
        (progn  ;; ��
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;����   ��ƫ
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; ����     ��ƫ
                (t (progn (setq result 6)));;��             ��ƫ
            )
        )               
        )                   
    )
    )    
    )
    )

    ((= dmk 2);;˫��
    (progn
    ;;; ��ż�� ��ż��
    (setq xgmk (* xmk (/ nmk dmk)))
    (if (= xgmk 0) (setq xgmk 1))
    (setq ygmk (* ymk (/ mmk dmk)))
    (if (= ygmk 0) (setq ygmk 1))
    (setq yall (* ygmk nmk ));;;

    (if (< cmk yall)            
    (progn  ;;;��
        (setq parity (/ cmk ygmk))
        (if (= 0 (rem parity 2))
        (progn  ;;ż����  ���
            (cond 
                ((= 0 (rem cmk ymk)) (progn (setq result 16)));;cmk % ymk =0;;���� ����ƫ
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 13)));;cmk % ymk = ymk-1;;���� ����ƫ
                (t (progn (setq result 5)));;��     ����ƫ
            )            
        )
        ;;else            
        (progn  ;;������   �Ҳ�
            (cond 
                ((= 0 (rem cmk ymk)) (progn (setq result 17)));;cmk % ymk =0;;���� ����ƫ
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 12)));;cmk % ymk = 0;;���� ����ƫ
                (t (progn (setq result 7)));;��     ����ƫ
            )          
        )
        )
    )
    ;;else
    (progn  ;;;��
        (setq cmk (- cmk yall))
        (setq parity (/ cmk xgmk))
        (if (= 0 (rem parity 2))
        (progn  ;;ż����
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;����   ��ƫ
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; ����     ��ƫ
                (t (progn (setq result 6)));;��             ��ƫ
            )            
        )
        ;;else            
        (progn  ;;������
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 14)));;����    ����ƫ
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 11)));;����      ����ƫ
                (t (progn (setq result 2)));;��             ��ƫ
            )          
        )
        )
    )
    )    

    ))

    ((= dmk 3);;����
    (progn

    ;;; ��ż�� ��ż��
    (setq xgmk (* xmk (+ nmk 1)))
    (setq ygmk (* ymk (+ mmk 1)))
    (setq yall (* ygmk nmk ));;;

    (if (< cmk yall)            
    (progn  ;;;��
            (cond ;;�Ҳ�
                ((= 0 (rem cmk ymk)) (progn (setq result 7)));;cmk % ymk =0;;�� ����
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 1)));;cmk % ymk = ymk-1;;���� ����ƫ
                (t (progn (setq result 8)));;     ��ƫ
            )               
    )
    ;;else
    (progn  ;;;��
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;��   ����ƫ
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; ��     ����ƫ
                (t (progn (setq result 6)));;     ��ƫ
            )             
    )
    )    
    ))
    (t
    (progn
        (setq result 0)
    ))
    )
    
    (setq result result)
)


(defun GetCellValueAsList( excelFile sheetName RangeStr / xl wbs wb shs sh  rg cs vvv nms nm  ttt result)
	(vl-load-com)
	(setq xl  (vlax-get-or-create-object "Excel.Application")) ;;;����excel�������
	(setq wbs (vlax-get-property  xl "WorkBooks")) ;;;��ȡexcel�������Ĺ��������϶���
	(setq wb  (vlax-invoke-method wbs "open"  excelFile)) ;;;�ù��������϶����ָ����excel�ļ�
	(setq shs (vlax-get-property wb "Sheets"));;;��ȡ�ղŴ򿪹������Ĺ������� 
	(setq sh  (vlax-get-property  shs "Item" sheetName));��ȡָ���Ĺ����� 
	(setq rg (vlax-get-property  sh "Range" RangeStr));;;;��ָ�����ַ�������������Χ���� 
	(setq vvv (vlax-get-property rg 'Value));;;��ȡ��Χ�����ֵ
	(setq ttt (vlax-safearray->list (vlax-variant-value vvv))) ;;;ת��Ϊlist
	(vlax-invoke-method wb "Close" );;;�رչ�����
	;;(vlax-invoke-method  xl "Quit");;;�˳�excel����       ��ر�����excel ����
	(vlax-release-object xl);;;�ͷ�excel����
	(setq result ttt)  ;;; panelV Ϊȫ�ֱ���
    ;;(vlax-variant-value (nth 3 (nth 0 panelV)))
)