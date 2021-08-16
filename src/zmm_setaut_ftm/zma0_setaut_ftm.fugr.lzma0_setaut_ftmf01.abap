*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PMTF01.
*----------------------------------------------------------------------*

FORM execute_process.

  CHECK r_foreign_trade_msg IS BOUND.

  r_foreign_trade_msg->set_reference_data( t_reference_data ).

  TRY.
      r_foreign_trade_msg->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.

FORM fetch_reference_data.

  FREE r_foreign_trade_msg.
  FREE t_reference_data.

  r_foreign_trade_msg = NEW #(
    im_request   = wa_screen-0100-request
    im_ref_plant = wa_screen-0100-ref_plant
    im_new_plant = wa_screen-0100-new_plant
  ).

  CHECK r_foreign_trade_msg IS BOUND.

  t_reference_data = r_foreign_trade_msg->get_reference_data( ).

ENDFORM.

FORM display_alv.

  IF r_alv2 IS NOT BOUND.

    " Reserve screen space within the custom control for the ALV
    " presentation at the screen 0100
    DATA(lr_container2) = NEW cl_gui_custom_container(
        container_name = 'CC_REFERENCE_DATA3'
    ).

    " Create the ALV object
    r_alv2 = zma0_cl_salv_buddy=>factory(
      EXPORTING
          im_container = lr_container2
      CHANGING
          ch_data      = t_reference_data
    ).

    " Set event for custom columns preparation
    SET HANDLER lcl_event=>handle_columns_preparation FOR r_alv2.

    " Display ALV report with CRUD options
    r_alv2->display( ).

  ELSE.

    r_alv2->refresh( ).

  ENDIF.

ENDFORM.
