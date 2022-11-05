     A*%%TS  SD  20001010  161309  ITVICTOR    REL-V4R2M0  5769-PW1
     A*
     A*%%EC
     A                                      DSPSIZ(24 80 *DS3)
     A                                      CF03(03)
     A          R REC1
     A*%%TS  SD  20001010  161309  ITVICTOR    REL-V4R2M0  5769-PW1
     A                                      OVERLAY
     A                                  1  3'Test message subfile'
     A                                  3  2'Field1'
     A            FLD001         5A  B  3 10
     A                                  4  2'Field2'
     A            FLD002        10A  B  4 10
     A                                  6  2'Field3'
     A            FLD003         3A  B  6 10VALUES('XXX' 'YYY' 'ZZZ')
     A                                 23  2'F3=Exit'
     A          R MSGSFL                    SFL
     A*%%TS  SD  20001010  094848  ITVICTOR    REL-V4R2M0  5769-PW1
     A                                      SFLMSGRCD(24)
     A            MSGKEY                    SFLMSGKEY
     A            PGMQ                      SFLPGMQ(10)
     A          R MSGCTL                    SFLCTL(MSGSFL)
     A*%%TS  SD  20001010  094848  ITVICTOR    REL-V4R2M0  5769-PW1
     A                                      KEEP
     A                                      SFLDSP
     A                                      SFLDSPCTL
     A  80                                  SFLINZ
     A  80                                  SFLEND
     A                                      SFLSIZ(0050)
     A                                      SFLPAG(0001)
     A            PGMQ                      SFLPGMQ(10)
