             PGM

/* *CHAR - Character Variable */

             DCL        VAR(&TXT) TYPE(*CHAR) LEN(32) VALUE('Hello')


/* *LGL - A logical variable that contains a logical value of either '1' or '0' */

             DCL        VAR(&EOF) TYPE(*LGL)


/* *DEC - Packed Decimal */
/* AttributeDetails */
/* Digits            - 1 to 15 total digits */
/* Decimal positions - 0 to 9 (must be <= total digits) */
/* Default LEN(15 5) if not specified */

             DCL        VAR(&AMOUNT) TYPE(*DEC) LEN(15 5)/* -9999999999.99999 TO 9999999999.99999 */
             DCL        VAR(&QTY) TYPE(*DEC) LEN(7 0)    /* -9999999      to  9999999      */
             DCL        VAR(&PRICE) TYPE(*DEC) LEN(9 2)  /* -9999999.99   to  9999999.99   */


/* *INT - Integer (Signed Binary) */
/* LEN    Size            Range */
/* LEN(2) 2-byte signed - 32,768 to 32,767 */
/* LEN(4) 4-byte signed - 2,147,483,648 to 2,147,483,647 */
/* LEN(8) 8-byte signed - 9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 */

             DCL        VAR(&COUNT) TYPE(*INT) LEN(4)

             DCL        VAR(&SMALL) TYPE(*INT) LEN(2)   /* -32768 to 32767             */
             DCL        VAR(&NORMAL) TYPE(*INT) LEN(4)  /* ß-2.1 billion to ß2.1 billion */

             /* LEN(8) can be specified only if the CL source is compiled with the               */
             /* Create CL Module (CRTCLMOD) command or the Create Bound CL Program (CRTBNDCL)    */
             /* DCL        VAR(&BIG) TYPE(*INT) LEN(8)     ß-9.2 quintillion to ß9.2 quintillion */


/* *UINT - Unsigned Integer (V7R1+) */
/* LEN    Size              Range */
/* LEN(2) 2-byte unsigned - 0 to 65,535 */
/* LEN(4) 4-byte unsigned - 0 to 4,294,967,295 */
/* LEN(8) 8-byte unsigned - 0 to 18,446,744,073,709,551,615 */

             DCL        VAR(&FLAGS) TYPE(*UINT) LEN(4)

             SNDPGMMSG  MSG(&TXT) TOPGMQ(*EXT)

             ENDPGM
