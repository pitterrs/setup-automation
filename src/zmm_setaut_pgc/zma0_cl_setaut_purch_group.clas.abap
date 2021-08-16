CLASS zma0_cl_setaut_purch_group DEFINITION " Singleton
    PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zma0_if_setaut_process.

    METHODS constructor
      IMPORTING
        VALUE(im_request)     TYPE REF TO zma0_cl_setaut_request
        VALUE(im_purch_group) TYPE ekgrp
        VALUE(im_description) TYPE eknam.

    METHODS get_purch_group
      RETURNING
        VALUE(re_result) TYPE ekgrp.

    METHODS set_purch_group
      IMPORTING
        VALUE(im_purch_group) TYPE ekgrp.

    METHODS get_description
      RETURNING
        VALUE(re_result) TYPE eknam.

    METHODS set_description
      IMPORTING
        VALUE(im_description) TYPE eknam.

    METHODS set_database
      IMPORTING
        VALUE(im_database) TYPE REF TO object.

    METHODS get_database
      RETURNING
        VALUE(re_result) TYPE REF TO object.

    METHODS is_created
      RETURNING
        VALUE(re_result) TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA purch_group TYPE ekgrp.
    DATA description TYPE eknam.
    DATA database    TYPE REF TO lcl_purch_group_dao.
    DATA request     TYPE REF TO zma0_cl_setaut_request.
    DATA batch_input TYPE REF TO lcl_batch_input.

ENDCLASS.

CLASS zma0_cl_setaut_purch_group IMPLEMENTATION.

  METHOD constructor.

    me->purch_group = im_purch_group.
    me->description = im_description.
    me->request = im_request.

    " Select the database information
    me->database = NEW #( im_purch_group ).

    " Create batch input instance
    me->batch_input = NEW lcl_batch_input( me->request ).

    me->batch_input->fill_bdcdata(
        im_purch_group_code = im_purch_group
        im_purch_group_desc = im_description
     ).

  ENDMETHOD.

  METHOD get_purch_group.

    re_result = me->purch_group.

  ENDMETHOD.

  METHOD set_purch_group.

    me->purch_group = im_purch_group.

  ENDMETHOD.

  METHOD get_description.

    re_result = me->description.

  ENDMETHOD.

  METHOD set_description.

    me->description = im_description.

  ENDMETHOD.

  METHOD get_database.

    re_result ?= me->database.

  ENDMETHOD.

  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.

  METHOD is_created.

    re_result = COND #(
        WHEN me->database->get_purch_group( ) IS INITIAL
        THEN abap_false ELSE abap_true
     ).

  ENDMETHOD.

  METHOD zma0_if_setaut_process~execute.

    CHECK NOT me->is_created( ). " Comment Test

    me->batch_input->call_transaction(  ).

  ENDMETHOD.

ENDCLASS.















