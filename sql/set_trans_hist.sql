--#SET TERMINATOR #
create table parts (
         inv_num int,
         part_name char(20),
         on_hand int,
         max_inv int,
         primary key (inv_num)
      );

create table transaction_history (
         inv_num int,
         posttime timestamp,
         transaction_type char(1)
      );


create trigger set_trans_hist
      after insert or update or delete on parts
      referencing new as n old as o 
      for each row mode db2sql
   begin
      insert into transaction_history
         values
            (
               case
                  when inserting
                     or updating then n.inv_num
                  when deleting then o.inv_num
               end,
               current timestamp,
               case
                  when inserting then 'I'
                  when updating then 'U'
                  when deleting then 'D'
               end
            );
   end;  


insert into parts
   values
      (
         123,
         '250k potentiometer',
         100,
         3000
      );

select * from parts;
select * from transaction_history;

