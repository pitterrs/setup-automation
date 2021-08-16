CLASS zma0_cl_plant_parameters DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zma0_if_setaut_process.

    METHODS constructor
      IMPORTING
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant
        VALUE(im_new_plant) TYPE zma0_setaut_nplant.


    METHODS get_ref_plant
      RETURNING
        VALUE(re_result) TYPE zma0_setaut_rplant.

    METHODS set_ref_plant
      IMPORTING
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant.

    METHODS get_new_plant
      RETURNING
        VALUE(re_result) TYPE zma0_setaut_nplant.

    METHODS set_new_plant
      IMPORTING
        VALUE(im_new_plant) TYPE zma0_setaut_nplant.

    METHODS get_database
      RETURNING
        VALUE(re_result) TYPE REF TO object.

    METHODS set_database
      IMPORTING
        VALUE(im_database) TYPE REF TO object.

    METHODS is_created
      RETURNING VALUE(re_return) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA ref_plant   TYPE zma0_setaut_rplant.
    DATA new_plant   TYPE zma0_setaut_nplant.
    DATA request     TYPE REF TO zma0_cl_setaut_request.
    DATA database    TYPE REF TO lcl_plant_parameters_dao.
    DATA batch_input TYPE REF TO lcl_batch_input.


ENDCLASS.



CLASS zma0_cl_plant_parameters IMPLEMENTATION.
  METHOD constructor.

    me->ref_plant = im_ref_plant.
    me->new_plant = im_new_plant.
    me->request   = im_request.

    DATA(lr_database) = NEW lcl_plant_parameters_dao(
        VALUE #(
            (  sign = 'I' option = 'EQ' low = im_ref_plant )
            (  sign = 'I' option = 'EQ' low = im_new_plant )
        )
     ).

    me->set_database( lr_database ).

  ENDMETHOD.

  METHOD get_ref_plant.

    re_result = me->ref_plant.

  ENDMETHOD.

  METHOD set_ref_plant.

    me->ref_plant = im_ref_plant.

  ENDMETHOD.

  METHOD get_new_plant.

    re_result = me->new_plant.

  ENDMETHOD.

  METHOD set_new_plant.

    me->new_plant = im_new_plant.

  ENDMETHOD.

  METHOD get_database.

    re_result = me->database.

  ENDMETHOD.

  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.

  METHOD is_created.

    DATA(lt_plant_parameters) =
        FILTER lif_plant_parameters=>tty_plant_info(
            me->database->get_plant_parameters( )
            WHERE plant = CONV #( me->get_new_plant( ) )
        ).

    IF lt_plant_parameters IS INITIAL.
      re_return = abap_false.
    ELSE.
      re_return = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD zma0_if_setaut_process~execute.

    CHECK me->is_created( ).

    me->batch_input = NEW lcl_batch_input( me->request ).

    me->batch_input->fill_bdcdata(
        im_ref_plant = me->ref_plant
        im_new_plant = me->new_plant
    ).

    me->batch_input->call_transaction(  ).

  ENDMETHOD.

ENDCLASS.
