(defun c:getcenter( /os ss1 ss2 ptlist1 ptlist2 c1 c2 )
    ;;; 功能：先后框选两组图形，把两组图形中心叠加重合

    ;;; 适用于矩形 对象类型 LWPOLYLINE 
    ;;; 使用 rectang 命令创建对象也为同一种

    ;;; 无论从 左下 左上 右下 右上 开始构建矩形统一规律为
    ;;; 第一点为起点，第二点为终点
    ;;; 第一点-第二点 为 X方向
    ;;; 第一点-第三点 为 对角方向
    ;;; 第一点-第四点 为 Y方向
    ;;; 参考命令 
    ;;; (setq endata (entget (car (entsel))))   对象属性
    ;;; (setq te (assoc 10 entdata))            某一群码属性

    ;;; cons 堆栈式，倒序存入数组
    ;;; 对象类型 (0 . "LWPOLYLINE") 				
    ;;; 顶点数目 (90 . 4) 	群码90 数值4
    
    ;;; 判断是否为空 判断对象类型 判断点数

    ;;; =================================================
    ;;; (command "zoom" "a");;; 调节视图
    ;;; (setvar "cmdecho" 0)
    (setq os (getvar "osmode"));;取得当前捕捉设置
    (setvar "osmode" 0);;关闭捕捉

    (prompt "选择需要移动的图形集")(prin1)  ;;; clear nil
    (setq ss1 (ssget))

    (prompt "选择固定的图形集")(prin1)
    (setq ss2 (ssget))

    (setq ptlist1 (getptlist ss1)) (prin1) ;;; 提取点 
    (setq ptlist2 (getptlist ss2)) (prin1) ;;; 提取点 

    (setq c1 (getcorner ptlist1 0))
    (setq c2 (getcorner ptlist2 0))

    (command "move" ss1 "" c1 c2)

    (setvar "osmode" os);;绘图结束还原捕捉设置
    ;;; 逐个选取对象
    ;;; 比较点对数 选取最小 最大值 getcorner(list list 0/1/2/3/4 )  
    ;;; 0为中心点 左上为1 逆时针 对应左上 左下 右下 右上
)

(defun c:getUcsCenter( / os ss1 ptlist1 c1)
    (setq os (getvar "osmode"));;取得当前捕捉设置
    (setvar "osmode" 0);;关闭捕捉
    (prompt "选择需要移动的图形集")(prin1)  ;;; clear nil
    (setq ss1 (ssget))
    (setq ptlist1 (getptlist ss1)) (prin1) ;;; 提取点 
    (setq c1 (getcorner ptlist1 0))
    (command "move" ss1 "" c1 '(0 0))
    (setvar "osmode" os);;绘图结束还原捕捉设置        
)

(defun getptlist( ss / i entid n ptlist result)

    (setq i 0)
    (setq entid (ssname ss i))
    (gc)
    (while entid
        (foreach n (entget entid)
            (if (= 10 (car n))
            (setq ptlist (cons (cdr n) ptlist)) )
        )  
        (setq i (+ i 1))
        (setq entid (ssname ss i))
    )
    (setq result ptlist)
    ;;;在没有加入返回语句的情况下，一个函数的最后一个语句的计算结果会被当作函数的返回值返回给调用者
)

(defun getcorner( ptlist flag / i p minX maxX minY maxY result )

    ;;; 提取 X 坐标 (car (nth i ptlist))
    ;;; 提取 Y 坐标 (cadr (nth i ptlist))

    (setq i 0)
    (setq p (nth i ptlist))
    (setq minX (car (nth i ptlist)))
    (setq maxX (car (nth i ptlist)))
    (setq minY (cadr (nth i ptlist)))
    (setq maxY (cadr (nth i ptlist)))   

    (while p
        (setq px (car (nth i ptlist)))
        (setq py (cadr (nth i ptlist)))

        (if (> px maxX) (progn (setq maxX px)))
        (if (< px minX) (progn (setq minX px)))
        (if (> py maxY) (progn (setq maxY py)))
        (if (< py minY) (progn (setq minY py))) 

        (setq i (+ i 1))
        (setq p (nth i ptlist))
    )

    (cond 
        ((= flag 0) (progn (setq p (list (/ (+ maxX minX) 2.0) (/ (+ maxY minY) 2.0) ))));;;中心  逆时针
        ((= flag 1) (progn (setq p (list minX maxY ))));;;左上
        ((= flag 2) (progn (setq p (list minX minY ))));;;左下
        ((= flag 3) (progn (setq p (list maxX minY ))));;;右下
        ((= flag 4) (progn (setq p (list maxX maxY ))));;;右上
        (t )
    )
    (setq result p)
)