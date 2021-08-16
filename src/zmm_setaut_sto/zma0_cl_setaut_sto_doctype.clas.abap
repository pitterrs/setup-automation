CLASS zma0_cl_setaut_sto_doctype DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zma0_if_setaut_process .

    DATA is_supplying_plant TYPE abap_bool .

    METHODS constructor
      IMPORTING
        VALUE(im_ref_plant) TYPE werks_d
        VALUE(im_new_plant) TYPE werks_d
        VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request .
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
  PRIVATE SECTION.
    DATA ref_plant TYPE werks_d.
    DATA new_plant TYPE werks_d.
    DATA request   TYPE REF TO zma0_cl_setaut_request.
    DATA batch_inputs TYPE lif_doctype=>tt_batch_input.
    DATA database TYPE REF TO lcl_sto_doctype_dao.

    METHODS get_supplying_plant_copied
      IMPORTING
        VALUE(im_document_category) TYPE bstyp
      RETURNING
        VALUE(re_result)            TYPE lif_doctype=>tt_doctype.

    METHODS get_receiving_plant_copied
      IMPORTING
        VALUE(im_document_category) TYPE bstyp
      RETURNING
        VALUE(re_result)            TYPE lif_doctype=>tt_doctype.

    METHODS create_batch_inputs
      RETURNING
        VALUE(re_result) TYPE lif_doctype=>tt_batch_input.

ENDCLASS.

CLASS zma0_cl_setaut_sto_doctype IMPLEMENTATION.

  METHOD constructor.
    me->ref_plant = im_ref_plant.
    me->new_plant = im_new_plant.
    me->request   = im_request.

    me->database = NEW #( im_plants = VALUE lif_doctype=>ttr_plants(
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

    DATA(lt_document_categories) = me->database->get_doctype( ).
    DELETE ADJACENT DUPLICATES FROM lt_document_categories
    COMPARING bstyp.

    DATA lt_registers_to_be_copied TYPE lif_doctype=>tt_doctype.

    LOOP AT lt_document_categories INTO DATA(lw_document_category).

      FREE lr_batch_input.

      lr_batch_input = NEW #(
      im_request = me->request
      im_document_category = lw_document_category-bstyp
      ).

      lt_registers_to_be_copied =
        me->get_supplying_plant_copied( lw_document_category-bstyp ).

      IF lt_registers_to_be_copied IS NOT INITIAL.

        lr_batch_input->set_ref_plant_info( lt_registers_to_be_copied ).

        lr_batch_input->fill_bdcdata(
                       im_new_plant = me->new_plant
                       im_is_supplying_plant = me->is_supplying_plant
                       im_document_category = lw_document_category-bstyp
                       ).

        APPEND lr_batch_input TO re_result.
      ENDIF.

      FREE lt_registers_to_be_copied.
      FREE lr_batch_input.

      lr_batch_input = NEW #(
      im_request = me->request
      im_document_category = lw_document_category-bstyp
      ).

      lt_registers_to_be_copied =
        me->get_receiving_plant_copied( lw_document_category-bstyp ).

      IF lt_registers_to_be_copied IS NOT INITIAL.

        lr_batch_input->set_ref_plant_info( lt_registers_to_be_copied ).

        lr_batch_input->fill_bdcdata(
                       im_new_plant = me->new_plant
                       im_is_supplying_plant = me->is_supplying_plant
                       im_document_category = lw_document_category-bstyp
                       ).

        APPEND lr_batch_input TO re_result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_new_plant.
    re_result = me->new_plant.
  ENDMETHOD.

  METHOD get_receiving_plant_copied.
    "Filter all the entries where the ref plant is the Receiving WERKS"
    DATA(lt_ref_plant_info_r) = FILTER lif_doctype=>tt_doctype(
               me->database->get_doctype( )
               USING KEY secondary_key
               WHERE bstyp = im_document_category
               AND werks = me->ref_plant
               ).
    "Filter all the entries where the new plant is the Receiving WERKS"
    DATA(lt_new_plant_info_r) = FILTER lif_doctype=>tt_doctype(
            me->database->get_doctype( )
            USING KEY secondary_key
            WHERE bstyp = im_document_category
            AND werks = me->new_plant
            ).
    "The flag is false, important for the batch input
    is_supplying_plant = abap_false.

    "Check if there is any entry with the same Supplying RESWK plant in
    "both filters, avoid "the existing entry" error
    LOOP AT lt_ref_plant_info_r INTO DATA(lw_ref_plant_info_r).
      CHECK NOT line_exists( lt_new_plant_info_r[
              KEY primary_key
              reswk = lw_ref_plant_info_r-reswk
              bstyp = im_document_category
               ] ).

      APPEND lw_ref_plant_info_r TO re_result.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_ref_plant.
    re_result = me->ref_plant.
  ENDMETHOD.

  METHOD get_request.
    re_result = me->request.
  ENDMETHOD.

  METHOD get_supplying_plant_copied.
    DATA(lt_ref_plant_info_s) = FILTER lif_doctype=>tt_doctype(
               me->database->get_doctype( )
               USING KEY primary_key
               WHERE reswk = me->ref_plant
               AND   bstyp = im_document_category
               ).
    "Filter all the entries where the new plant is the Supplying RESWK
    DATA(lt_new_plant_info_s) = FILTER lif_doctype=>tt_doctype(
            me->database->get_doctype( )
            USING KEY primary_key
            WHERE bstyp = im_document_category
            AND reswk = me->new_plant
            ).
    "The flag is true, important for the batch input
    is_supplying_plant = abap_true.

    "Check if there is any entry with the same Receiving WERKS plant in
    "both filters, avoid "the existing entry" error
    LOOP AT lt_ref_plant_info_s INTO DATA(lw_ref_plant_info_s).
      CHECK NOT line_exists( lt_new_plant_info_s[
              KEY secondary_key
              werks = lw_ref_plant_info_s-werks
              bstyp = im_document_category
               ] ).

      APPEND lw_ref_plant_info_s TO re_result.

    ENDLOOP.

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
