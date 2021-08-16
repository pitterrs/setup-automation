*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 26.05.2021 at 14:42:41
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZMA0_SETAUT_CONF................................*
DATA:  BEGIN OF STATUS_ZMA0_SETAUT_CONF              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMA0_SETAUT_CONF              .
CONTROLS: TCTRL_ZMA0_SETAUT_CONF
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMA0_SETAUT_CONF              .
TABLES: ZMA0_SETAUT_CONF               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
