;;; Panel layout
;;; haobo
;;; v2017
;;; read excel
(defun c:getpaneldata()
    (setq fileDir (getfiled "Open paneldata file" "" "xlsx" 16))    ;;; �������� Ĭ��·�� ��չ�� flag
    (setq panelV (cons (GetCellValueAsList fileDir "CADInput" "E3:E11") panelV))
    (setq panelV (cons (GetCellValueAsList fileDir "CADInput" "J3:J14") panelV))  
    (setq panelV (cons (GetCellValueAsList fileDir "CADInput" "O3:O12") panelV))
    ;;; panel Q panel Galss 
    ;;; ��ջʽ ����
	(prin1)

)

;;; panel layout
(defun c:pl(/ AH AV u d l r dpad gpad pblk) 
    
    (setq AH (vlax-variant-value (nth 0 (nth 0 (nth 2 panelV)))))
    (setq AV (vlax-variant-value (nth 0 (nth 1 (nth 2 panelV)))))
    (setq u (vlax-variant-value (nth 0 (nth 2 (nth 2 panelV)))))
    (setq d (vlax-variant-value (nth 0 (nth 3 (nth 2 panelV)))))
    (setq l (vlax-variant-value (nth 0 (nth 4 (nth 2 panelV)))))
    (setq r (vlax-variant-value (nth 0 (nth 5 (nth 2 panelV)))))
    (setq dpad (vlax-variant-value (nth 0 (nth 6 (nth 2 panelV)))))
    (setq gpad (vlax-variant-value (nth 0 (nth 7 (nth 2 panelV)))))
    (setq pblk (vlax-variant-value (nth 0 (nth 8 (nth 2 panelV)))))

    (drawLayout AH AV u d l r dpad gpad pblk)
    ;;;     AH  AV u  d   l r dpad gpad blk
    (prin1)
)

;;; Q panel layout
(defun c:ql(/ PH PV m n dm dn u d l r Isrotate)

    (setq PH (vlax-variant-value (nth 0 (nth 0 (nth 1 panelV)))))
    (setq PV (vlax-variant-value (nth 0 (nth 1 (nth 1 panelV)))))
    (setq m (vlax-variant-value (nth 0 (nth 2 (nth 1 panelV)))))
    (setq n (vlax-variant-value (nth 0 (nth 3 (nth 1 panelV)))))
    (setq u (vlax-variant-value (nth 0 (nth 4 (nth 1 panelV)))))
    (setq d (vlax-variant-value (nth 0 (nth 5 (nth 1 panelV)))))
    (setq l (vlax-variant-value (nth 0 (nth 6 (nth 1 panelV)))))
    (setq r (vlax-variant-value (nth 0 (nth 7 (nth 1 panelV)))))
    (setq dm (vlax-variant-value (nth 0 (nth 8 (nth 1 panelV)))))
    (setq dn (vlax-variant-value (nth 0 (nth 9 (nth 1 panelV)))))
    (setq Isrotate (vlax-variant-value (nth 0 (nth 10 (nth 1 panelV)))))
    (setq Isrotate (fix Isrotate))
    (setq RFQflag (vlax-variant-value (nth 0 (nth 11 (nth 1 panelV)))))
    (setq RFQflag (fix RFQflag))

    (arrayLayout PH PV m n dm dn u d l r Isrotate 0 RFQflag)
    ;;;          PH PV m n dm dn u d l r Isrotate IsG
    (prin1)
)

;;; Glass layout
(defun c:gl(/ QH QV m n dm dn u d l r )

    (setq RFQflag (vlax-variant-value (nth 0 (nth 11 (nth 1 panelV)))))
    (setq RFQflag (fix RFQflag))

    (setq QH (vlax-variant-value (nth 0 (nth 0 (nth 0 panelV)))))
    (setq QV (vlax-variant-value (nth 0 (nth 1 (nth 0 panelV)))))
    (setq m (vlax-variant-value (nth 0 (nth 2 (nth 0 panelV)))))
    (setq n (vlax-variant-value (nth 0 (nth 3 (nth 0 panelV)))))
    (setq u (vlax-variant-value (nth 0 (nth 4 (nth 0 panelV)))))
    (setq d (vlax-variant-value (nth 0 (nth 5 (nth 0 panelV)))))
    (setq l (vlax-variant-value (nth 0 (nth 6 (nth 0 panelV)))))
    (setq r (vlax-variant-value (nth 0 (nth 7 (nth 0 panelV)))))
    (setq dm (vlax-variant-value (nth 0 (nth 8 (nth 0 panelV)))))
    (setq dn (vlax-variant-value (nth 0 (nth 9 (nth 0 panelV)))))

    (arrayLayout QH QV m n dm dn u d l r 0 1 RFQflag)
    ;;;       QH   QV  m n dmdn u d l   r  Isrotate IsG
    ;;; move glass to (0 0)


    (prin1)
)

;;;=====================================================================
(defun drawLayout(AH AV u d l r dpad gpad pblk / en ss entid entdata newr mark os AA1 AA2 CF1 CF2 PNL1 PNL2 AACenter1 AACenter2 AACenter)
    ;;; AA���ߴ� H ˮƽ���� V ��ֱ����
    ;;; AA����CF �� �� �� �� �ľ��� u d l r 
    ;;; CF��panel�±ߵľ��� dpad
    (setvar "cmdecho" 0)
    (command "zoom" "e");;;��ʾ��ȫ�����ɵĿ��������
    (setq os (getvar "osmode"));;ȡ�õ�ǰ��׽����
    (setvar "osmode" 0);;�رղ�׽
    
    (setq AA1 (list l (+ dpad d)))
    (setq AA2 (list (+ l AH) (+ dpad d AV)))
    (setq CF1 (list 0 dpad))
    (setq CF2 (list (+ l AH r) (+ dpad d AV u)))
    (setq PNL1 '(0 0))
    (setq PNL2 (list (+ (car CF2) gpad) (cadr CF2)))
    

    ;;; �رջ�ͼ��׽ ����׼
    
    (command "zoom" "a")

    (command "rectang" PNL1 PNL2)
    (command "rectang" CF1 CF2)
    (command "rectang" AA1 AA2)

    ;;; ������ɫ����
    (setq en (entlast))
    (chColor en 6 )

    ;;; (setq entdata (entget (ssname (ssget) 0)))

    ;;; �����ǵ��Ԫ��
    ;;; (setq test '(1 2)) ��Ԫ��
    ;;; (setq test '(1 . 2))���Ԫ��
    ;;; (setq b (cons 5 b)) ���Ԫ��
    ;;; (setq b (cons '(5) b)) ��һ��ά��
    ;;; (cdr (assoc 90 (entget entid))) ��Ⱥ��ȡֵ

    ;;; �����б��� (62 . 5) ��Ӧ��ɫ
    ;;; ���ֶ�Ӧ˳�� byblock �� �� �� �� �� ��� �� ��Ӧ 0 1 2 3 4 5 6 7
    ;;; bylayer �����Կ�ȱ

    (setq ss (ssget "w" PNL1 PNL2 ))
    (setq AACenter1 (/ (+ (car AA1 ) (car AA2) ) 2.0))
    (setq AACenter2 (/ (+ (cadr AA1 ) (cadr AA2) ) 2.0))

    (setq AACenter (list AACenter1 AACenter2))
    (command "-block" pblk AACenter ss "");;;������ ������ ����� ͼ�μ� 
    ;;;������֮���ɾ��ԭͼ�Σ����ٴβ���Ļ�ͼ�β�����ʾ
    (command "-insert" pblk AACenter 1 1 0);;;����� ����� ����� X�������� Y�������� �Ƕ�
    ;;;�����Ϊpt��ԭλ����
    
    (setvar "osmode" os);;��ͼ������ԭ��׽����
    (command "zoom" "e")
    (prin1)
)

;;;=====================================================================

(defun arrayLayout(PH PV m n dm dn u d l r Isrotate IsG RFQflag / en os ss lupt MM NN Q1 Q2 Q2X Q2Y )

    (setvar "cmdecho" 0)
    (command "zoom" "a");;;��ʾ��ȫ�����ɵĿ��������
    (setq os (getvar "osmode"));;;ȡ�õ�ǰ��׽����
    (setvar "osmode" 0);;;�رղ�׽
    
    (if (= Isrotate 1)
        (progn

                (setq MM (+ dm PH))         ;;; �м��
                (setq NN (+ dn PV))         ;;; �м��
                ;;; ����QPanellayout
                (setq Q2X (+ l r (* n PV) (* (- n 1) dn)));;; l + r + n*PV + (n-1)*NN
                (setq Q2Y (+ u d (* m PH) (* (- m 1) dm)));;; u + d + m*PH + (m-1)*MM   
                
                (setq lupt (list 0 PV))  ;;; ѡ�����Ͻ� ��ʱ�� ��ת 90
                (setvar "angdir" 0);;;����Ϊ��ʱ��
                (command "rotate" (entlast) "" lupt 90)
                ;;; ���½ǵ��ƶ��� (l d)
                (command "move" (entlast) "" lupt '(0 0))                       
        )

        (progn
                (setq MM (+ dm PV))         ;;; �м��
                (setq NN (+ dn PH))         ;;; �м��
                ;;; ����QPanellayout
                (setq Q2X (+ l r (* n PH) (* (- n 1) dn)));;; l + r + n*PH + (n-1)*NN
                (setq Q2Y (+ u d (* m PV) (* (- m 1) dm)));;; u + d + m*PV + (m-1)*MM
        )
    )
    (prin1)

    (setq Q1 '(0 0))
    (setq Q2 (list Q2X Q2Y))

    ;;; ����ͼ��
    (setq m (fix m))
    (setq n (fix n))

    (command "zoom" "a")
    (setq ss (ssget "w" Q1 Q2))
    (command "move" ss "" '(0 0) (list l d)) ;;; ���½ǵ��ƶ��� (l d)
    (command "array" ss "" "r" m n MM NN)
    ;;; �� �� �м�� �м��



    (if (= IsG 1) 
        (progn
                ;;; �� Qpanel
                (if (= RFQflag 1)
                (progn
                    (setq Q1 '(0 0))
                    (setq Q2 '(1300 1100))
                    (command "rectang" Q1 Q2)
                )
                (progn
                    (command "rectang" Q1 Q2)
                )
                )
        
                (command "zoom" "a")
                (setq ss (ssget "w" Q1 Q2))
                (setq Q2X (- 0 (/ Q2X 2.0)))
                (setq Q2Y (- 0 (/ Q2Y 2.0)))
                (command "move" ss "" '(0 0) (list Q2X Q2Y)) ;;; �ƶ�����������
        
        )
        (progn
            (if (= RFQflag 0) 
            (progn
                (command "rectang" Q1 Q2)
                (setq en (entlast))
                (chColor en 3 )
            )
        )
    )

    (setvar "osmode" os);;;��ͼ������ԭ��׽����
    (command "zoom" "e");;;��ʾ��ȫ�����ɵĿ��������
    (prin1)
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

(defun newsubst ( newr mark shift entdata / i tmp result)
    ;;; newr Ҫ���ĵ�����
    ;;; mark �����Ի���������
    ;;; shift ����������Ư�ƾ��� �Ǹ�
    ;;; �����б�
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

(defun chgFrameColorOld( colorId markId markPrpt shift / ss entid entdata newr mark)
    ;;; the frame must be the last draw
    (setq ss (ssget "L"));;; entsel ѡ�������ƵĶ���
    (setq entid (ssname ss 0))
    (setq entdata (entget entid))
    (setq newr (cons 62 colorId));;; 5 ��Ӧ��ɫ ;;;(setq newr (cons Ⱥ�� ����ֵ))
    (setq mark (cons markId markPrpt))
    (setq entdata (newsubst newr mark shift entdata));;;�ƶ�λ
    (entmod entdata);;;���»���
)

(defun chgFrameColorOld2( colorId markId markPrpt shift / ss entid entdata newr mark)
    ;;; the frame must be the last draw
    (setq ss (ssget "L"));;; entsel ѡ�������ƵĶ���
    (setq entid (ssname ss 0))
    (chcode entid 62 5)
)

(defun chColor( en colorId / obj )
    (vl-load-com)
    (setq obj (vlax-ename->vla-object en))
    (vlax-put-property obj 'Color colorId)
)

(defun chcode( en code data / endata)
    
    (setq endata (entget (car en)))
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