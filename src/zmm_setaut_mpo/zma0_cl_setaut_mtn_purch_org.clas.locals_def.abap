CLASS lcl_maintain_purch_org DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_ttr_purch_org) TYPE
          zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    METHODS set_purch_org
      IMPORTING
        VALUE(im_purch_org) TYPE
          zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    METHODS get_purch_org
      RETURNING
        VALUE(re_purch_org) TYPE
          zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

  PRIVATE SECTION.

    METHODS retrive_purch_org
      RETURNING
        VALUE(re_purch_org) TYPE
          zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    DATA purch_org TYPE
         zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    DATA purch_org_data TYPE
         zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_purch_org_data)
          TYPE zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

ENDCLASS.
