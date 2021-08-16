*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PGCF01.
*----------------------------------------------------------------------*

FORM execute_purch_group_creation.

  FREE r_purch_group_creation.
  r_purch_group_creation = NEW #(
      im_request = wa_screen-0100-request
      im_purch_group = wa_screen-0100-ekgrp
      im_description = wa_screen-0100-eknam
  ).

  CHECK r_purch_group_creation IS BOUND.

  IF r_purch_group_creation->is_created( )
     AND wa_screen-0100-action = 'ERT'.

     MESSAGE 'Purchasing Group already created'
              TYPE 'I' DISPLAY LIKE 'E'.

     EXIT.

  ENDIF.

  TRY.
      r_purch_group_creation->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  CLEAR: WA_SCREEN-0100-ekgrp, WA_SCREEN-0100-eknam.

  IF wa_screen-0100-action = 'EXE'.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
