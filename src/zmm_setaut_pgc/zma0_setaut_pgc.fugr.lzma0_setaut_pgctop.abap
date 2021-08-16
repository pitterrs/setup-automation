FUNCTION-POOL zma0_setaut_pgc.              "MESSAGE-ID ..

* INCLUDE LZMA0_SETAUT_PGCD...               " Local class definition

TYPES: BEGIN OF ty_0100, "estrutura dos campos"
         ekgrp  TYPE ekgrp,
         eknam  TYPE eknam,
         action TYPE sy-ucomm,
         request TYPE REF TO zma0_cl_setaut_request,
       END OF ty_0100.

TYPES: BEGIN OF ty_screen, "estrutura da tela com a leitura dos campos"
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA wa_screen TYPE ty_screen. "variavel para fazer a leitura dos valores da tela"
DATA r_purch_group_creation TYPE REF TO zma0_cl_setaut_purch_group.
