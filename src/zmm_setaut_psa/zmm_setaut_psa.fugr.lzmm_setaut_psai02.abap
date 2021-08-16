*----------------------------------------------------------------------*
***INCLUDE LZMM_SETAUT_PSAI02.
*----------------------------------------------------------------------*

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EXE'.
      PERFORM execute_creation_prf_creation.
    WHEN 'SKIP'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
