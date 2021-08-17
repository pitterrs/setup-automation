*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_STDF01.
*----------------------------------------------------------------------*

FORM execute_set_stock_t_data .

  CHECK r_stock_t_data_set IS BOUND.

  TRY.
      r_stock_t_data_set->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv .

  IF r_std_alv IS NOT BOUND.

    " Reserve screen space within the custom control for the ALV
    " presentation at the screen 0100
    DATA(lr_std_container) = NEW cl_gui_custom_container(
        container_name = 'CC_REFERENCE_DATA_STD'
    ).

    " Create the ALV object
    r_std_alv = zma0_cl_salv_buddy=>factory(
      EXPORTING
          im_container = lr_std_container
      CHANGING
          ch_data      = t_reference_data
    ).

    " Set event for custom columns preparation
    SET HANDLER lcl_event=>handle_toolbar_preparation FOR r_std_alv.

    " Display ALV report with CRUD options
    r_std_alv->display( ).

  ELSE.

    r_std_alv->refresh( ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FETCH_REFERENCE_DATA
*&---------------------------------------------------------------------*
FORM fetch_reference_data .

  FREE r_stock_t_data_set.
  FREE t_reference_data.

  r_stock_t_data_set = NEW #(
      im_request = wa_screen-0100-request
      im_new_plant = wa_screen-0100-new_plant
      im_ref_plant = wa_screen-0100-ref_plant
  ).

  CHECK r_stock_t_data_set IS BOUND.

  t_reference_data = r_stock_t_data_set->get_reference_data( ).

ENDFORM.
