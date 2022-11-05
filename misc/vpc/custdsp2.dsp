     A*%%TS  SD  20000323  092954  ITVICTOR    REL-V3R7M0  5716-PW1
     A*%%EC
     A                                      DSPSIZ(24 80 *DS3)
     A                                      PRINT
     A                                      ERRSFL
     A          R REC1
     A*%%TS  SD  20000323  092954  ITVICTOR    REL-V3R7M0  5716-PW1
     A                                      CA03
     A                                      CA04
     A                                      CA06
     A                                      CA07
     A                                      CA08
     A                                      CA09
     A                                      RTNCSRLOC(&CURREC &CURFLD)
     A  60                                  CSRLOC(CURROW     CURCOL)
     A            CURROW         3S 0H
     A            CURCOL         3S 0H
     A            CURREC        10A  H
     A            CURFLD        10A  H
     A                                  1  2'CUSTRPG2'
     A            DUMMY1         1A  O  1 12
     A  03                                  ERRMSGID(MSG0003 *LIBL/TESTMSGF)
     A                                  1 33'ABC Corporation'
     A                                  1 73DATE
     A                                      EDTCDE(Y)
     A                                  2  2USER
     A                                  2 31'Customer Maintenance'
     A            MODE           7A  O  2 73
     A                                  4  2'Customer Number :'
     A            CUSTNO    R        B  4 20REFFLD(CUSTPR/CUSTNO *LIBL/CUSTPF)
     A                                      EDTCDE(4)
     A  01                                  ERRMSGID(MSG0001 *LIBL/TESTMSGF)
     A  02                                  ERRMSGID(MSG0002 *LIBL/TESTMSGF)
     A  04                                  ERRMSGID(MSG0004 *LIBL/TESTMSGF)
     A                                 22  2'F3=Exit   F4=Prompt   F6=Add   F7=-
     A                                      Change   F8=Delete   F9=Display'
     A          R REC2
     A*%%TS  SD  20000322  154808  ITVICTOR    REL-V3R7M0  5716-PW1
     A                                      CA03
     A                                      CA12
     A                                  1  2'CUSTRPG2'
     A            DUMMY2         1A  O  1 12
     A  75                                  ERRMSGID(MSG0005 *LIBL/TESTMSGF)
     A                                  1 33'ABC Corporation'
     A                                  1 73DATE
     A                                      EDTCDE(Y)
     A                                  2  2USER
     A                                  2 31'Customer Maintenance'
     A            MODE           7A  O  2 73
     A                                  4  2'Customer Number :'
     A            CUSTNO    R        O  4 20REFFLD(CUSTPR/CUSTNO *LIBL/CUSTPF)
     A                                      EDTCDE(4)
     A                                  5  2'Customer name   :'
     A            CNAME     R        B  5 20REFFLD(CUSTPR/CNAME *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                  7  2'Street Address  :'
     A            CSTRT     R        B  7 20REFFLD(CUSTPR/CSTRT *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                  8  2'City            :'
     A            CCITY     R        B  8 20REFFLD(CUSTPR/CCITY *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                  9  2'State           :'
     A            CSTATE    R        B  9 20REFFLD(CUSTPR/CSTATE *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                 10  2'Zip code        :'
     A            CZIP      R        B 10 20REFFLD(CUSTPR/CZIP *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                 12  2'Contact Person  :'
     A            CCONT     R        B 12 20REFFLD(CUSTPR/CCONT *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                 13  2'Contact Title   :'
     A            CCTITL    R        B 13 20REFFLD(CUSTPR/CCTITL *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                 14  2'Phone Number    :'
     A            CPHONE    R        B 14 20REFFLD(CUSTPR/CPHONE *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                      EDTCDE(4)
     A                                 16  2'Last order date :'
     A            CLORDT    R        O 16 20REFFLD(CUSTPR/CLORDT *LIBL/CUSTPF)
     A                                 17  2'Current Balance :'
     A            CBALNC    R        O 17 20REFFLD(CUSTPR/CBALNC *LIBL/CUSTPF)
     A                                 18  2'Good Credit Y/N?:'
     A            CCRFLG    R        B 18 20REFFLD(CUSTPR/CCRFLG *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                 19  2'Notes           :'
     A            NOTES1    R        B 19 20REFFLD(CUSTPR/NOTES1 *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A            NOTES2    R        B 20 20REFFLD(CUSTPR/NOTES2 *LIBL/CUSTPF)
     A  75                                  DSPATR(PR)
     A                                 22  2'F3=Exit   F12=Cancel'
