*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PLAF01.
*----------------------------------------------------------------------*
FORM execute_plant_parameters.

  FREE r_plant_parameters.

  r_plant_parameters = NEW #(
      im_request   = wa_screen-0100-request
      im_ref_plant = wa_screen-0100-ref_plant
      im_new_plant = wa_screen-0100-new_plant
  ).

  CHECK r_plant_parameters IS BOUND.

  TRY.
      r_plant_parameters->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.
