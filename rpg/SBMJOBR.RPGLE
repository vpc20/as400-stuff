**free

     // =================================================================
     // Program . . . . . : SBMJOBR
     // Description . . . : Writes and Reads the SBMJOBD display file
     // =================================================================

     dcl-f sbmjobdspf workstn;

     // --- Main Program Logic ---

     // Loop continuously until the user presses F3 (Exit).
     dow *in03 = *off;

         exfmt sbmrec;

         // If F12 (Cancel) was pressed, exit the loop immediately.
         // The *IN12 indicator is linked to the CA12 keyword.
         if *in12 = *on;
             leave;
         endif;


     enddo;

     // --- Program Termination ---
     *inlr = *on;
     return;

