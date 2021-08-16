FUNCTION-POOL zmm_setaut_psa.               "MESSAGE-ID ..

* INCLUDE LZMM_SETAUT_PSAD...                " Local class definition
TYPES: BEGIN OF ty_0100,
         ref_plant TYPE werks_d,
         new_plant TYPE werks_d,
         request   TYPE REF TO zma0_cl_setaut_request,
         action    TYPE sy-ucomm,
       END OF ty_0100.

TYPES: BEGIN OF ty_screen,
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA wa_screen TYPE ty_screen.
DATA r_creation_profile TYPE REF TO zma0_cl_setaut_creation_prf.
