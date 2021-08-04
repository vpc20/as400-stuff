drop table emp_photo;

create table emp_photo (
         empno char(6) not null, 
         photo_format varchar(10) not null, 
         picture blob(100k),
         emp_rowid char(40) not null default '',
         primary key (empno, photo_format));


alter table emp_photo
   add column dl_picture datalink(1000) linktype url no link control;

alter table emp_photo
   add foreign key (empno) references employee on delete restrict;
   
insert into emp_photo values('000130', 'bitmap', null, '', null);
insert into emp_photo values('000130', 'gif'   , null, '', null);
insert into emp_photo values('000140', 'bitmap', null, '', null);
insert into emp_photo values('000140', 'gif'   , null, '', null);
insert into emp_photo values('000150', 'bitmap', null, '', null);
insert into emp_photo values('000150', 'gif'   , null, '', null);
insert into emp_photo values('000190', 'bitmap', null, '', null);
insert into emp_photo values('000190', 'gif'   , null, '', null);

select * from emp_photo;