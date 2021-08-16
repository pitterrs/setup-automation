FUNCTION-POOL zma0_setaut_slo.              "MESSAGE-ID ..

TYPES:  BEGIN OF ty_0100,
          ref_plant TYPE zma0_setaut_rplant,
          new_plant TYPE zma0_setaut_nplant,
          action    TYPE sy-ucomm,
          request   TYPE REF TO zma0_cl_setaut_request,
        END OF ty_0100.

TYPES: BEGIN OF ty_screen,
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA wa_screen TYPE ty_screen.
DATA r_storage TYPE REF TO zma0_cl_setaut_storage_loc.

DATA t_reference_data TYPE
    zma0_cl_setaut_storage_loc=>tt_storage.

DATA cl_salv_buddy TYPE REF TO zma0_cl_salv_buddy.


DATA lr_alv TYPE REF TO cl_salv_table.

* INCLUDE LZMA0_SETAUT_SLOD...               " Local class definition
