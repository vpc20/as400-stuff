**free
ctl-opt main(Main);

// Declare the Display File
dcl-f confboxds workstn usropn indds(indic) usage(*output:*input);

// Constants for the passed parameter
dcl-c kAdd 'ADD';
dcl-c kChg 'CHG';
dcl-c kDel 'DEL';

// Function Keys defined in the Display File Indicators
dcl-ds indic qualified;
    F12_Exit       ind pos(12);
end-ds;

// Main Procedure
dcl-proc Main;
    dcl-pi *n;
        pAction    char(3) const;
        pConfirmed ind;           // Pass the result back through this parameter
    end-pi;

    open confboxds;

  // Set the message based on the parameter
    select;
        when pAction = kAdd;
            MSGTXT = 'Confirm creation of record';
        when pAction = kChg;
            MSGTXT = 'Confirm update of record';
        when pAction = kDel;
            MSGTXT = 'Confirm deletion of record';
        other;
            MSGTXT = 'Invalid Action';
    endsl;

  // Display the window
    exfmt WDWREC1;

  // Logic: Return *ON if Enter is pressed (no function keys),
  // Return *OFF if F12 is pressed.
    if indic.F12_Exit;
        pConfirmed = *off;
    else;
        pConfirmed = *on;
    endif;

    close confboxds;

end-proc;
