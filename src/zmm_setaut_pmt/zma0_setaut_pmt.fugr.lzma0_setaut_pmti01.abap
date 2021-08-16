*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PMTI01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.

  CASE wa_screen-0100-action.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR 'SKIP'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE wa_screen-0100-action.
    WHEN 'EXE'.
      PERFORM execute_process.
    WHEN 'FETCH'.
      PERFORM fetch_reference_data.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
