CLASS zma0_cl_setaut_def_frgn_trade DEFINITION
                                    PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tty_foreign_trade_msg TYPE TABLE OF zma0v_setaut_ftm
           WITH DEFAULT KEY.

    INTERFACES zma0_if_setaut_process.

    METHODS constructor
      IMPORTING
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant
        VALUE(im_new_plant) TYPE zma0_setaut_nplant
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request.

    METHODS get_ref_plant
      RETURNING VALUE(re_ref_plant) TYPE zma0_setaut_rplant.

    METHODS set_ref_plant
      IMPORTING VALUE(im_ref_plant) TYPE zma0_setaut_rplant.

    METHODS get_database
      RETURNING VALUE(re_database) TYPE REF TO object.

    METHODS set_database
      IMPORTING VALUE(im_database) TYPE REF TO object.

    METHODS get_new_plant
      RETURNING VALUE(re_new_plant) TYPE zma0_setaut_nplant.

    METHODS set_new_plant
      IMPORTING VALUE(im_new_plant) TYPE zma0_setaut_nplant.

    METHODS get_request
      RETURNING VALUE(re_request) TYPE REF TO zma0_cl_setaut_request .

    METHODS set_request
      IMPORTING VALUE(im_request) TYPE REF TO zma0_cl_setaut_request.

     METHODS get_reference_data
      RETURNING VALUE(re_reference_data) TYPE
                  zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

    METHODS set_reference_data
      IMPORTING VALUE(im_reference_data) TYPE
                  zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA database TYPE REF TO lcl_foreign_trade_msg_dao.

    DATA ref_plant TYPE zma0_setaut_rplant.

    DATA new_plant TYPE zma0_setaut_nplant.

    DATA request TYPE REF TO zma0_cl_setaut_request.

    DATA reference_data
        TYPE zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

    METHODS get_registers_to_be_copied
      RETURNING
        VALUE(re_result)
          TYPE zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

ENDCLASS.



CLASS zma0_cl_setaut_def_frgn_trade IMPLEMENTATION.

  METHOD constructor.

    me->set_ref_plant( im_ref_plant ).
    me->set_new_plant( im_new_plant ).
    me->set_request( im_request ).

    DATA(lr_database) = NEW lcl_foreign_trade_msg_dao(
        im_ref_plant = im_ref_plant
        im_new_plant = im_new_plant
     ).

    me->set_database( lr_database ).

    me->reference_data = me->get_registers_to_be_copied( ).

  ENDMETHOD.

  METHOD get_ref_plant.

    re_ref_plant = me->ref_plant.

  ENDMETHOD.

  METHOD set_ref_plant.

    me->ref_plant = im_ref_plant.

  ENDMETHOD.

  METHOD get_new_plant.

    re_new_plant = me->new_plant.

  ENDMETHOD.

  METHOD set_new_plant.

    me->new_plant = im_new_plant.

  ENDMETHOD.

  METHOD get_database.

    re_database ?= me->database.

  ENDMETHOD.

  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.

  METHOD get_request.

    re_request = me->request.

  ENDMETHOD.

  METHOD set_request.

    me->request = im_request.

  ENDMETHOD.

  METHOD get_registers_to_be_copied.

    re_result = me->database->get_def_frgn_trade( ).

  ENDMETHOD.

  METHOD get_reference_data.

    re_reference_data = me->reference_data.

  ENDMETHOD.

  METHOD set_reference_data.

    me->reference_data = im_reference_data.

  ENDMETHOD.

  METHOD zma0_if_setaut_process~execute.

    DATA(lr_batch_input) = NEW lcl_batch_input( me->get_request( ) ).

    CHECK me->reference_data IS NOT INITIAL.

    lr_batch_input->fill_bdcdata(
      EXPORTING
        im_foreign_trade_msg = me->reference_data
        im_new_plant         = me->get_new_plant(  )
    ).

    lr_batch_input->call_transaction(  ).

  ENDMETHOD.

ENDCLASS.
