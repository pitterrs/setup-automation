*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PMTF01.
*----------------------------------------------------------------------*

FORM execute_process.

  CHECK r_maintain_purch_org IS NOT BOUND.

  r_maintain_purch_org = NEW #(
    im_purch_org = t_purch_org_data
    im_request   = wa_screen-0100-request
    ).

  TRY.
      r_maintain_purch_org->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

ENDFORM.

FORM add_purch_org.

  DATA lw_purch_org LIKE LINE OF t_purch_org_data.

  CHECK wa_screen-0100-purch_group IS NOT INITIAL.

  READ TABLE t_purch_org_data WITH KEY ekorg =
  wa_screen-0100-purch_group TRANSPORTING NO FIELDS.

  IF sy-subrc = 0.
    MESSAGE 'Purchasing Organization has already added'
       TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    lw_purch_org-mandt = sy-mandt.
    lw_purch_org-ekorg = wa_screen-0100-purch_group.
    lw_purch_org-ekotx = wa_screen-0100-desc.

    APPEND lw_purch_org TO t_purch_org_data.
  ENDIF.

  CLEAR: wa_screen-0100-purch_group, wa_screen-0100-desc.

ENDFORM.

FORM display_alv.

  IF r_alv3 IS NOT BOUND.

    " Reserve screen space within the custom control for the ALV
    " presentation at the screen 0100
    DATA(lr_container3) = NEW cl_gui_custom_container(
        container_name = 'CC_REFERENCE_DATA4'
    ).

    " Create the ALV object
    r_alv3 = zma0_cl_salv_buddy=>factory(
      EXPORTING
          im_container = lr_container3
      CHANGING
          ch_data      = t_purch_org_data
    ).

    " Set event for custom columns preparation
    SET HANDLER lcl_event=>handle_toolbar_preparation FOR r_alv3.

    " Display ALV report with CRUD options
    r_alv3->display( ).

  ELSE.

    r_alv3->refresh( ).

  ENDIF.

ENDFORM.
