FUNCTION-POOL zma0_setaut_pmt.

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

DATA r_plant_mat_type TYPE REF TO zma0_cl_setaut_plant_mat_type.

DATA r_alv TYPE REF TO zma0_cl_salv_buddy.

DATA t_reference_data TYPE
    zma0_cl_setaut_plant_mat_type=>tty_plant_mat_type.
