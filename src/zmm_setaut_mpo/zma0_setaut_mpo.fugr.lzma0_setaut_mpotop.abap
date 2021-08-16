FUNCTION-POOL ZMA0_SETAUT_MPO.

TYPES:  BEGIN OF ty_0100,
          purch_group TYPE ekorg,
          desc        TYPE ekotx,
          request     TYPE REF TO zma0_cl_setaut_request,
          action      TYPE sy-ucomm,
        END OF ty_0100.

TYPES: BEGIN OF ty_screen,
         0100 TYPE ty_0100,
       END OF ty_screen.

DATA: wa_screen TYPE ty_screen.

DATA r_maintain_purch_org TYPE REF TO zma0_cl_setaut_mtn_purch_org.

DATA r_alv3 TYPE REF TO zma0_cl_salv_buddy.

DATA t_purch_org_data TYPE
    zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.
