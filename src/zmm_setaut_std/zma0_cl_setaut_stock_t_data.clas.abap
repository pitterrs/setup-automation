class ZMA0_CL_SETAUT_STOCK_T_DATA definition
  public
  final
  create public .

public section.

  interfaces ZMA0_IF_SETAUT_PROCESS .

  types:
    BEGIN OF ty_stock_t_data,
             bstyp      TYPE v_161v-bstyp,
             bsart      TYPE v_161v-bsart,
             reswk      TYPE v_161v-reswk,
             lfart      TYPE v_161v-lfart,
             prreg      TYPE v_161v-prreg,
             mevst      TYPE v_161v-mevst,
             merfp      TYPE v_161v-merfp,
             lfart1     TYPE v_161v-lfart1,
             lfart2     TYPE v_161v-lfart2,
             lfcon      TYPE v_161v-lfcon,
             atpconfmrp TYPE v_161v-atpconfmrp,
           END OF ty_stock_t_data .
  types:
    tt_stock_t_data TYPE SORTED TABLE OF ty_stock_t_data
      WITH NON-UNIQUE KEY primary_key COMPONENTS bstyp reswk
      WITH UNIQUE SORTED KEY secondary_key COMPONENTS bstyp bsart reswk .

  methods CONSTRUCTOR
    importing
      value(IM_NEW_PLANT) type ZMA0_SETAUT_NPLANT
      value(IM_REF_PLANT) type ZMA0_SETAUT_RPLANT
      value(IM_REQUEST) type ref to ZMA0_CL_SETAUT_REQUEST .
  methods GET_NEW_PLANT
    returning
      value(RE_RESULT) type ZMA0_SETAUT_NPLANT .
  methods SET_NEW_PLANT
    importing
      value(IM_NEW_PLANT) type ZMA0_SETAUT_NPLANT .
  methods GET_REF_PLANT
    returning
      value(RE_RESULT) type ZMA0_SETAUT_RPLANT .
  methods SET_REF_PLANT
    importing
      value(IM_REF_PLANT) type ZMA0_SETAUT_RPLANT .
  methods GET_DATABASE
    returning
      value(RE_RESULT) type ref to OBJECT .
  methods SET_DATABASE
    importing
      value(IM_DATABASE) type ref to OBJECT .
  methods GET_REQUEST
    returning
      value(RE_RESULT) type ref to ZMA0_CL_SETAUT_REQUEST .
  methods SET_REQUEST
    importing
      value(IM_REQUEST) type ref to ZMA0_CL_SETAUT_REQUEST .
  PRIVATE SECTION.

    DATA new_plant    TYPE zma0_setaut_nplant.
    DATA ref_plant    TYPE zma0_setaut_rplant.
    DATA request      TYPE REF TO zma0_cl_setaut_request.
    DATA database     TYPE REF TO lcl_stock_t_data_dao.
    DATA batch_inputs TYPE lif_stock_t_data=>tt_batch_input.

    METHODS get_registers_to_be_copied
      IMPORTING
        VALUE(im_document_category) TYPE bstyp
      RETURNING
        VALUE(re_result)
          TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

    METHODS create_batch_inputs
      RETURNING
        VALUE(re_result) TYPE lif_stock_t_data=>tt_batch_input.

ENDCLASS.



CLASS ZMA0_CL_SETAUT_STOCK_T_DATA IMPLEMENTATION.


  METHOD constructor.

    me->new_plant = im_new_plant.
    me->ref_plant = im_ref_plant.
    me->request   = im_request.

    me->database = NEW #(
        VALUE lif_stock_t_data=>ttr_plant(
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

    me->batch_inputs = me->create_batch_inputs( ).

  ENDMETHOD.


  METHOD create_batch_inputs.

    DATA lr_batch_input TYPE REF TO lcl_batch_input.

    DATA(lt_document_categories) = me->database->get_stock_t_data( ).
    DELETE ADJACENT DUPLICATES FROM lt_document_categories
    COMPARING bstyp.

    LOOP AT lt_document_categories INTO DATA(lw_document_category).

      FREE lr_batch_input.
      lr_batch_input = NEW #(
        im_request           = me->request
        im_document_category = lw_document_category-bstyp
      ).

      DATA(lt_registers_to_be_copied) =
        me->get_registers_to_be_copied( lw_document_category-bstyp ).

      CHECK lt_registers_to_be_copied IS NOT INITIAL.

      lr_batch_input->set_ref_plant_info( lt_registers_to_be_copied ).
      lr_batch_input->fill_bdcdata( me->new_plant ).

      APPEND lr_batch_input TO re_result.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_database.

    re_result ?= me->database.

  ENDMETHOD.


  METHOD get_new_plant.

    re_result = me->new_plant.

  ENDMETHOD.


  METHOD get_ref_plant.

    re_result = me->ref_plant.

  ENDMETHOD.


  METHOD get_registers_to_be_copied.

    DATA(lt_ref_plant_info) =
        FILTER zma0_cl_setaut_stock_t_data=>tt_stock_t_data(
            me->database->get_stock_t_data( )
            USING KEY primary_key
            WHERE bstyp = im_document_category
              AND reswk = me->ref_plant
    ).

    DATA(lt_new_plant_info) =
        FILTER zma0_cl_setaut_stock_t_data=>tt_stock_t_data(
            me->database->get_stock_t_data( )
            USING KEY primary_key
            WHERE bstyp = im_document_category
              AND reswk = me->new_plant
    ).

    LOOP AT lt_ref_plant_info INTO DATA(lw_ref_plant_info).
      CHECK NOT line_exists( lt_new_plant_info[
          KEY secondary_key
          bstyp = lw_ref_plant_info-bstyp
          bsart = lw_ref_plant_info-bsart
          reswk = me->new_plant
      ] ).
      APPEND lw_ref_plant_info TO re_result.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_request.

    re_result = me->request.

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


  METHOD set_request.

    me->request = im_request.

  ENDMETHOD.


  METHOD zma0_if_setaut_process~execute.

    LOOP AT me->batch_inputs INTO DATA(lr_batch_input).
      lr_batch_input->call_transaction( ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
