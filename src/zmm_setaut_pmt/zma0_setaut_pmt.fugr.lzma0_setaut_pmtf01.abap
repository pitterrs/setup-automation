*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PMTF01.
*----------------------------------------------------------------------*

FORM execute_process.

  CHECK r_plant_mat_type IS BOUND.

  r_plant_mat_type->set_reference_data( t_reference_data ).

  TRY.
      r_plant_mat_type->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.

FORM fetch_reference_data.

  FREE r_plant_mat_type.
  FREE t_reference_data.

  r_plant_mat_type = NEW #(
    im_request   = wa_screen-0100-request
    im_ref_plant = wa_screen-0100-ref_plant
    im_new_plant = wa_screen-0100-new_plant
  ).

  CHECK r_plant_mat_type IS BOUND.

  t_reference_data = r_plant_mat_type->get_reference_data( ).

ENDFORM.

FORM display_alv.

  IF r_alv IS NOT BOUND.

    " Reserve screen space within the custom control for the ALV
    " presentation at the screen 0100
    DATA(lr_container) = NEW cl_gui_custom_container(
        container_name = 'CC_REFERENCE_DATA'
    ).

    " Create the ALV object
    r_alv = zma0_cl_salv_buddy=>factory(
      EXPORTING
          im_container = lr_container
      CHANGING
          ch_data      = t_reference_data
    ).

    " Set event for custom columns preparation
    SET HANDLER lcl_event=>handle_columns_preparation FOR r_alv.

    " Display ALV report with CRUD options
    r_alv->display( ).

  ELSE.

    r_alv->refresh( ).

  ENDIF.

ENDFORM.
