(defun chaEntity(/pa1 )
    
    (setq element pa1)
    (assoc element (entget (car (entsel))))


    (setq a1 (entsel "select:"));;;选取对象
    (setq en1 (car a1));;;取出对象名称
    (setq e1 (entget en1));;;取得对象数据序列
    (setq d1 (assoc 8 e1));;;取得对应元素
    (setq d2 (cons 8 "layer2"));;;新建属性
    (setq e1 (subst d2 d1 e1));;;替换原有属性
    (entmod e1);;;更新属性

    ;;;Bylayer时没有对应属性
    ;;;加入数据
    (setq e3 (entget (car (entsel "sel"))))
    (setq d3 (assoc 62 e3));;;若不存在返回nil，可判断是否为bylayer
    (setq d4 (cons 62 5));;;建立属性
    (setq e3 (cons d4 e3));;;加入原先数据库
    (entmod e3);;;更新对象，数据位置会被自动调整

    ;;;改成bylayer
    ;;;循环查找,删除？
)