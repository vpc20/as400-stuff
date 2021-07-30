create procedure update_employee_info (in employee_number char(10), 
                                       in emp_dept        char(3)  default null,
                                       in phone_number    char(4)  default null, 
                                       in job             char(8)  default null, 
                                       in edlevel         smallint default null)

call update_employee_info('123456', 'd11', '4424');
call update_employee_info('123456', default, '4424', default, default);
call update_employee_info('123456', edlevel => 18);
                                       
                                   
