--#SET TERMINATOR #
create function square (
         inval int
   )
   returns int
   language sql
   -- line below will enable debug
   -- set option dbgview = *source  
   begin
      return (inval * inval);
   end
   ;
   
select vpcrzkh1.square(4)
   from sysibm.sysdummy1;