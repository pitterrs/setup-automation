*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_SLOF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  EXECUTE_STORAGE
*&---------------------------------------------------------------------*

FORM execute_storage .
  DATA lt_ref_new_data TYPE zma0_cl_setaut_storage_loc=>tt_storage.
  FREE r_storage.

  r_storage = NEW #(
    im_request = wa_screen-0100-request
    im_ref_plant = wa_screen-0100-ref_plant
    im_new_plant = wa_screen-0100-new_plant
  ).

  CHECK r_storage IS BOUND.

  " Add lines of new plant
  " Used internally on execute to filter pre-existing data
  APPEND LINES OF VALUE zma0_cl_setaut_storage_loc=>tt_storage(
    FOR new_plant_line IN r_storage->get_reference_data( )
    WHERE ( werks = wa_screen-0100-new_plant )
    ( new_plant_line )
  ) TO lt_ref_new_data.

  " Add reference plant data
  APPEND LINES OF t_reference_data TO lt_ref_new_data.

  r_storage->set_reference_data( lt_ref_new_data ).

  TRY.
      r_storage->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.
ENDFORM.


FORM fetch_reference_data.

  FREE r_storage.
  FREE t_reference_data.

  r_storage = NEW #(
    im_request   = wa_screen-0100-request
    im_ref_plant = wa_screen-0100-ref_plant
    im_new_plant = wa_screen-0100-new_plant
  ).

  CHECK r_storage IS BOUND.

  " Get data for ref plant only
  t_reference_data = VALUE #(
    FOR line IN r_storage->get_reference_data( )
    WHERE ( werks = wa_screen-0100-ref_plant )
    ( line )
  ).

ENDFORM.

FORM build_alv.

  IF cl_salv_buddy IS NOT BOUND.

    DATA(lr_container) = NEW cl_gui_custom_container(
        container_name = 'CC_REFERENCE_DATA2'
    ).

    CHECK lr_container IS BOUND.

    cl_salv_buddy = zma0_cl_salv_buddy=>factory(
      EXPORTING
        im_container = lr_container
      CHANGING
        ch_data      = t_reference_data
    ).

    cl_salv_buddy->display( ).

  ELSE.

    cl_salv_buddy->refresh( ).

  ENDIF.

ENDFORM.
