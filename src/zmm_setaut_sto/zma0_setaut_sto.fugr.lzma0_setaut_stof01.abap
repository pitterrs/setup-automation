*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_STOF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  EXECUTE_DOCTYPE
*&---------------------------------------------------------------------*

FORM execute_doctype .

  FREE r_doctype.

  r_doctype = NEW #(
  im_request = wa_screen-0100-request
  im_ref_plant = wa_screen-0100-ref_plant
  im_new_plant = wa_screen-0100-new_plant
   ).

  CHECK r_doctype IS BOUND.

  TRY.
      r_doctype->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.
