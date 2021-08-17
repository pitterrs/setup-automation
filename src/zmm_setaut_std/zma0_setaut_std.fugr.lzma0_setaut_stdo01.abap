*----------------------------------------------------------------------*
***INCLUDE LZMA0_SETAUT_STDO01.
*----------------------------------------------------------------------*

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'GUI_0100'.
  SET TITLEBAR 'TITLE_0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  DISPLAY_ALV  OUTPUT
*&---------------------------------------------------------------------*
MODULE display_alv OUTPUT.

  perform display_alv.

ENDMODULE.
