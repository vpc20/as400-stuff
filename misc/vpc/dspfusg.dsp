     A*%%TS  SD  20010213  103153  ITVICTOR    REL-V4R2M0  5769-PW1
     A*
     A*%%EC
     A                                      DSPSIZ(24 80 *DS3)
     A                                      INDARA
     A                                      CA03
     A                                      PAGEDOWN
     A                                      PAGEUP
     A          R SFLREC1                   SFL
     A*%%TS  SD  20010213  095908  ITVICTOR    REL-V4R2M0  5769-PW1
     A            FILENAME      10A  O  8  2
     A            FILEDESC      50A  O  8 14
     A            USGINP         1A  O  8 66
     A            USGOUT         1A  O  8 69
     A            USGUPD         1A  O  8 72
     A          R SFLCTL1                   SFLCTL(SFLREC1)
     A*%%TS  SD  20010213  103153  ITVICTOR    REL-V4R2M0  5769-PW1
     A                                      SFLSIZ(0500)
     A                                      SFLPAG(0013)
     A                                      OVERLAY
     A  80                                  SFLEND
     A  80                                  SFLDSP
     A  81                                  SFLDSPCTL
     A N81                                  SFLCLR
     A                                  1  2SYSNAME
     A                                  1 72DATE
     A                                      EDTCDE(Y)
     A                                  2  2USER
     A                                  2 72TIME
     A            PROGNAME      10A  O  4 13
     A                                  5  2'Library  :'
     A            LIBRNAME      10A  O  5 13
     A                                  6 67'Usage'
     A                                      COLOR(WHT)
     A                                  7 14'Description                       -
     A                                                      '
     A                                      COLOR(WHT)
     A                                  7 66'I  O  U'
     A                                      COLOR(WHT)
     A                                  1 32'Display File Usage'
     A                                      DSPATR(HI)
     A                                  4  2'Program  :'
     A                                  7  2'Filename'
     A                                      DSPATR(HI)
     A          R FKEYS1
     A*%%TS  SD  20001215  171319  ITVICTOR    REL-V4R2M0  5769-PW1
     A                                 22  2'F3=Exit'
     A                                      COLOR(BLU)
