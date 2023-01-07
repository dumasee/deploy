## sql进阶教程 [日]mick
1. sql指令执行顺序
SQL中各部分的执行顺序是：FROM→WHERE→GROUPBY→HAVING→SELECT(→ORDER BY)。严格地说，ORDER BY并不是SQL语句的一部分，因此可以排除在外。这样一来，SELECT就是最后才被执行的部分了

2. 寻找不连续的编号
面向过程的编号要实现这个功能比较麻烦，但sql实现起来太容易了。
```
SELECT COUNT(*) FROM wkserver;
SELECT max(id) FROM wkserver;

select '存在缺失的id' as result from wkserver having COUNT(*) != max(id);
```

3. SQL中没有循环，而且没有也并不会带来什么问题。因为去掉普通编程语言中的循环正是SQL语言设计之初的目的之一。

4. 关系数据库，可以理解为集合的概念，列可理解成不同的属性，行可理解成属性值。数据库表的行是没有顺序的。
关系数据库没有循环的概念。

5.检查不重复的字段值
/* 以下指令效果相同：
*/
```
SELECT ip FROM server_fudi GROUP BY ip;
SELECT distinct ip FROM server_fudi;  -- 检索结果ip地址唯一
```


6. 任何时候使用具有AND和OR操作符的WHERE子句，都应该使用圆括号明确地分组操作符。
不要过分依赖默认求值顺序，即使它确实如你希望的那样。使用圆括号没有什么坏处，它能消除歧义。
```
SELECT  DISTINCT ip  from server_fudi where ( hostname LIKE '%storage%' and ip LIKE '%192.168.22.%');
```

