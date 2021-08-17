FUNCTION ZMA0_SETAUT_CREATION_PROFILE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_REF_PLANT) TYPE  WERKS_D
*"     VALUE(IM_NEW_PLANT) TYPE  WERKS_D
*"     VALUE(IM_REQUEST) TYPE REF TO  ZMA0_CL_SETAUT_REQUEST
*"  EXPORTING
*"     REFERENCE(EX_ACTION) TYPE  ZMA0_SETAUT_STATUS
*"----------------------------------------------------------------------
  CLEAR wa_screen.

  wa_screen-0100-ref_plant = im_ref_plant.
  wa_screen-0100-new_plant = im_new_plant.
  wa_screen-0100-request = im_request.

  IF im_ref_plant IS NOT INITIAL.
    PERFORM fetch_reference_data.
  ENDIF.

  CALL SCREEN 0100.

  ex_action = zma0_cl_setaut_utils=>convert_action_to_status(
                wa_screen-0100-action
              ).

ENDFUNCTION.
