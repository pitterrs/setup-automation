*&---------------------------------------------------------------------*
*&  Include           LZMA0_SETAUT_CONFF01
*&---------------------------------------------------------------------*
FORM check_process_in_progress.

*  SELECT SINGLE COUNT( * )
*    FROM ZMA0_SETAUT_LOGM
*    WHERE ( STATUS = ' ' OR STATUS = 'E' ).
*

*  SELECT SINGLE *
*    FROM ZMA0_SETAUT_LOGM
*    INTO @DATA(lw_logm)
*    WHERE status = ' '.
*
*  IF sy-subrc = 0.
*    MESSAGE TEXT-001 TYPE 'E'.
*  ENDIF.

ENDFORM.
