CLASS zma0_cl_setaut_mtn_purch_org DEFINITION PUBLIC FINAL
                                   CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tty_maintain_purch_org TYPE TABLE OF zma0v_setaut_mpo
           WITH DEFAULT KEY.

    INTERFACES zma0_if_setaut_process.

    METHODS constructor
      IMPORTING
        VALUE(im_purch_org) TYPE
                zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request.

    METHODS set_database
      IMPORTING
        VALUE(im_database) TYPE REF TO object.

    METHODS get_purch_org
      RETURNING
        VALUE(re_purch_org) TYPE
        zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    METHODS set_purch_org
      IMPORTING
        VALUE(im_purch_org) TYPE
        zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    METHODS get_request
      RETURNING VALUE(re_request) TYPE REF TO zma0_cl_setaut_request .

    METHODS set_request
      IMPORTING VALUE(im_request) TYPE REF TO zma0_cl_setaut_request.

    METHODS is_created
      RETURNING
        VALUE(re_return) TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA purch_org TYPE
        zma0_cl_setaut_mtn_purch_org=>tty_maintain_purch_org.

    DATA database TYPE REF TO lcl_maintain_purch_org.

    DATA request TYPE REF TO zma0_cl_setaut_request.

ENDCLASS.



CLASS zma0_cl_setaut_mtn_purch_org IMPLEMENTATION.

  METHOD constructor.

    me->set_purch_org( im_purch_org ).
    me->set_request( im_request ).

    DATA(lr_database) = NEW lcl_maintain_purch_org( im_purch_org ).

    me->set_database( lr_database ).

  ENDMETHOD.

  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.

  METHOD get_purch_org.

    re_purch_org = me->purch_org.

  ENDMETHOD.

  METHOD set_purch_org.

    me->purch_org = im_purch_org.

  ENDMETHOD.

  METHOD get_request.

    re_request = me->request.

  ENDMETHOD.

  METHOD set_request.

    me->request = im_request.

  ENDMETHOD.

  METHOD is_created.

    DATA(lt_purch_org) = me->database->get_purch_org( ).

    IF lt_purch_org IS INITIAL.
      re_return = abap_true.
    ELSE.
      re_return = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD zma0_if_setaut_process~execute.

    DATA(lr_batch_input) = NEW lcl_batch_input( me->get_request( ) ).

    CHECK me->is_created( ).

    lr_batch_input->fill_bdcdata(
      EXPORTING
        im_purch_org_data = me->purch_org
    ).

    lr_batch_input->call_transaction(  ).

  ENDMETHOD.

ENDCLASS.
