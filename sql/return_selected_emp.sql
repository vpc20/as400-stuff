create procedure vpcrzkh1.return_selected_emp (
                in dept_number char(3)
            )
        language sql
        dynamic result sets 1
begin
    declare c1 cursor for
        select *
            from vpcrzkh1.employee
            where workdept = dept_number;
    open c1;
    return;
end

// run from ACS Run SQL scripts to get interactive results