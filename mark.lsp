;;; mark

;;; haobo

;;; read excel


(defun c:drawmark( / cmvar osvar blkData elsSheet )

    (setq cmvar (getvar "cmdecho"))
    (setvar "cmdecho" 0)
    (setq osvar (getvar "osmode"));;取得当前捕捉设置
    (setvar "osmode" 0);;;;; close cmd output , it can cause wrong input 

    (setq blkData (getBlockData 2 10))
    ;;; blkname basepointX basepointY

    (setq elsSheet (getstring T "请输入EXCEL工作表名称: "))(prin1)
    (setq elsArea (getElsArea))
    ;;; excel area; lx; ly 
    (setq markPoints (getExcelData elsSheet (car elsArea)))
    (drawBlock blkData elsArea markPoints)
    ;;;(drawText markPoints )


    (setvar "osmode" osvar);; 绘图结束还原捕捉设置
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

    (setq textflag (getint "是否画文字序号(1 to yes/0 to no): "))
    (if (= textflag 1)
        (progn 
            (setq ymk (getint "Q单位Y方向mark个数: "))
            (setq xmk (getint "Q单位X方向mark个数: "))
            (setq nmk (getint "mark总列数: "))
            (setq mmk (getint "mark总行数: "))
            (setq dmk (getint "mark类型为单边(1) or 双边(2) or 相邻(3) : "))
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
                    (setq pnum (rtos (fix pnum) 2)) ;;;十进制
                    ;;; 判定方向 需要输入 Ｑ　周围数据
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
    (prompt "请选择块")(prin1)
    (setq ss (ssget))
    (setq entdata (entget (ssname ss 0)))
    ;;;选择集 选择集中对象 对象属性
    (setq data1 (cdr (assoc s1 entdata)))
    (setq data2 (car (cdr (assoc s2 entdata))))
    (setq data3 (cadr (cdr (assoc s2 entdata))))
    (setq result (list data1 data2 data3 ))
)

(defun getElsArea( / result pt1chr pt1num pt2chr pt2num area lx ly)
    ;;; get excel area

    (setq pt1chr (getstring T "请输入EXCEL中单元格位置信息-左上-字母: "))(prin1)
    (setq pt1num (getstring T "请输入EXCEL中单元格位置信息-左上-数字: "))
    (setq pt2chr (getstring T "请输入EXCEL中单元格位置信息-右下-字母: "))(prin1)
    (setq pt2num (getstring T "请输入EXCEL中单元格位置信息-右下-数字: "))
    (setq area (strcat pt1chr pt1num ":" pt2chr pt2num))
    (setq lx (+ 1 (- (ascii pt2chr) (ascii pt1chr))))
    (setq pt1num (atof pt1num))
    (setq pt2num (atof pt2num))
    (setq ly (+ 1 (- pt2num pt1num)))
    (setq result (list area lx ly))
)

(defun getExcelData( elsSheet elsArea / result fileDir elsData )
    ;;; read excel data
    (setq fileDir (getfiled "Open markdata file" "" "xlsx" 16))    ;;; ;;; 窗口名称 默认路径 扩展名 flag
    (setq elsData (cons (GetCellValueAsList fileDir elsSheet elsArea) elsData))
    (setq result elsData)
)

(defun insertText( str ptx pty mode / pt rad dirc)
    ;;; insert text region=100
    (setq rad 25);;; 偏移距离
    (setq dirc (list (list 0 0) (list -1 1) (list 0 1) (list 1 1) (list 1 0) (list 1 -1) (list 0 -1) (list -1 -1) (list -1 0) (list 0 0) (list 0 0)));;;directions
    ;;; 0中心 1左上 2上 3右上 4右 5右下 6下 7左下 8左 9中心 10中心
    (setq dirc (append dirc (list (list -2 1) (list -1 2) (list 1 2) (list 2 1) (list 2 -1) (list 1 -2) (list -1 -2) (list -2 -1) )))
    ;;;细分八方向 顺时针
    ;;; 11 12 13 14 15 16 17 18

    (setq ptx (+ ptx (* rad (car (nth mode dirc)))))
    (setq pty (+ pty (* rad (cadr (nth mode dirc)))))

    (setq pt (list ptx pty))

    (command "mtext" pt "j" "mc" pt str "") 
)

(defun textDrc(ymk xmk nmk mmk dmk cmk / result xgmk ygmk yall parity)
    ;;;
    ;;; 0中心 1左上 2上 3右上 4右 5右下 6下 7左下 8左
    ;;; 11 12 13 14 15 16 17 18
    
    (cond 
    ((= dmk 1);;单边
    (progn

    ;;; 奇偶列 奇偶行
    (setq xgmk (* xmk (- nmk 1)))
    (if (= xgmk 0) (setq xgmk 1))
    (setq ygmk (* ymk (- mmk 1)))
    (if (= ygmk 0) (setq ygmk 1))
    (setq yall (* ygmk nmk ));;;



    (if (< cmk yall)            
    (progn  ;;;列
        (if (= (- ygmk 1) (/ cmk ygmk))
        (progn
            (cond ;;右侧
                ((= 0 (rem cmk ymk)) (progn (setq result 17)));;cmk % ymk =0;;上 左下
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 12)));;cmk % ymk = ymk-1;;左下 右上偏
                (t (progn (setq result 7)));;左     左下偏
            )       
        )
        (progn
            (cond ;;左侧
                ((= 0 (rem cmk ymk)) (progn (setq result 16)));;cmk % ymk =0;;上 右下
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 13)));;cmk % ymk = ymk-1;;左下 右上偏
                (t (progn (setq result 5)));;左     右下偏
            )       
        )
        )             
    )
    ;;else
    (progn  ;;;行
        (setq cmk (- cmk yall))
        (if (= (- xgmk 1) (/ cmk xgmk))
        (progn  ;; 下
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;左上   右偏
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; 右上     左偏
                (t (progn (setq result 2)));；下             上偏
            )
        )
        (progn  ;; 上
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;左上   右偏
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; 右上     左偏
                (t (progn (setq result 6)));；上             下偏
            )
        )               
        )                   
    )
    )    
    )
    )

    ((= dmk 2);;双边
    (progn
    ;;; 奇偶列 奇偶行
    (setq xgmk (* xmk (/ nmk dmk)))
    (if (= xgmk 0) (setq xgmk 1))
    (setq ygmk (* ymk (/ mmk dmk)))
    (if (= ygmk 0) (setq ygmk 1))
    (setq yall (* ygmk nmk ));;;

    (if (< cmk yall)            
    (progn  ;;;列
        (setq parity (/ cmk ygmk))
        (if (= 0 (rem parity 2))
        (progn  ;;偶数列  左侧
            (cond 
                ((= 0 (rem cmk ymk)) (progn (setq result 16)));;cmk % ymk =0;;左上 右下偏
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 13)));;cmk % ymk = ymk-1;;左下 右上偏
                (t (progn (setq result 5)));;左     右下偏
            )            
        )
        ;;else            
        (progn  ;;奇数列   右侧
            (cond 
                ((= 0 (rem cmk ymk)) (progn (setq result 17)));;cmk % ymk =0;;右上 左下偏
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 12)));;cmk % ymk = 0;;右下 左上偏
                (t (progn (setq result 7)));;右     左下偏
            )          
        )
        )
    )
    ;;else
    (progn  ;;;行
        (setq cmk (- cmk yall))
        (setq parity (/ cmk xgmk))
        (if (= 0 (rem parity 2))
        (progn  ;;偶数行
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;左上   右偏
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; 右上     左偏
                (t (progn (setq result 6)));；上             下偏
            )            
        )
        ;;else            
        (progn  ;;奇数行
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 14)));;左下    右上偏
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 11)));;右下      左上偏
                (t (progn (setq result 2)));;下             上偏
            )          
        )
        )
    )
    )    

    ))

    ((= dmk 3);;相邻
    (progn

    ;;; 奇偶列 奇偶行
    (setq xgmk (* xmk (+ nmk 1)))
    (setq ygmk (* ymk (+ mmk 1)))
    (setq yall (* ygmk nmk ));;;

    (if (< cmk yall)            
    (progn  ;;;列
            (cond ;;右侧
                ((= 0 (rem cmk ymk)) (progn (setq result 7)));;cmk % ymk =0;;上 左下
                ((= (- ymk 1) (rem cmk ymk)) (progn (setq result 1)));;cmk % ymk = ymk-1;;左下 左上偏
                (t (progn (setq result 8)));;     左偏
            )               
    )
    ;;else
    (progn  ;;;行
            (cond 
                ((= 0 (rem cmk xmk)) (progn (setq result 15)));;左   右下偏
                ((= (- xmk 1) (rem cmk xmk)) (progn (setq result 18)));; 右     左下偏
                (t (progn (setq result 6)));；     下偏
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