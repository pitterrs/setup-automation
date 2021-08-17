FORM execute_creation_prf_creation.

  CHECK r_creation_profile IS BOUND.

  r_creation_profile->set_reference_data( t_reference_data ).

  TRY.
      r_creation_profile->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages(  ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

  ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv .

  IF r_psa_alv IS NOT BOUND.

    " Reserve screen space within the custom control for the ALV
    " presentation at the screen 0100
    DATA(lr_psa_container) = NEW cl_gui_custom_container(
        container_name = 'CC_PSA_REFERENCE_DATA'
    ).

    " Create the ALV object
    r_psa_alv = zma0_cl_salv_buddy=>factory(
      EXPORTING
          im_container = lr_psa_container
      CHANGING
          ch_data      = t_reference_data
    ).

    " Set event for custom columns preparation
    "SET HANDLER lcl_event=>handle_columns_preparation FOR r_psa_alv.

    " Display ALV report with CRUD options
    r_psa_alv->display( ).

  ELSE.

    r_psa_alv->refresh( ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FETCH_REFERENCE_DATA
*&---------------------------------------------------------------------*
FORM fetch_reference_data .

  FREE r_creation_profile.
  FREE t_reference_data.

  r_creation_profile =  NEW #(
      im_new_plant = wa_screen-0100-new_plant
      im_ref_plant = wa_screen-0100-ref_plant
      im_request = wa_screen-0100-request
  ).

  CHECK r_creation_profile IS BOUND.

  t_reference_data = r_creation_profile->get_reference_data( ).

ENDFORM.
