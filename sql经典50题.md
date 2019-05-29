-- SQL 经典50题 100种解法 by William Xia. 2019 MAY 




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



