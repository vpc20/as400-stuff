--  category:  IBM i Services
--  description:  Application - Data Queue Entries
--

--
-- Data queue example
--
cl:CRTDTAQ DTAQ(VPCRZKH1/OrderDQ) MAXLEN(100) SEQ(*KEYED) KEYLEN(3);

call qsys2.send_data_queue(message_data       => 'Sue - Dilly Bar',
                           data_queue         => 'ORDERDQ', 
                           data_queue_library => 'VPCRZKH1',
                           key_data           => '010');
call qsys2.send_data_queue(message_data       => 'Sarah - Ice cream cake!',
                           data_queue         => 'ORDERDQ', 
                           data_queue_library => 'VPCRZKH1',
                           key_data           => '020');
call qsys2.send_data_queue(message_data       => 'Scott - Strawberry Sundae',
                           data_queue         => 'ORDERDQ', 
                           data_queue_library => 'VPCRZKH1',
                           key_data           => '030');
call qsys2.send_data_queue(message_data       => 'Scott - Pineapple Shake',
                           data_queue         => 'ORDERDQ', 
                           data_queue_library => 'VPCRZKH1',
                           key_data           => '030');

-- Search what's on the DQ
select message_data, key_data from table
     (qsys2.data_queue_entries('ORDERDQ', 'VPCRZKH1', 
                               selection_type => 'KEY',
                               key_data       => '030',
                               key_order      => 'EQ'));


-- Order fulfilled!
select message_data, message_data_utf8, message_data_binary, key_data, sender_job_name, sender_current_user
  from table (
      qsys2.receive_data_queue(
        data_queue => 'ORDERDQ', data_queue_library => 'VPCRZKH1', 
        remove => 'YES',
        wait_time => 0, 
        key_data => '030', 
        key_order => 'EQ')
    );


-- What remains on the queue?
select * from table
     (qsys2.data_queue_entries('ORDERDQ', 'VPCRZKH1', 
                               selection_type => 'KEY',
                               key_data       => '030',
                               key_order      => 'LE'));      
                               
                               
CALL QSYS2.CLEAR_DATA_QUEUE('ORDERDQ', 'VPCRZKH1');


--------------------------------------------------------------------------------
-- testing for vpcrzkh1/sampledq
--------------------------------------------------------------------------------

-- query info about the data queue                           
SELECT *
FROM   QSYS2.DATA_QUEUE_INFO
WHERE  data_queue_library = 'VPCRZKH1'
AND    data_queue_name    = 'SAMPLEDQ';     

-- clear data queue
CALL QSYS2.CLEAR_DATA_QUEUE('SAMPLEDQ', 'VPCRZKH1');

-- query all data in the data queue
SELECT *
  FROM TABLE (
      qsys2.data_queue_entries('SAMPLEDQ', 'VPCRZKH1')
    );

-- query data queue message - sent from java program
SELECT
  CAST(SUBSTR(MESSAGE_DATA, 1, 10) AS CHAR(10) CCSID 37) AS MSG_TEXT,
  INTERPRET(CAST(SUBSTR(MESSAGE_DATA, 11, 7) AS BINARY(7)) AS NUMERIC(7, 2)) AS ZONED_POS,
  INTERPRET(CAST(SUBSTR(MESSAGE_DATA, 18, 7) AS BINARY(7)) AS NUMERIC(7, 2)) AS ZONED_NEG,
  INTERPRET(CAST(SUBSTR(MESSAGE_DATA, 25, 4) AS BINARY(4)) AS DECIMAL(7, 2)) AS PACKED_POS,
  INTERPRET(CAST(SUBSTR(MESSAGE_DATA, 29, 4) AS BINARY(4)) AS DECIMAL(7, 2)) AS PACKED_NEG,
  INTERPRET(CAST(SUBSTR(MESSAGE_DATA, 33, 4) AS BINARY(4)) AS INTEGER) AS BINARY_POS,
  INTERPRET(CAST(SUBSTR(MESSAGE_DATA, 37, 4) AS BINARY(4)) AS INTEGER) AS BINARY_NEG
 FROM TABLE(
  QSYS2.DATA_QUEUE_ENTRIES('SAMPLEDQ', 'VPCRZKH1')
);


-- *** this does not work
-- SELECT
  -- SUBSTR(MESSAGE_DATA, 1, 10) AS WS_MSG_TEXT,
-- INTERPRET(BINARY(SUBSTR(MESSAGE_DATA, 11, 7)) AS NUMERIC(7, 2)) AS WS_MSG_ZONED_POS,
-- INTERPRET(BINARY(SUBSTR(MESSAGE_DATA, 18, 7)) AS NUMERIC(7, 2)) AS WS_MSG_ZONED_NEG,
-- INTERPRET(BINARY(SUBSTR(MESSAGE_DATA, 25, 4)) AS DECIMAL(7, 2)) AS WS_MSG_PACKED_POS,
-- INTERPRET(BINARY(SUBSTR(MESSAGE_DATA, 29, 4)) AS DECIMAL(7, 2)) AS WS_MSG_PACKED_NEG,
-- INTERPRET(BINARY(SUBSTR(MESSAGE_DATA, 33, 4)) AS INTEGER) AS WS_MSG_BINARY_POS,
-- INTERPRET(BINARY(SUBSTR(MESSAGE_DATA, 37, 4)) AS INTEGER) AS WS_MSG_BINARY_NEG
-- FROM TABLE(
  -- QSYS2.DATA_QUEUE_ENTRIES('SAMPLEDQ', 'VPCRZKH1')
-- );
  

-- send data queue    
call qsys2.send_data_queue(message_data       => 'Data from Run SQL Scripts app',
                           data_queue         => 'SAMPLEDQ', 
                           data_queue_library => 'VPCRZKH1');
                           

select * from vpcrzkh1.flatfile;                  
