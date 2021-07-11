             PGM

             OVRPRTF    FILE(QPQUPRFIL) DEVTYPE(*AFPDS) +
                          TOSTMF('/home/VPCRZKH/test1.pdf') +
                          WSCST(*PDF) OVRSCOPE(*CALLLVL)

             RUNQRY     QRY(*NONE) QRYFILE((MSGPF)) OUTTYPE(*PRINTER)

             ENDPGM
