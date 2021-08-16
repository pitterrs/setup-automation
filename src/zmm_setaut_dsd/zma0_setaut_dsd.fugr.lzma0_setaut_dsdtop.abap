FUNCTION-POOL ZMA0_SETAUT_DSD.              "MESSAGE-ID ..

TYPES:  BEGIN OF ty_0100,
          ref_plant TYPE werks_d,
          new_plant TYPE werks_d,
          request   TYPE REF TO zma0_cl_setaut_request,
          action    TYPE sy-ucomm,
        END OF ty_0100.

TYPES: BEGIN OF ty_screen, "estrutura da tela com a leitura dos campos"
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA: wa_screen TYPE ty_screen.

DATA r_define_ship_data_sto TYPE REF TO zma0_cl_define_ship_data_sto.
