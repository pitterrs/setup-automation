FUNCTION-POOL zma0_setaut_std.              "MESSAGE-ID ..

* INCLUDE LZMA0_SETAUT_STDD...               " Local class definition


TYPES: BEGIN OF ty_0100,
         new_plant TYPE zma0_setaut_nplant,
         ref_plant TYPE zma0_setaut_rplant,
         request   TYPE REF TO zma0_cl_setaut_request,
         action    TYPE sy-ucomm,
       END OF ty_0100.

TYPES: BEGIN OF ty_screen,
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA wa_screen TYPE ty_screen.
DATA r_stock_t_data_set TYPE REF TO zma0_cl_setaut_stock_t_data.
DATA r_std_alv TYPE REF TO zma0_cl_salv_buddy.
DATA t_reference_data TYPE
ZMA0_CL_SETAUT_STOCK_T_DATA=>tty_STOCK_T_DATA2.
