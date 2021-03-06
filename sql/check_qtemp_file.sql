--#SET TERMINATOR #
create procedure vpcrzkh1.check_qtemp_file (
                in filename char(10)
            )
        language sql
        modifies sql data
begin
    declare stmt varchar(50);
    if (select count(1)
                from qsys2.systables
                where name = upper(filename)
                      and type = 'T') = 0 then
        set stmt = 'drop table vpcrzkh1.' || filename;
        prepare s from stmt;
        execute s;
    end if;
end

-- call vpcrzkh1.check_qtemp_file('tmp1x');