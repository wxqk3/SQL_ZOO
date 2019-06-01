# SQL_ZOO
My own ansers to all questions in SQL_ZOO(just for reference):http://sqlzoo.net/wiki/SQL_Tutorial.


--------更新：

# SQL 经典50题 100种解法 by William Xia. 2019 MAY 

##### 其中重点为：1/2/5/6/7/10/11/12/13/15/17/18/19/22/23/25/31/35/36/40/41/42/45/46 共16题

##### 超级重点 18和23、 22和25 、 41、46

-- 所有数据导入

	CREATE TABLE `Student`(
	`s_id` VARCHAR(20),
	`s_name` VARCHAR(20) NOT NULL DEFAULT '',
	`s_birth` VARCHAR(20) NOT NULL DEFAULT '',
	`s_sex` VARCHAR(10) NOT NULL DEFAULT '',
	PRIMARY KEY(`s_id`)
	);

	create table course(
	c_id varchar(20) primary key,
	c_name varchar(20) not null default '',
	t_id varchar(20) not null
	)

	CREATE TABLE `Teacher`(
	`t_id` VARCHAR(20),
	`t_name` VARCHAR(20) NOT NULL DEFAULT '',
	PRIMARY KEY(`t_id`)
	);

	CREATE TABLE `Score`(
	`s_id` VARCHAR(20),
	`c_id` VARCHAR(20),
	`s_score` INT(3),
	PRIMARY KEY(`s_id`,`c_id`)
	);

	insert into Student values
	('01' , '赵雷' , '1990-01-01' , '男'),
	('02' , '钱电' , '1990-12-21' , '男')
	;
	insert into Student values('03' , '孙风' , '1990-05-20' , '男');
	insert into Student values('04' , '李云' , '1990-08-06' , '男');
	insert into Student values('05' , '周梅' , '1991-12-01' , '女');
	insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
	insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
	insert into Student values('08' , '王菊' , '1990-01-20' , '女');

	insert into Course values('01' , '语文' , '02');
	insert into Course values('02' , '数学' , '01');
	insert into Course values('03' , '英语' , '03');


	insert into Teacher values('01' , '张三');
	insert into Teacher values('02' , '李四');
	insert into Teacher values('03' , '王五');

	/*成绩表测试数据--*/
	-- lll
	insert into Score values('01' , '01' , 80);
	insert into Score values('01' , '02' , 90);
	insert into Score values('01' , '03' , 99);
	insert into Score values('02' , '01' , 70);
	insert into Score values('02' , '02' , 60);
	insert into Score values('02' , '03' , 80);
	insert into Score values('03' , '01' , 80);
	insert into Score values('03' , '02' , 80);
	insert into Score values('03' , '03' , 80);
	insert into Score values('04' , '01' , 50);
	insert into Score values('04' , '02' , 30);
	insert into Score values('04' , '03' , 20);
	insert into Score values('05' , '01' , 76);
	insert into Score values('05' , '02' , 87);
	insert into Score values('06' , '01' , 31);
	insert into Score values('06' , '03' , 34);
	insert into Score values('07' , '02' , 89);
	insert into Score values('07' , '03' , 98);



-- 1.查询课程编号为“01”的课程比“02”的课程成绩高的所有学生的学号（重点）

	select *from Student st,Score s1,Score s2
	where st.s_id = s1.s_id and s1.s_id = s2.s_id and st.s_id = s2.s_id and s1.c_id='01' and s2.c_id='02' and s1.`s_score`>s2.`s_score`
-- 这么做是错的。没有链接的话 是 乘法倍数 生成表,就算后期筛选，也会出现多余数据 慎用 笛卡尔查询 


-- way1 用join 

	select * from Student st 
	join Score s1 on st.s_id=s1.s_id
	join Score s2 on st.s_id=s2.s_id
	where s1.c_id='01' and s2.c_id='02' and s1.`s_score`>s2.`s_score`



-- 2. 查询平均成绩大于60分的学生的学号和平均成绩（简单，第二道重点）

-- my answer 错误，是平均:

	select student.s_id,avg(s_score) from student 
	join score
	on student.s_id = score.s_id
	where s_score>60
	group by student.s_id


-- 错误写法:  是平均60分

	select s_id,avg(s_score) from score
	where s_score>60
	group by s_id

-- another

	select s_id,avg(s_score) from score

	group by s_id

	having avg(s_score)>60



-- 3.查询所有学生的学号、姓名、选课数、总成绩（不重要）

	select student.s_id,s_name,count(0),sum(s_score) from student
	join score on student.s_id = score.s_id
	group by student.s_id

-- 4.查询姓“猴”的老师的个数（不重要）

	select count(0) from teacher
        where t_name like '猴%'

-- 5.查询没学过‘张三'老师的课的 学生 的 学号，姓名

-- way1 子查询

	select * from student 
	where s_id not in (
	select sc.s_id from score sc 
	join course co on sc.c_id=co.c_id
	join teacher te on te.t_id=co.`t_id`
	where te.t_name='张三'
	)

/* -- way2 全部链接  错误 未完成

	select * from student st
	join score sc on st.s_id=sc.s_id
	join course co on co.c_id=sc.c_id
	join teacher te on te.t_id=co.t_id
	where te.t_name = '张三'
	group by st.s_id
	having  */
-- 6.查询学过‘张三'老师的所有课的 学生 的 学号，姓名

	select * from student 
	where s_id in (
	select sc.s_id from score sc 
	join course co on sc.c_id=co.c_id
	join teacher te on te.t_id=co.`t_id`
	where te.t_name='张三'
	group by sc.s_id
	having COUNT(0)=1
	)

-- 7. 查询学过01课 也学过02课的学生信息

	-- way1 全链接
	select * from student st
	join score sc on st.s_id=sc.s_id
	join course co on co.c_id=sc.c_id
	join teacher te on te.t_id=co.t_id
	where co.c_id='01' or co.c_id='02' 
	group by st.s_id
	having count(0) = 2

	-- way 2 
	select * from student 
	where s_id in
	(
	select * from score s1 
	join score s2 on s1.s_id=s2.s_id
	where s1.c_id=01 and s2.c_id=02

	)


-- 8查询课程编号 02 总成绩

-- way1 无脑全链接

	select sum(sc.s_score) from student st
	join score sc on st.s_id=sc.s_id
	join course co on co.c_id=sc.c_id
	join teacher te on te.t_id=co.t_id
	where co.c_id='02' 
	group by co.c_id

-- way 2

	select sum(s_score) from score
	where c_id='02' 



-- 9 查询所有课程成绩小于60分的学生的学号、姓名

	select s_id from student 
	where s_id not in(
	select s_id from score 
	where s_score > 60)

-- 10.查询没有学全所有课的学生的学号、姓名(重点)

	select st.s_id,st.s_name from student st
	join score sc on st.s_id=sc.s_id
	group by s_id,s_name
	having count(c_id) <
	(select count(distinct c_id) from course)

-- 11、查询至少有一门课与学号为“01”的学生所学课程相同的学生的学号和姓名（重点）

	select s_id,s_name from student where s_id in(

	select distinct s_id from score where c_id in(
	select distinct c_id from score 
	where s_id=01))

	and s_id != 01

-- 12.查询和“01”号同学所学课程完全相同的其他同学的学号(重点)

	select s_id from score where c_id in(
	select distinct c_id from score 
	where s_id=01) and s_id!=01
	group by s_id
	having count(c_id) = (select count(c_id) from score where  s_id=01)

-- 13、查询没学过"张三"老师讲授的任一门课程的学生姓名 和47题一样（重点，能做出来）

	select distinct s_name from student where s_id not in(

	select distinct s_id from score where c_id in(
		select distinct c_id from course co join teacher te
		on co.t_id=te.t_id 
		and te.t_name = '张三'
	))

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩（重点）

	select st.s_id,avg(s_score),s_name from score sc
	join student st on st.s_id=sc.s_id
	where s_score <60
	group by st.s_id
	having count(c_id)>=2

-- 16.检索"01"课程分数小于60，按分数降序排列的学生信息（和34题重复，不重点）

	select * from student st join(
	select s_id,s_score from score 
	where c_id = 01 and s_score <60
	) a1
	on st.s_id = a1.s_id
	order by s_score 

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩(重重点与35一样)

	select * from 
	(select s_score,s_id,c_id from score 
	where c_id = 01) s1
	join
	(select s_score,s_id,c_id from score 
	where c_id = 02) s2
	on s1.s_id= s2.s_id
	join
	(select s_score,s_id,c_id from score 
	where c_id = 03) s3
	on s1.s_id= s3.s_id


-- mysql 不支持full join 用 left then right then union代替

-- 方法2

	select s_id,
	max(case when c_id=01 then s_score else 0 end )'语文',
	max(case when c_id=02 then s_score else 0 end )'数学',
	max(case when c_id=03 then s_score else 0 end )'英语',
	avg(s_score)
	from score
	group by s_id


-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率

	select c_id,max(s_score),min(s_score),avg(s_score) pinjun,avg(case when s_score>60 then 1 else 0 end) jige,
	avg(case when (s_score>=70 and s_score<80) then 1 else 0 end) zhongdeng,
	avg(case when (s_score>=80 and s_score<90) then 1 else 0 end) you,
	avg(case when s_score>=90  then 1 else 0 end) xiu

	from score
	group by c_id

-- -- 19、按各科成绩进行排序，并显示排名(重点row_number)
	select * from
	(select s_id,c_id,s_score from score
	where c_id = 01
	order by s_score desc) t1

	union all

	select * from
	(select s_id,c_id,s_score from score
	where c_id = 02
	order by s_score desc) t2 

-- 上述答案错误 union导致排序无效

-- standard:

	select s_id,c_id,s_score,Row_Number() OVER (partition by c_id ORDER BY s_score desc)  from score

-- 20.查询学生的总成绩并进行排名（不重点）

	select s_id,sum(s_score) from score
	group by s_id


-- 21 、查询不同老师所教不同课程平均分从高到低显示(不重点)

	select te.t_id,sc.c_id, avg(sc.s_score) from score sc
	join course co on sc.c_id = co.c_id
	join teacher te on te.t_id = co.t_id
	group by te.t_id，sc.c_id

	order by avg(sc.s_score)

-- group by 常见错误 https://blog.csdn.net/qq_26525215/article/details/52139296

-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩（重要 25类似）row number

	select * from
	(select st.s_id,st.s_name,sc.c_id,sc.s_score,Row_Number() OVER (partition by c_id ORDER BY s_score desc) paiming
	from student st
	join score sc on sc.s_id=st.s_id) a
	where paiming in (2,3)

-- 这种先计算的 where就不能识别，需用两个select

-- 使用分段[100-85],[85-70],[70-60],[<60]来统计各科成绩，分别统计各分数段人数：课程ID和课程名称(重点和18题类似)

	select c_id,
	case when s_score<60 then s_score else null end '[<60]',
	case when s_score>=60 and s_score<70 then s_score else null end'[70-60]',
	case when s_score>=70 and s_score<85 then s_score else null end"[85-70]",
	case when s_score>=85 and s_score<=100 then s_score else null end"[100-85]"
	from score


-- 一对一变一对多 用case

	/* select c_id,avg(s_score)
	from score
	where c_id=01
	group by c_id */

-- 24、查询学生平均成绩及其名次（同19题，重点）

	select avg(s_score), row_number() over (order by avg(s_score)) 
	from score 
	group by s_id

-- 25.查询各科成绩前三名的记录（不考虑成绩并列情况）（重点 与22题类似）

-- p 是新表的东西，需要重新使用select

	select * from(
	select c_id,s_score,row_number() over (partition by c_id order by s_score desc) p
	from score
	) a
	where p in (1,2,3)

-- 若要转置，则代码应该为

	select `c_id` ,
	max(case when p=1 then s_score else 0 end ) rank1,
	max(case when p=2 then s_score else 0 end )rank2,
	max(case when p=3 then s_score else 0 end )rank3
	from(
	select c_id,s_score,row_number() over (partition by c_id order by s_score desc) p
	from score
	) a
	where p in (1,2,3)
	group by c_id

  /*   row_number() 是没有重复值的排序(即使两天记录相等也是不重复的)，可以利用它来实现分页
    dense_rank() 是连续排序，两个第二名仍然跟着第三名
    rank()       是跳跃拍学，两个第二名下来就是第四名 */

-- 26、查询每门课程被选修的学生数(不重点)

	select c_id,count(distinct s_id) from score
	group by c_id

-- 27、 查询出只有两门课程的全部学生的学号和姓名(不重点)

	select st.s_name,st.s_id from student st
	join score sc on st.s_id = sc.s_id
	group by st.s_name,st.s_id
	having count(0)=2

-- 28、查询男生、女生人数(不重点)

	select sum(case when s_sex='男' then 1 else 0 end) nan,
	sum(case when s_sex='女' then 1 else 0 end) girl
	from student
	group by s_sex

-- 简单做法

	select s_sex,count(s_sex) from student
	group by s_sex

-- 29 查询名字中含有"风"字的学生信息（不重点）

	select * from student 
	where s_name like '%风%'

-- 30题忽略掉 太简单

-- 31、查询1990年出生的学生名单（重点year）

	select * from student
	where s_birth like '1990%' 

-- 32、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩（不重要）

	select st.s_id,st.s_name,a.average from student st
	join(
	select avg(s_score) average,s_id from score sc
	group by s_id) a
	on st.s_id = a.s_id

-- 33、查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列（不重要）

	select avg(s_score) from score 
	group by `c_id`
	order by avg(s_score) asc, c_id desc

-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数（不重点）

	select st.s_name,sc.s_score from student st
	join score sc on st.s_id=sc.s_id
	where s_score < 60 and c_id in
	(
	select c_id from course
	where c_name = '数学'
	)

-- 35.查询所有学生的课程及分数情况（重点）

	select s_id,
	max(case when `c_id`=01 then s_score else 0 end) ,
	max(case when `c_id`=02 then s_score else 0 end) ,
	max(case when `c_id`=03 then s_score else 0 end) 
	from score
	group by s_id

-- 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数（重点）

	select st.s_name,co.c_name,sc.s_score
	from student st
	join score sc on st.s_id=sc.s_id
	join course co on co.c_id=sc.c_id
	where sc.s_score >=70

-- 37、查询不及格的课程并按课程号从大到小排列(不重点)

	select s_id,s_score from score

	where s_score <60
	order by s_id desc 

-- 38、查询课程编号为03且课程成绩在80分以上的学生的学号（不重要）

	select s_id from score
	where c_id=03 and s_score >80

-- 39、求每门课程的学生人数（不重要）

	select count(distinct s_id),c_id from score
	group by c_id

-- 40、查询选修“张三”老师所授课程的学生中成绩最高的学生姓名及其成绩（重要top）

	select st.s_name,s_score from student st
	join score sc on st.s_id = sc.s_id
	where c_id in


	(
	select c_id from course where t_id in(
	select t_id from teacher where t_name='张三'
	))
	order by s_score desc
	limit 1

-- 41.查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 （重点）

	select * from
	(select s_id,c_id,s_score from score where c_id=01) a
	join (select s_id,c_id,s_score from score where c_id=02) b
	on a.s_id=b.s_id
	join (select s_id,c_id,s_score from score where c_id=03) c
	on c.s_id=b.s_id
	where a.s_score=b.s_score and b.s_score=c.s_score

-- 42、查询每门功成绩最好的前两名（同22和25题）

	select * from
	(select s_id,c_id,s_score, row_number() over (partition by c_id order by s_score desc) rankk from score) a
	where rankk = 1 or rankk=2

-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列（不重要）

	select c_id,count(0) from score
	group by c_id
	having count(c_id)>5
	order by count(c_id) desc,c_id asc

-- 44、检索至少选修两门课程的学生学号（不重要）

	select s_id,count(c_id) from score
	group by s_id
	having count(c_id)>=2

-- 45、 查询选修了全部课程的学生信息（重点划红线地方）

	select s_id,count(0) from score
	group by s_id
	having count(c_id)=(select count(distinct c_id) from course)

-- 46、查询各学生的年龄（精确到月份）

	select s_id,s_birth,
	datediff(s_birth,CURDATE())/(-365)
	from student


-- 47、查询没学过“张三”老师讲授的任一门课程的学生姓名

	select distinct s_name from student st

	where s_id not in
	(select s_id from score 
	where c_id in
	(
	select c_id from course where t_id in(
	select t_id from teacher where t_name='张三'
	)) 
	) 

-- 48、查询两门以上不及格课程的同学的学号及其平均成绩

	select s_id,avg(s_score) from score
	where s_score<60
	group by s_id

-- 49(1) 查询本周过生日的学生（使用week、date(now()）

	select s_id,s_birth from student
	where week(s_birth,1)=week(date(now()),1)
	-- select week(date(now()),1)
	-- select date(now()),CURDATE()
-- 49(2) 查询下周过生日的学生（使用week、date(now()）

	select s_id,s_birth from student
	where week(s_birth,1)=week(date(now()),1)+1
-- 50（1）查询本月过生日的学生（使用week、date(now()）

	select s_id,s_birth from student
	where month(s_birth)=month(date(now()))
-- 50（2）查询下月过生日的学生（使用week、date(now()）

	select s_id,s_birth from student
	where month(s_birth)=month(date(now()))+1

-- 另外50种解法及部分参考答案见 https://zhuanlan.zhihu.com/p/43289968
   本人在做完经典50题时发现答案和其不完全一样，已修订部分答案

