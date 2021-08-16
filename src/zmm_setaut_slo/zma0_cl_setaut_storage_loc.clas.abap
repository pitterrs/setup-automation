CLASS zma0_cl_setaut_storage_loc DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zma0_if_setaut_process .

    TYPES tt_storage TYPE TABLE OF zma0v_setaut_slo
      WITH DEFAULT KEY.
*    TYPES tt_storage TYPE SORTED TABLE OF zma0v_setaut_slo
*      WITH UNIQUE KEY werks lgort.

    METHODS constructor
      IMPORTING
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request
        VALUE(im_ref_plant) TYPE werks_d
        VALUE(im_new_plant) TYPE werks_d.

    METHODS get_ref_plant
      RETURNING
        VALUE(re_result) TYPE werks_d .
    METHODS set_ref_plant
      IMPORTING
        VALUE(im_ref_plant) TYPE werks_d .
    METHODS get_new_plant
      RETURNING
        VALUE(re_result) TYPE werks_d .
    METHODS set_new_plant
      IMPORTING
        VALUE(im_new_plant) TYPE werks_d .
    METHODS get_request
      RETURNING
        VALUE(re_result) TYPE REF TO zma0_cl_setaut_request .
    METHODS set_request
      IMPORTING
        VALUE(im_request) TYPE REF TO zma0_cl_setaut_request .
    METHODS get_reference_data
      RETURNING VALUE(re_result)
        TYPE zma0_cl_setaut_storage_loc=>tt_storage.
    METHODS set_reference_data
      IMPORTING VALUE(im_reference_data)
        TYPE zma0_cl_setaut_storage_loc=>tt_storage.

  PRIVATE SECTION.
    DATA ref_plant TYPE werks_d.
    DATA new_plant TYPE werks_d.
    DATA request TYPE REF TO zma0_cl_setaut_request.
    DATA database TYPE REF TO lcl_storage_loc_dao.

    METHODS get_registers_to_be_copied
      RETURNING
        VALUE(re_result) TYPE zma0_cl_setaut_storage_loc=>tt_storage.

ENDCLASS.

CLASS zma0_cl_setaut_storage_loc IMPLEMENTATION.

  METHOD constructor.
    me->ref_plant = im_ref_plant.
    me->new_plant = im_new_plant.
    me->request   = im_request.

    me->database = NEW #( im_plants = VALUE lif_storage=>ttr_plants(
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

  METHOD set_ref_plant.
    me->ref_plant = im_ref_plant.
  ENDMETHOD.

  METHOD get_new_plant.
    re_result = me->new_plant.
  ENDMETHOD.

  METHOD set_new_plant.
    me->new_plant = im_new_plant.
  ENDMETHOD.

  METHOD get_request.
    re_result = me->request.
  ENDMETHOD.

  METHOD set_request.
    me->request = im_request.
  ENDMETHOD.

  METHOD get_registers_to_be_copied.

    " Using FOR as it's not possible to filter non-sorted tables and we
    " need non-sorted table for SALV display
    DATA(lt_ref_plant_info) =
      VALUE zma0_cl_setaut_storage_loc=>tt_storage(
        FOR line IN me->database->get_storage( )
        WHERE ( werks = me->ref_plant )
        ( line )
      ).

*    DATA(lt_ref_plant_info) =
*              FILTER zma0_cl_setaut_storage_loc=>tt_storage(
*                me->database->get_storage(  )
*                WHERE werks = me->ref_plant
*              ).

    DATA(lt_new_plant_info) =
      VALUE zma0_cl_setaut_storage_loc=>tt_storage(
        FOR line IN me->database->get_storage( )
        WHERE ( werks = me->new_plant )
        ( line )
      ).
*    DATA(lt_new_plant_info) =
*              FILTER zma0_cl_setaut_storage_loc=>tt_storage(
*                me->database->get_storage( )
*                WHERE werks = me->new_plant
*              ).

    LOOP AT lt_ref_plant_info INTO DATA(lw_ref_plant_info).

      CHECK NOT line_exists( lt_new_plant_info[
                lgort = lw_ref_plant_info-lgort
                ] ).

      APPEND lw_ref_plant_info TO re_result.

    ENDLOOP.
  ENDMETHOD.

  METHOD zma0_if_setaut_process~execute.

    DATA(lt_ref_plant_info) = me->get_registers_to_be_copied(  ).

    CHECK lt_ref_plant_info IS NOT INITIAL.

    DATA(lr_batch_input) = NEW lcl_batch_input( me->request ).

    lr_batch_input->fill_bdcdata(
    im_new_plant = me->new_plant
    im_ref_plant_info = lt_ref_plant_info
     ).

    lr_batch_input->call_transaction( ).

  ENDMETHOD.

  METHOD get_reference_data.
    re_result = me->database->get_storage( ).
  ENDMETHOD.

  METHOD set_reference_data.
    me->database->SET_STORAGE( im_reference_data ).
  ENDMETHOD.

ENDCLASS.
