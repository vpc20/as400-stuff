             /* REGISTER AS A STORED PROCEDURE SEND_PGM_MSG */                                          
                                                                                                        
             PGM        PARM(&MSG)                                                                      
                                                                                                        
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(512)                                                  
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*PRV) MSGTYPE(*INFO)                                           
                                                                                                        
             ENDPGM                                                                                     