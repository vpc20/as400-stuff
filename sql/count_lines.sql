-- ============================================================
-- Stored Procedure : CNTLINES
-- Purpose          : Count total non-blank lines in all
--                    members of a source physical file.
--                    Blank/whitespace-only lines are excluded.
-- Create           : RUNSQLSTM SRCFILE(VPCRZKH1/QSQLSRC)
--                              SRCMBR(CNTLINES)
--                              COMMIT(*NONE)
-- Call             : CALL VPCRZKH1/CNTLINES('VPCRZKH1', 'QRPGLESRC')
-- ============================================================
set current schema vpcrzkh1;

drop procedure vpcrzkh1.count_lines;

create procedure vpcrzkh1.count_lines (
        in p_library varchar(10),
        in p_srcfile varchar(10),
        out p_total_members decimal(10, 0),
        out p_total_lines decimal(15, 0)
      )
    language sql
    set option commit = *none,
               dbgview = *source,
               usrprf = *owner
begin
-- -------------------------------------------------------
-- 1. Variables
-- -------------------------------------------------------
  declare v_member char(10) default '';
  declare v_srcdta varchar(200) default '';
  declare v_stripped varchar(200) default '';
  declare v_member_lines decimal(15, 0) default 0;
  declare v_eof int default 0;
  declare v_dyn_sql varchar(500) default '';
  -- -------------------------------------------------------
  -- 2. Cursors
  -- -------------------------------------------------------
  declare c_members cursor for
    select table_partition
      from qsys2.syspartitionstat
      where table_schema = p_library and
            table_name = p_srcfile
      order by table_partition;
  declare c_srclines cursor for s_srclines;
  -- -------------------------------------------------------
  -- 3. Handler
  -- -------------------------------------------------------
  declare continue handler for not found set v_eof = 1;
  -- -------------------------------------------------------
  -- Initialise OUT parameters
  -- -------------------------------------------------------
  set p_total_members = 0;
  set p_total_lines = 0;
  -- -------------------------------------------------------
  -- Open member list and fetch first row
  -- -------------------------------------------------------
  set v_eof = 0;
  open c_members;
  fetch c_members
    into v_member;
  -- -------------------------------------------------------
  -- Loop over every member
  -- -------------------------------------------------------
  while v_eof = 0 do
    set p_total_members = p_total_members + 1;
    set v_member_lines = 0;
    -- ---------------------------------------------------
    -- Build dynamic SQL: SELECT SRCDTA FROM LIB/FILE(MBR)
    -- ---------------------------------------------------
    set v_dyn_sql = 'select srcdata from table(sqltools.readsrc(' || chr(39) || trim(p_library)
          || chr(39) || ', ' || chr(39) || trim(p_srcfile) || chr(39) || ', ' || chr(39) ||
          trim(v_member) || chr(39) || '))';
    prepare s_srclines from v_dyn_sql;
    -- ---------------------------------------------------
    -- Reset EOF flag before opening source line cursor
    -- ---------------------------------------------------
    set v_eof = 0;
    open c_srclines;
    fetch c_srclines
      into v_srcdta;
    --
    while v_eof = 0 do
      -- -----------------------------------------------
      -- Blank line detection:
      -- REPLACE strips EBCDIC whitespace characters,
      -- TRIM removes spaces. Skip if nothing remains.
      --   x'05' = Horizontal Tab
      --   x'0D' = Carriage Return
      --   x'15' = New Line (NL)
      --   x'25' = Line Feed (LF)
      -- -----------------------------------------------
      set v_stripped = trim(
            replace(
              replace(replace(replace(v_srcdta, X'05', ''), X'0D', ''), X'15', ''), X'25', ''));
      if length(v_stripped) > 0 then
        set v_member_lines = v_member_lines + 1;
      end if;
      set v_eof = 0;
      fetch c_srclines
        into v_srcdta;
    end while;
    --
    close c_srclines;
    set p_total_lines = p_total_lines + v_member_lines;
    -- Fetch next member; handler sets V_EOF on EOF
    set v_eof = 0;
    fetch c_members
      into v_member;
  end while;
  close c_members;
end;


-- ============================================================
-- Example call
-- ============================================================
begin
  declare v_members decimal(10, 0);
  declare v_lines decimal(15, 0);
  call vpcrzkh1.count_lines(
    'VPCRZKH1',
    'QRPGLESRC',
    v_members,
    v_lines
  );
  -- call qsys2.send_message(
  -- message_id => 'CPF9898',
  -- message_length => 10,
  -- message_text => cast(v_members as varchar(15)),
  -- message_file_library => 'QSYS',
  -- message_file => 'QCPFMSG',
  -- message_queue_library => 'QUSRSYS',
  -- message_queue => 'VPCRZKH'
  -- );
  
end;