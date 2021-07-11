create procedure vpcrzkh1.get_db2_table_name (
                in sys_table_name varchar(128)
            )
        language sql
        dynamic result sets 1
begin
    -- Declare cursor
    declare cursor1 cursor for
        select name
            from qsys2.systables
            where sys_tname = upper(sys_table_name);
        -- Cursor left open for client application
    open cursor1;
    return;
end

-- call vpcrzkh1.get_db2_table_name('SYScOLUMn2');