
(defun c:readData( / )

    (setq fileName (getfiled "Open Excel file" "" "xlsx" 16))
    (setq data (ReadExcelData fileName "Sheet1" "A1:A2:A3:A4:B1"))
    (princ (nth 0 data))
    (princ (nth 1 data))
    (princ (nth 2 data))
    (princ (nth 3 data))

    (vlax-variant-value (car (nth 4 data)))
)


(defun ReadExcelData( excelFileName sheetName RangeStr / excelObj wbsObj workBook whsObj workSheet ranges vlaData listData result) 
    (vl-load-com)
    (setq excelObj  (vlax-get-or-create-object "Excel.Application")) ;;;创建excel程序对象
    (setq wbsObj (vlax-get-property  excelObj "WorkBooks")) ;;;获取excel程序对象的工作簿集合对象
    (setq workBook  (vlax-invoke-method wbsObj "open"  excelFileName)) ;;;用工作簿集合对象打开指定的excel文件
    (setq whsObj (vlax-get-property workBook "Sheets"));;;获取刚才打开工作簿的工作表集合

	(setq workSheet (vlax-get-property  whsObj "Item" sheetName));获取指定的工作表 
	(setq ranges  (vlax-get-property  workSheet "Range" RangeStr));;;;用指定的字符串创建工作表范围对象 
	(setq vlaData (vlax-get-property ranges 'Value));;;获取范围对象的值
	(setq listData (vlax-safearray->list (vlax-variant-value vlaData))) ;;;转换为list

	(vlax-invoke-method workBook "Close" );;;关闭工作簿
	;;(vlax-invoke-method  xl "Quit");;;退出excel对象       会关闭其他excel 禁用
	(vlax-release-object excelObj);;;释放excel对象
    (setq result listData)
)

(defun GetCellValueAsListOld( excelFile sheetName RangeStr / xl wbs wb shs sh  rg cs vvv nms nm  ttt result)
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

(defun excelFunTest()
	(setq XLobj (vlax-create-object "Excel.Application"));
	(vla-put-visible XLobj 1);
	(setq wbobj (vlax-invoke-method (vlax-get-property XLobj "WorkBooks") "Open" (getfiled "Open Excel file" "" "xlsx" 20)));

	(setq sheetobj (vlax-get-property wbobj "Sheets"))
	(setq sheet  (vlax-get-property  sheetobj "Item" "Sheet1"))
	(setq cells (vlax-get-property  sheet "Cells"))
	(setq range (vlax-variant-value (vlax-get-property  cells "Item" 1 1)))
	(Vlax-Put-Property range 'Value2 "789" )

)


