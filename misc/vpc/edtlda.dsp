     A*%%TS  SD  20000621  164231  ITVICTOR    REL-V3R7M0  5716-PW1
     A*%%EC
     A                                      DSPSIZ(24 80 *DS3)
     A                                      PRINT
     A                                      HLPRCD(HLPRCD)
     A                                      ALTHELP(CA01)
     A                                      CA03(03)
     A                                      CA12(12)
     A                                      HELP
     A          R DSPREC1
     A*%%TS  SD  20000621  164231  ITVICTOR    REL-V3R7M0  5716-PW1
     A                                  1  2USER
     A                                  1 31'Edit Local Data Area'
     A                                  1 73DATE
     A                                      EDTCDE(Y)
     A                                  2  2SYSNAME
     A                                  2 73TIME
     A                                  4  5'Offset'
     A                                  4 14'*...+....1....+....2....+....3....-
     A                                      +....4....+....5....+....6'
     A                                  5  8'0'
     A            LDA01         60A  B  5 14
     A                                  6  7'60'
     A            LDA02         60A  B  6 14
     A                                  7  6'120'
     A            LDA03         60A  B  7 14
     A                                  8  6'180'
     A            LDA04         60A  B  8 14
     A                                  9  6'240'
     A            LDA05         60A  B  9 14
     A                                 10  6'300'
     A            LDA06         60A  B 10 14
     A                                 11  6'360'
     A            LDA07         60A  B 11 14
     A                                 12  6'420'
     A            LDA08         60A  B 12 14
     A                                 13  6'480'
     A            LDA09         60A  B 13 14
     A                                 14  6'540'
     A            LDA10         60A  B 14 14
     A                                 15  6'600'
     A            LDA11         60A  B 15 14
     A                                 16  6'660'
     A            LDA12         60A  B 16 14
     A                                 17  6'720'
     A            LDA13         60A  B 17 14
     A                                 18  6'780'
     A            LDA14         60A  B 18 14
     A                                 19  6'840'
     A            LDA15         60A  B 19 14
     A                                 20  6'900'
     A            LDA16         60A  B 20 14
     A                                 21  6'960'
     A            LDA17         60A  B 21 14
     A                                 22  5'1020'
     A            LDA18          4A  B 22 14
     A                                 24  2'F3=Exit   F12=Exit'
     A          R HLPRCD
     A*%%TS  SD  20000616  114909  ITVICTOR    REL-V3R7M0  5716-PW1
     A                                  2  2'This program is so easy to use you-
     A                                       dont really need any help text.'
