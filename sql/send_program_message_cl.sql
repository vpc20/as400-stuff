create procedure vpcrzkh1.send_pgm_msg (
        in msg char(512)
      )
    language cl
    external name 'VPCRZKH1/SNDPGMMSGX'
    parameter style general;

call vpcrzkh1.send_pgm_msg('Hello from SQL');


