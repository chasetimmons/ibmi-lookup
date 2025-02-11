**free
//-------------------------------------------------------------------
// OBJECT: lookupr
// PURPOSE: quick file lookup
//
// AUTHOR: C.M.T.         DATE CREATED: 02/04/25
//-------------------------------------------------------------------
// TODO:
//-------------------------------------------------------------------
//-------------------------------------------------------------------
// MODIFICATIONS:
//-------------------------------------------------------------------
// DATE   MOD   AUTHOR     TEXT
// xxxxxx xxx   xxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//-------------------------------------------------------------------

//*******************************************************************
// Control Options                                                  *
//*******************************************************************
ctl-opt debug option(*srcstmt:*nodebugio);

//*******************************************************************
// Declarations                                                     *
//*******************************************************************
dcl-f lookupd workstn indds(dspf);
dcl-f filnam disk usage(*input) keyed;

dcl-ds dspf len(99);
  help ind pos(1);  // F1=Help
  exit ind pos(3);  // F3=Exit
  go   ind pos(6);  // F6=Go
  good ind pos(60); // no errors
  err  ind pos(61); // errors
  show ind pos(62); // show help info
end-ds;

dcl-ds key qualified; // key
  file char(2);       // file
  code char(3);       // code
end-ds;

// from a previous version; passes the message back to calling cl
// dcl-pi lkpi;
//   mesg char(50);
// end-pi;

//*******************************************************************
// Main Procedure                                                   *
//*******************************************************************
// ---
// begin processing loop
// ---
dow not exit;
  write f02; // write footer
  exfmt f01; // show display

  // toggle help display
  if help;   
    if show = *on;
      show = *off;
    else;
      show = *on;
    endif;
  endif;

  // build key from dspf entries
  key.file = file;
  key.code = code;

  // look up the request and display the result
  chain key filnam;
  if %found(filnam);
    mesg = field1;
    good = *on;
    err = *off;
  else;
    mesg = 'Not Found';
    good = *off;
    err = *on;
  endif;

  // this was used for a previous version of the program
  // it would send the result via sngpgmmsg
  // if go and good;
  //   leave;
  // endif;

enddo;
//*******************************************************************

*inlr = *on;
return;
