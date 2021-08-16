*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_POPF01.
*----------------------------------------------------------------------*

FORM execute_purchorg.

  FREE r_purchorg.

  r_purchorg = NEW #(
  im_request = wa_screen-0100-request
  im_ref_plant = wa_screen-0100-ref_plant
  im_new_plant = wa_screen-0100-new_plant
   ).

  CHECK r_purchorg IS BOUND.

  TRY.
      r_purchorg->zma0_if_setaut_process~execute( ).
    CATCH zma0_cx_setaut_bdc_error INTO DATA(lr_error).
      lr_error->display_messages( ).
      EXIT.
  ENDTRY.

*  IF lt_messages IS NOT INITIAL.
*
*    DATA(lw_message) = lt_messages[ 1 ].
*
*    IF lw_message-msgid = '00' AND lw_message-msgnr = '344'.
*
*      MESSAGE i001(zma0_setaut) DISPLAY LIKE 'E'.
*      EXIT.
*
*    ELSE.
*
*      MESSAGE ID lw_message-msgid TYPE lw_message-msgtyp
*      NUMBER lw_message-msgnr WITH lw_message-msgv1 lw_message-msgv2
*      lw_message-msgv3 lw_message-msgv4.
*
*      CHECK NOT line_exists( lt_messages[ msgtyp = 'E' ] ).
*
*    ENDIF.
*
*  ENDIF.
*
*  BREAK-POINT.
*
  LEAVE TO SCREEN 0.

ENDFORM.
