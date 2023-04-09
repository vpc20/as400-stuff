create table vpcrzkh1/msgpfx as (                                 
SELECT MSGCODE as message_code, 
       MSGDESC as message_desc 
FROM msgpf
) with data  

DSPFFD FILE(MSGPFX) OUTPUT(*OUTFILE) OUTFILE(VPCRZKH1/FFD1)   

create table vpcrzkh1/ffd2 as (      
select a.*, ROW_NUMBER() OVER () rn  
from ffd1 a                          
) with data                          


create table vpcrzkh1/fldnames as (       
Select                                    
   MAX(CASE WHEN rn = 1                   
            THEN whalis END) as fld1,     
   MAX(CASE WHEN rn = 2                   
            THEN whalis END) as fld2      
FROM vpcrzkh1/ffd2                        
) with data  

CPYTOIMPF FROMFILE(VPCRZKH1/FLDNAMES)           
          TOSTMF('/home/VPCRZKH/test1')         
          MBROPT(*REPLACE)                      
          STMFCODPAG(*PCASCII)                  
          RCDDLM(*CRLF)                         

CPYTOIMPF FROMFILE(VPCRZKH1/MSGPF)                    
          TOSTMF('/home/VPCRZKH/test1')               
          MBROPT(*ADD)                                
          STMFCODPAG(*PCASCII)                  
          RCDDLM(*CRLF)                               


