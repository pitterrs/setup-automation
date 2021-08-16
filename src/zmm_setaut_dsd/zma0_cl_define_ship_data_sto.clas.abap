CLASS zma0_cl_define_ship_data_sto DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zma0_if_setaut_process .

    METHODS constructor
      IMPORTING
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant
        VALUE(im_new_plant) TYPE zma0_setaut_nplant .

    METHODS get_ref_plant
      RETURNING
        VALUE(re_result) TYPE zma0_setaut_rplant .

    METHODS set_ref_plant
      IMPORTING
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant .

    METHODS get_new_plant
      RETURNING
        VALUE(re_result) TYPE zma0_setaut_nplant .

    METHODS set_new_plant
      IMPORTING
        VALUE(im_new_plant) TYPE zma0_setaut_nplant .

    METHODS get_database
      RETURNING
        VALUE(re_result) TYPE REF TO object .

    METHODS set_database
      IMPORTING
        VALUE(im_database) TYPE REF TO object .

    METHODS is_created
      RETURNING
        VALUE(re_return) TYPE abap_bool .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA ref_plant   TYPE zma0_setaut_rplant.
    DATA new_plant   TYPE zma0_setaut_nplant.
    DATA request     TYPE REF TO zma0_cl_setaut_request.
    DATA database    TYPE REF TO lcl_def_ship_data_dao.
    DATA batch_input TYPE REF TO lcl_batch_input.


ENDCLASS.



CLASS zma0_cl_define_ship_data_sto IMPLEMENTATION.


  METHOD constructor.

    me->ref_plant = im_ref_plant.
    me->new_plant = im_new_plant.
    me->request   = im_request.

    DATA(lr_database) = NEW lcl_def_ship_data_dao(
        VALUE #(
            (  sign = 'I' option = 'EQ' low = im_ref_plant )
            (  sign = 'I' option = 'EQ' low = im_new_plant )
        )
     ).

    me->set_database( lr_database ).

  ENDMETHOD.


  METHOD get_database.

    re_result = me->database.

  ENDMETHOD.


  METHOD get_new_plant.

    re_result = me->new_plant.

  ENDMETHOD.


  METHOD get_ref_plant.

    re_result = me->ref_plant.

  ENDMETHOD.


  METHOD is_created.

    DATA(lt_plant_data) =
        FILTER lif_def_ship_data=>tty_plant_info(
            me->database->get_plant_data( )
            WHERE plant = CONV #( me->get_new_plant( ) )
        ).

    IF lt_plant_data IS INITIAL.
      re_return = abap_false.
    ELSE.
      re_return = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.


  METHOD set_new_plant.

    me->new_plant = im_new_plant.

  ENDMETHOD.


  METHOD set_ref_plant.

    me->ref_plant = im_ref_plant.

  ENDMETHOD.


  METHOD zma0_if_setaut_process~execute.

    CHECK me->is_created( ).

    me->batch_input = NEW lcl_batch_input( me->request ).

    DATA(lt_plant_data) = me->database->get_plant_data(  ).

    CHECK line_exists( lt_plant_data[ plant = me->ref_plant ] ).

    DATA(lw_plant_data) = lt_plant_data[ plant = me->ref_plant ].

    me->batch_input->fill_bdcdata(
    im_new_plant = me->new_plant
    im_sales_org = lw_plant_data-sales_org
    im_dist_channel = lw_plant_data-dist_channel
    im_ship_point = lw_plant_data-ship_point
    im_division = lw_plant_data-division
    ).

    me->batch_input->call_transaction(  ).

  ENDMETHOD.
ENDCLASS.
