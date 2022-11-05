     A*%%TS  SD  20000322  142246  ITVICTOR    REL-V3R7M0  5716-PW1
     A*==============================================================*
     A* Display file name: CUSTDSPF                                  *
     A*                                                              *
     A* Purpose: Display List Panel for Selecting Customers          *
     A*==============================================================*
     A*
     A*%%EC
     A                                      DSPSIZ(24 80 *DS3)
     A                                      REF(*LIBL/CUSTPF)
     A                                      CA03
     A                                      CA12
     A                                      PAGEDOWN
     A*
     A          R CSFL                      SFL
     A*%%TS  SD  20000322  142246  ITVICTOR    REL-V3R7M0  5716-PW1
     A            SELIO          1Y 0B  7  2VALUES(0 1)
     A                                      CHKMSGID(CPD6A7C *LIBL/QCPFMSG)
     A                                      EDTCDE(4)
     A            CNAME     R        O  7  6
     A            CUSTNO    R        O  7 39REFFLD(CUSTPR/CUSTNO *LIBL/CUSTPF)
     A            CSTATE    R        O  7 49REFFLD(CUSTPR/CSTATE *LIBL/CUSTPF)
     A*
     A          R CSFLCTL                   SFLCTL(CSFL)
     A*%%TS  SD  20000322  142246  ITVICTOR    REL-V3R7M0  5716-PW1
     A                                      SFLSIZ(0101)
     A                                      SFLPAG(0010)
     A                                      WINDOW(CSFLCMD)
     A                                      BLINK
     A                                      OVERLAY
     A  41                                  SFLDSP
     A                                      SFLDSPCTL
     A  40                                  SFLCLR
     A  41                                  SFLEND(*MORE)
     A            RCDNBR         4S 0H      SFLRCDNBR
     A                                  1 21'Customer Selection'
     A                                      DSPATR(HI)
     A                                  3  1'Type options, press Enter.'
     A                                      COLOR(BLU)
     A                                  4  3'1=Select'
     A                                      COLOR(BLU)
     A                                  4 14'Position to customer . .'
     A            NCNAME        20A  I  4 39
     A                                  6  1'Opt'
     A                                      DSPATR(HI)
     A                                      DSPATR(UL)
     A                                  6  6'Customer Name                 '
     A                                      DSPATR(HI)
     A                                      DSPATR(UL)
     A                                  6 39'Cust No'
     A                                      DSPATR(UL)
     A                                  6 48'State'
     A                                      DSPATR(UL)
      *
     A          R CSFLCMD
     A                                      WINDOW(3 14 19 59)
     A                                 18  1'F3=Exit'
     A                                      COLOR(BLU)
     A                                 18 12'F12=Cancel'
     A                                      COLOR(BLU)
      *
     A          R DUMMY
     A                                      ASSUME
     A                                  1  3' '
