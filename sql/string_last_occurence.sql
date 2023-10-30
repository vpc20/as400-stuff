set current schema vpcrkzh1;

select right('first.last@yahoo.com', length('first.last@yahoo.com') - locate_in_string('first.last@yahoo.com', '.', -1, 1))
  from sysibm.sysdummy1;

-- last occurence of .
select substr('first.last@yahoo.com', locate_in_string('first.last@yahoo.com', '.', -1, 1))
  from sysibm.sysdummy1;

-- second to the last occurence of .
select substr('first.last@yahoo.com.ph', locate_in_string('first.last@yahoo.com.ph', '.', -1, 2))
  from sysibm.sysdummy1;
  
  
  