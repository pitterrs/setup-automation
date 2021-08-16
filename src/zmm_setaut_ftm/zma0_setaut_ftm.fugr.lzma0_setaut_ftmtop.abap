FUNCTION-POOL ZMA0_SETAUT_FTM.

TYPES:  BEGIN OF ty_0100,
          ref_plant TYPE werks_d,
          new_plant TYPE werks_d,
          request   TYPE REF TO zma0_cl_setaut_request,
          action    TYPE sy-ucomm,
        END OF ty_0100.

TYPES: BEGIN OF ty_screen,
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA: wa_screen TYPE ty_screen.

DATA r_foreign_trade_msg TYPE REF TO zma0_cl_setaut_def_frgn_trade.

DATA r_alv2 TYPE REF TO zma0_cl_salv_buddy.

DATA t_reference_data TYPE
    zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.
