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
