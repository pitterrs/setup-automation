*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZMA0_SETAUT_CONF
*   generation date: 26.05.2021 at 14:42:40
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZMA0_SETAUT_CONF   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
