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


;定义字体
(command "style" "ddd" "arial" "1.5" "1.0" "0.0" "N" "N" )
; 字高 宽度 角度 颠倒 反向

(command "dimlinear" p1 p2 "h" p3)
(command "dimlinear" p1 p2 "h" "@-20,5")


　　;;;新建标注样式"TSSD_100_100"
　　(defun ddstyle ( / sc)
　　(setq sc 1)
　　;;(setq sc (cdr (assoc 18 Data)))	;绘图比例
　　(setvar "cmdecho" 0)
　　(setvar "dimclrd" 0)			;为尺寸线、箭头和标注引线指定颜色
　　(setvar "dimclre" 0)			;为尺寸界线指定颜色
　　(setvar "dimclrt" acwhite)		;为标注文字指定颜色
　　(setvar "dimdle" (* sc 100))		;当使用小斜线代替箭头进行标注时，设置尺寸线超出尺寸界线的距离(超出标记)
　　(setvar "dimexe" (* sc 100))		;指定尺寸界线超出尺寸线的距离
　　(setvar "dimexo" (* sc 250))		;起点偏移量
　　(setvar "dimblk" "_ARCHTICK")		;箭头(建筑标记)
　　(setvar "dimasz" (* sc 100))		;控制尺寸线和引线箭头的大小。并控制基线的大小
　　;;(setvar "dimcen" 0)			;圆心标记－无
　　;;(setvar "dimarcsym" 0)		;弧长符号－前辍
　　;;(setvar "dimjogang" (* sc 45))	;折弯角度
　　(setvar "dimtxsty" "TSSD_Dimension")	;指定标注的文字样式
　　(setvar "dimtxt" (* sc 300))		;指定标注文字的高度
　　(setvar "dimtad" 1)			;文字垂直位置(上方)
　　(setvar "dimjust" 0)			;文字水平位置(居中)
　　;;(setvar "dimtih" "off")		;线内文字对齐(与尺寸线对齐)
　　;;(setvar "dimtoh" "off")		;线外文字对齐(与尺寸线对齐)
　　(setvar "dimgap" (* sc 100))		;文字从尺寸线偏移
　　;;(setvar "dimtix" "on")		;文字始终保持在尺寸界线之间
　　(setvar "dimtmove" 2)			;文字不在默认位置时，放在 尺寸线上方，不加引线
　　(setvar "dimscale" 1)			;全局比例
　　;;(setvar "dimtofl" "on")		;在尺寸线之间绘制尺寸界线
　　(setvar "dimdec" 0)			;精度
　　(setvar "dimlfac" 1)			;测量比例因子
　　(command "-dimstyle" "S" "TSSD_100_100" "" "");建立标注样式
)




;;; UNITS

(setvar "LUNITS" 2)             ;线性单位格式  小数
(setvar "INSUNITSDEFSOURCE" 1)  ;插入时的缩放单位 毫米
(setvar "INSUNITS" 4)           ;指定插入或附着到图形时，块、图像或外部参照进行自动缩放所使用的图形单位值 1英制 4公制
(setvar "INSUNITSDEFTARGET" 4)  ;当 INSUNITS 设定为 0 时，设置目标图形单位值。
(setvar "AUNITS" 0)             ;设定角度单位 十进制度数
(setvar "LIGHTINGUNITS" 2)      ;控制是使用常规光源还是使用光度控制光源，并指定图形的光源单位。 2 使用国际光源单位（勒克斯），并启用光度控制光源
(setvar "LWUNITS" 1)            ;控制线宽单位是以英寸显示还是以毫米显示。 1 毫米





;;;线
;尺寸线
(setvar "DIMCLRD" 6)			;洋红色;为尺寸线、箭头和标注引线指定颜色
(setvar "DIMLTYPE" "")          ;线型 "BYLAYER"、"BYBLOCK"
(setvar "DIMLWD" -2)            ;线宽  -3 默认值 -2 byblock -1 bylayer
(setvar "DIMDLE" 0.0)
(setvar "DIMDLI" 3.75)          ;基线间距 3.75公 0.38英
(setvar "DIMSD1" 0)             ;尺寸线1
(setvar "DIMSD2" 0)             ;尺寸线2

;尺寸界限
(setvar "DIMCLRE" 6)			;洋红色;为尺寸界线指定颜色
(setvar "DIMLTEX1" "")          ;界限1线性 "BYLAYER"、"BYBLOCK"
(setvar "DIMLTEX2" "")          ;界限2线性 "BYLAYER"、"BYBLOCK"
(setvar "DIMLWE" -2)            ;线宽  -3 默认值 -2 byblock -1 bylayer
(setvar "DIMSE1" 0)             ;尺寸线1
(setvar "DIMSE2" 0)             ;尺寸线2
(setvar "DIMEXE" 1.25)          ;超出尺寸线 1.25公 0.18英
(setvar "DIMEXO" 0)             ;起点偏移量 0.625公 0.0625英
(setvar "DIMFXLON" 0)           ;固定长度尺寸界限
(setvar "DIMFXL" 1)             ;固定长度尺寸界限长度

;;;符号和箭头
;箭头
(setvar "DIMBLK1" "")           ;箭头 参照 DIMBLK 各项 ""实心闭合
(setvar "DIMBLK2" "")           ;箭头 参照 DIMBLK 各项 ""实心闭合
(setvar "DIMLDRBLK" "")         ;引线 参照 DIMBLK 各项 ""实心闭合
(setvar "DIMLDRBLK" 0.18)       ;箭头大小

;圆心标记
(setvar "DIMCEN" 0.09)

;折断标注
;none

;弧长符号
(setvar "DIMARCSYM" 0)

;半径折弯标注
(setvar "DIMJOGANG" 45)

;线性折弯标注
;none

;;;文字
;文字外观
(setvar "DIMTXSTY" "Standard")      ;文字样式
(setvar "DIMCLRT" 6)                ;文字颜色 洋红色
(setvar "DIMTFILL" 0)               ;填充颜色 0 1图形背景色 2 由DIMTFILLCLR决定
(setvar "DIMTFILLCLR" 0 )           ; 0 byblock 256 bylayer
(setvar "DIMTXT" 0.18)              ;文字高度 0.18英 2.5公 确保文字样式中高度为0

(setvar "DIMGAP" 0.09)              ;绘制文字边框 0.09英 0.625 公


;文字位置



;文字对齐


(setvar "dimclrt" 6)		    ;洋红色;为标注文字指定颜色