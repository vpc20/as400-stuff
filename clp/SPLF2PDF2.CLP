             PGM

             RUNQRY     QRY(*NONE) QRYFILE((MSGPF)) OUTTYPE(*PRINTER)

             CPYSPLF    FILE(QPQUPRFIL) TOFILE(*TOSTMF) +
                          SPLNBR(*LAST) +
                          TOSTMF('/home/VPCRZKH/test2.pdf') +
                          WSCST(*PDF) STMFOPT(*REPLACE)

             ENDPGM
