FUNCTION ZMA0_SETAUT_DEF_SHIP_DATA_STO.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_REQUEST) TYPE REF TO  ZMA0_CL_SETAUT_REQUEST
*"     VALUE(IM_REF_PLANT) TYPE  ZMA0_SETAUT_RPLANT
*"     VALUE(IM_NEW_PLANT) TYPE  ZMA0_SETAUT_NPLANT
*"  EXPORTING
*"     VALUE(EX_ACTION) TYPE  ZMA0_SETAUT_STATUS
*"----------------------------------------------------------------------
  CLEAR wa_screen.

  wa_screen-0100-ref_plant = im_ref_plant.
  wa_screen-0100-new_plant = im_new_plant.
  wa_screen-0100-request   = im_request.

  CALL SCREEN 0100.

  ex_action = zma0_cl_setaut_utils=>convert_action_to_status(
                wa_screen-0100-action
              ).

ENDFUNCTION.
