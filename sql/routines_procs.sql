﻿
select * 
from qsys2.sysroutines
where routine_type = 'PROCEDURE'
and   routine_schema = 'VPCRZKH1';

select * 
from qsys2.sysroutines
where specific_schema = 'VPCRZKH1';
-- and   specific_name = 'RESSET';