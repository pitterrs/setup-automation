CLASS zma0_cl_setaut_purchorg DEFINITION PUBLIC  FINAL CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES zma0_if_setaut_process .

    METHODS constructor
      IMPORTING
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request
        VALUE(im_ref_plant) TYPE werks_d
        VALUE(im_new_plant) TYPE werks_d.

    METHODS set_ref_plant
      IMPORTING
        VALUE(im_ref_plant) TYPE werks_d.

    METHODS set_new_plant
      IMPORTING
        VALUE(im_new_plant) TYPE werks_d.

    METHODS get_ref_plant
      RETURNING
        VALUE(re_result) TYPE werks_d.

    METHODS get_new_plant
      RETURNING
        VALUE(re_result) TYPE werks_d.

    METHODS set_database
      IMPORTING
        VALUE(im_database) TYPE REF TO object.

    METHODS get_database
      RETURNING
        VALUE(re_result) TYPE REF TO object.

    METHODS is_created
      IMPORTING
        VALUE(im_plant)  TYPE werks_d
      RETURNING
        VALUE(re_result) TYPE abap_bool.

  PRIVATE SECTION.

    DATA ref_plant TYPE werks_d.

    DATA new_plant TYPE werks_d.

    DATA database TYPE REF TO lcl_purchorg_dao.

    DATA request TYPE REF TO zma0_cl_setaut_request.

    METHODS get_register_to_be_copied
      RETURNING
        VALUE(re_result) TYPE lif_purchorg=>tt_purchorg.

ENDCLASS.


CLASS zma0_cl_setaut_purchorg IMPLEMENTATION.
  METHOD constructor.

    me->ref_plant = im_ref_plant.
    me->new_plant     = im_new_plant.

    me->request = im_request.

    me->database = NEW #( im_plants = VALUE lif_purchorg=>ttr_plant(
        (
            sign = 'I'
            option = 'EQ'
            low = im_new_plant
         )
         (
            sign = 'I'
            option = 'EQ'
            low = im_ref_plant
         )
      )
     ).

  ENDMETHOD.

  METHOD get_ref_plant.

    re_result = me->ref_plant.

  ENDMETHOD.

  METHOD get_new_plant.

    re_result = me->new_plant.

  ENDMETHOD.

  METHOD get_database.

    re_result ?= me->database.

  ENDMETHOD.

  METHOD set_ref_plant.

    me->ref_plant = im_ref_plant.

  ENDMETHOD.

  METHOD set_new_plant.

    me->new_plant = im_new_plant.

  ENDMETHOD.

  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.


  METHOD is_created.

    re_result = COND #(
    WHEN FILTER #(
        me->database->get_purchorg( )
        WHERE werks = im_plant
    ) IS NOT INITIAL
    THEN abap_true ELSE abap_false
    ).

  ENDMETHOD.

METHOD zma0_if_setaut_process~execute.

    DATA(lt_ref_plant_info) = me->get_register_to_be_copied( ).

    CHECK lt_ref_plant_info IS NOT INITIAL.

    DATA(lr_batch_input) = NEW lcl_batch_input( me->request ).

    lr_batch_input->fill_bdcdata(
        im_new_plant = me->new_plant
        im_ref_plant_info = lt_ref_plant_info

     ).

    lr_batch_input->call_transaction(  ).

  ENDMETHOD.

  METHOD get_register_to_be_copied.

    DATA(lt_ref_plant_info) = FILTER lif_purchorg=>tt_purchorg(
                me->database->get_purchorg( )
                WHERE werks = me->ref_plant
                ).

    DATA(lt_new_plant_info) = FILTER lif_purchorg=>tt_purchorg(
                me->database->get_purchorg( )
                WHERE werks = me->new_plant
                ).

    LOOP AT lt_ref_plant_info INTO DATA(lw_ref_plant_info).

      CHECK NOT line_exists( lt_new_plant_info[
              werks = me->new_plant
              ekorg = lw_ref_plant_info-ekorg
               ] ).
      APPEND lw_ref_plant_info TO re_result.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
