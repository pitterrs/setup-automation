*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_SDSF01.
*----------------------------------------------------------------------*
FORM execute_plant_parameters .

  FREE r_define_ship_data_sto.

  r_define_ship_data_sto = NEW #(
      im_request   = wa_screen-0100-request
      im_ref_plant = wa_screen-0100-ref_plant
      im_new_plant = wa_screen-0100-new_plant
  ).

  CHECK r_define_ship_data_sto IS BOUND.

  TRY.
      r_define_ship_data_sto->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.
