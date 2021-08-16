*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_PGCI01.
*----------------------------------------------------------------------*

MODULE exit INPUT.
  CASE wa_screen-0100-action.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE wa_screen-0100-action.
    WHEN 'EXE' OR 'ERT'.
        PERFORM execute_purch_group_creation.
    WHEN 'SKIP'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
