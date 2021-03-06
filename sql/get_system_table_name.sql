--#SET TERMINATOR #
create procedure vpcrzkh1.get_system_table_name (
                in db2name varchar(128)
            )
        language sql
        dynamic result sets 1
begin
    -- Declare cursor
    declare cursor1 cursor for
        select sys_tname
            from qsys2.systables
            where name = upper(db2name);
        -- Cursor left open for client application
    open cursor1;
    return;
end

-- call vpcrzkh1.get_system_table_name('SYSCOLUMNS2');