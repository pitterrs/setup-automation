*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_POPO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'GUI_0100'.
  SET TITLEBAR 'TITLE_0100'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*

MODULE user_command_0100 INPUT.

  CASE wa_screen-0100-action.
    WHEN 'EXE'.
      PERFORM execute_purchorg.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*

MODULE exit INPUT.
  CASE wa_screen-0100-action.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR'SKIP'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
