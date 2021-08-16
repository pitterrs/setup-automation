*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_STDI01.
*----------------------------------------------------------------------*

MODULE exit INPUT.

  CASE wa_screen-0100-action.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR 'SKIP'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE wa_screen-0100-action.
    WHEN 'EXE'.
      PERFORM execute_set_stock_t_data.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
