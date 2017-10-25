;;; Panel layout
;;; haobo
;;; v2017
;;; read excel
(defun c:getpaneldata()
    (setq fileDir (getfiled "Open paneldata file" "" "xlsx" 16))    ;;; 窗口名称 默认路径 扩展名 flag
    (setq panelV (cons (GetCellValueAsList fileDir "CADInput" "E3:E11") panelV))
    (setq panelV (cons (GetCellValueAsList fileDir "CADInput" "J3:J14") panelV))  
    (setq panelV (cons (GetCellValueAsList fileDir "CADInput" "O3:O12") panelV))
    ;;; panel Q panel Galss 
    ;;; 堆栈式 逆序
	(prin1)

)

;;; panel layout
(defun c:pl( / AH AV u d l r dpad gpad pblk) 
    
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
    ;;;         AH AV u d l r dpad gpad blk
    (prin1)
)

;;; Q panel layout
(defun c:ql( / PH PV m n dm dn u d l r Isrotate)

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
(defun c:gl( / QH QV m n dm dn u d l r )

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
(defun drawLayout( AH AV u d l r dpad gpad pblk / en ss os osColor AA1 AA2 CF1 CF2 PNL1 PNL2 AACenter1 AACenter2 AACenter)
    ;;; AA区尺寸 H 水平方向 V 竖直方向
    ;;; AA区到CF 上 下 左 右 的距离 u d l r 
    ;;; CF到panel下边的距离 dpad
    (setvar "cmdecho" 0)
    (command "zoom" "e");;;显示不全，生成的块会有问题
    (setq os (getvar "osmode"));;取得当前捕捉设置
    (setvar "osmode" 0);;关闭捕捉
    (setq osColor (getvar "Cecolor"))
    
    (setq AA1 (list l (+ dpad d)))
    (setq AA2 (list (+ l AH) (+ dpad d AV)))
    (setq CF1 (list 0 dpad))
    (setq CF2 (list (+ l AH r) (+ dpad d AV u)))
    (setq PNL1 '(0 0))
    (setq PNL2 (list (+ (car CF2) gpad) (cadr CF2)))
    

    ;;; 关闭画图捕捉 否则不准 配置颜色
    
    (setvar "cecolor" "bylayer")
    (command "zoom" "a")
    (command "rectang" PNL1 PNL2)
    (command "rectang" CF1 CF2)
    (setvar "cecolor" "5"); color blue
    (command "rectang" AA1 AA2)
    

    (setq ss (ssget "w" PNL1 PNL2 ))
    (setq AACenter1 (/ (+ (car AA1 ) (car AA2) ) 2.0))
    (setq AACenter2 (/ (+ (cadr AA1 ) (cadr AA2) ) 2.0))
    (setq AACenter (list AACenter1 AACenter2))
    (command "-block" pblk AACenter ss "");;;创建块 块名称 块基点 图形集 
    ;;;创建块之后会删除原图形，不再次插入的话图形不在显示
    (command "-insert" pblk AACenter 1 1 0 "");;;插入块 插入点 块基点 X比例因子 Y比例因子 角度
    ;;;插入点为pt，原位插入
    
    (setvar "cecolor" osColor)
    (setvar "osmode" os);;绘图结束还原捕捉设置
    (command "zoom" "e")
    (prin1)
)

;;;=====================================================================

(defun arrayLayout(PH PV m n dm dn u d l r Isrotate IsG RFQflag / en os osColor ss lupt MM NN Q1 Q2 Q2X Q2Y )

    (setvar "cmdecho" 0)
    (command "zoom" "a");;;显示不全，生成的块会有问题
    (setq os (getvar "osmode"));;;取得当前捕捉设置
    (setvar "osmode" 0);;;关闭捕捉
    (setq osColor (getvar "Cecolor"))
    
    (if (= Isrotate 1)
        (progn
                (setq MM (+ dm PH))         ;;; 行间距
                (setq NN (+ dn PV))         ;;; 列间距
                ;;; 计算QPanellayout
                (setq Q2X (+ l r (* n PV) (* (- n 1) dn)));;; l + r + n*PV + (n-1)*NN
                (setq Q2Y (+ u d (* m PH) (* (- m 1) dm)));;; u + d + m*PH + (m-1)*MM   
                
                (setq lupt (list 0 PV))  ;;; 选择左上角 逆时针 旋转 90
                (setvar "angdir" 0);;;设置为逆时针
                (command "rotate" (entlast) "" lupt 90)
                ;;; 左下角点移动到 (l d)
                (command "move" (entlast) "" lupt '(0 0))                       
        )

        (progn
                (setq MM (+ dm PV))         ;;; 行间距
                (setq NN (+ dn PH))         ;;; 列间距
                ;;; 计算QPanellayout
                (setq Q2X (+ l r (* n PH) (* (- n 1) dn)));;; l + r + n*PH + (n-1)*NN
                (setq Q2Y (+ u d (* m PV) (* (- m 1) dm)));;; u + d + m*PV + (m-1)*MM
        )
    )
    (prin1)

    (setq Q1 '(0 0))
    (setq Q2 (list Q2X Q2Y))

    ;;; 阵列图形
    (setq m (fix m))
    (setq n (fix n))

    (command "zoom" "a")
    (setq ss (ssget "w" Q1 Q2))
    (command "move" ss "" '(0 0) (list l d)) ;;; 左下角点移动到 (l d)
    (command "array" ss "" "r" m n MM NN)
    ;;; 行 列 行间距 列间距

    (if (= IsG 1) 
        (progn
            ;;; 画 Qpanel
            (if (= RFQflag 1)
                (progn
                    (setq Q1 '(0 0))
                    (setq Q2 '(1300 1100))
                    (setvar "cecolor" "bylayer")
                    (command "rectang" Q1 Q2)
                )
                (progn
                    (setvar "cecolor" "bylayer")
                    (command "rectang" Q1 Q2)
                )
            )
    
            (command "zoom" "a")
            (setq ss (ssget "w" Q1 Q2))
            (setq Q2X (- 0 (/ Q2X 2.0)))
            (setq Q2Y (- 0 (/ Q2Y 2.0)))
            (command "move" ss "" '(0 0) (list Q2X Q2Y)) ;;; 移动到坐标中心
        
        )
        (progn
            (if (= RFQflag 0) 
                (progn    
                    (setvar "cecolor" "3"); color green
                    (command "rectang" Q1 Q2)
                )
            )
        )
    )
    (setvar "cecolor" osColor)
    (setvar "osmode" os);;;绘图结束还原捕捉设置
    (command "zoom" "e");;;显示不全，生成的块会有问题
    (prin1)
)

(defun GetCellValueAsList( excelFile sheetName RangeStr / xl wbs wb shs sh  rg cs vvv nms nm  ttt result)
	(vl-load-com)
	(setq xl  (vlax-get-or-create-object "Excel.Application")) ;;;创建excel程序对象
	(setq wbs (vlax-get-property  xl "WorkBooks")) ;;;获取excel程序对象的工作簿集合对象
	(setq wb  (vlax-invoke-method wbs "open"  excelFile)) ;;;用工作簿集合对象打开指定的excel文件
	(setq shs (vlax-get-property wb "Sheets"));;;获取刚才打开工作簿的工作表集合 
	(setq sh  (vlax-get-property  shs "Item" sheetName));获取指定的工作表 
	(setq rg (vlax-get-property  sh "Range" RangeStr));;;;用指定的字符串创建工作表范围对象 
	(setq vvv (vlax-get-property rg 'Value));;;获取范围对象的值
	(setq ttt (vlax-safearray->list (vlax-variant-value vvv))) ;;;转换为list
	(vlax-invoke-method wb "Close" );;;关闭工作簿
	;;(vlax-invoke-method  xl "Quit");;;退出excel对象       会关闭其他excel 禁用
	(vlax-release-object xl);;;释放excel对象
	(setq result ttt)  ;;; panelV 为全局变量
    ;;(vlax-variant-value (nth 3 (nth 0 panelV)))
)