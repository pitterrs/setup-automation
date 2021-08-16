FUNCTION-POOL zma0_setaut_sto.              "MESSAGE-ID ..

TYPES:  BEGIN OF ty_0100,
          ref_plant TYPE zma0_setaut_rplant,
          new_plant TYPE zma0_setaut_nplant,
          action    TYPE sy-ucomm,
          request   TYPE REF TO zma0_cl_setaut_request,
        END OF ty_0100.

TYPES: BEGIN OF ty_screen, "estrutura da tela com a leitura dos campos"
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA: wa_screen TYPE ty_screen.
DATA r_doctype TYPE REF TO zma0_cl_setaut_sto_doctype.

* INCLUDE LZMA0_SETAUT_STOD...               " Local class definition
