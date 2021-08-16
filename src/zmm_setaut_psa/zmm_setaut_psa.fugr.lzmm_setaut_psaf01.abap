FORM execute_creation_prf_creation.

  FREE r_creation_profile.

  r_creation_profile =  NEW #(
      im_new_plant = wa_screen-0100-new_plant
      im_ref_plant = wa_screen-0100-ref_plant
      im_request = wa_screen-0100-request
  ).

  CHECK r_creation_profile IS BOUND.

  r_creation_profile->set_ref_plant( wa_screen-0100-ref_plant ).
  TRY.
      r_creation_profile->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages(  ).
      EXIT.
  ENDTRY.

  LEAVE TO SCREEN 0.

  ENDFORM.
