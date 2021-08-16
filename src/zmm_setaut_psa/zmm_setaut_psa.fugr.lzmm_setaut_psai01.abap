*----------------------------------------------------------------------*
***INCLUDE LZMM_SETAUT_PSAI01.
*----------------------------------------------------------------------*

MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR 'SKIP'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
