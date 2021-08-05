set current schema vpcrzkh1;

create table emp_resume (
         empno char(6) not null, 
         resume_format varchar(10) not null, 
         resume clob(5k),
         emp_rowid char(40) not null default '', 
         primary key (empno, resume_format));

alter table emp_resume
   add column dl_resume datalink(1000) linktype url no link control;

alter table emp_resume
   add foreign key (empno) references employee on delete restrict;

create unique index xemp_resume
   on emp_resume (empno, resume_format);

delete from emp_resume; 

insert into emp_resume values('000130', 'ascii', null, '', null);
insert into emp_resume values('000130', 'html' , null, '', null);
insert into emp_resume values('000140', 'ascii', null, '', null);
insert into emp_resume values('000140', 'html' , null, '', null);
insert into emp_resume values('000150', 'ascii', null, '', null);
insert into emp_resume values('000150', 'html' , null, '', null);
insert into emp_resume values('000190', 'ascii', null, '', null);
insert into emp_resume values('000190', 'html' , null, '', null);

select * from emp_resume;