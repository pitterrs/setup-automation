*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_STDF01.
*----------------------------------------------------------------------*

FORM execute_set_stock_t_data .

  r_stock_t_data_set = NEW #(
      im_request = wa_screen-0100-request
      im_new_plant = wa_screen-0100-new_plant
      im_ref_plant = wa_screen-0100-ref_plant
  ).

  CHECK r_stock_t_data_set IS BOUND.

  TRY.
      r_stock_t_data_set->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.
