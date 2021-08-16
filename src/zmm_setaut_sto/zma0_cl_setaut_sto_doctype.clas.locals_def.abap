CLASS lcl_batch_input DEFINITION DEFERRED.

INTERFACE lif_doctype.
  TYPES tt_batch_input TYPE TABLE OF REF TO lcl_batch_input
    WITH DEFAULT KEY.

  TYPES: BEGIN OF ty_doctype,
           reswk TYPE t161w-reswk,
           werks TYPE t161w-werks,
           bstyp TYPE t161w-bstyp,
           bsart TYPE t161w-bsart,
         END OF ty_doctype.

  TYPES tt_doctype TYPE SORTED TABLE OF ty_doctype
  WITH NON-UNIQUE KEY primary_key COMPONENTS bstyp reswk
  WITH NON-UNIQUE SORTED KEY secondary_key COMPONENTS bstyp werks.

  TYPES ttr_plants TYPE RANGE OF werks_d.
ENDINTERFACE.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        VALUE(im_request)           TYPE REF TO  zma0_cl_setaut_request
        VALUE(im_document_category) TYPE bstyp.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_new_plant)          TYPE werks_d
        VALUE(im_is_supplying_plant) TYPE abap_bool
        VALUE(im_document_category)  TYPE bstyp.

    METHODS get_document_category
      RETURNING
        VALUE(re_result) TYPE bstyp.

    METHODS set_document_category
      IMPORTING
        VALUE(im_document_category) TYPE bstyp.

    METHODS get_ref_plant_info
      RETURNING
        VALUE(re_result)
          TYPE lif_doctype=>tt_doctype.

    METHODS set_ref_plant_info
      IMPORTING
        VALUE(im_ref_plant_info)
          TYPE lif_doctype=>tt_doctype.

    METHODS call_transaction REDEFINITION.

  PRIVATE SECTION.

    DATA document_category TYPE bstyp.
    DATA ref_plant_info TYPE lif_doctype=>tt_doctype.

ENDCLASS.

CLASS lcl_sto_doctype_dao DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        VALUE(im_plants) TYPE lif_doctype=>ttr_plants.

    METHODS get_doctype
      RETURNING
        VALUE(re_result) TYPE lif_doctype=>tt_doctype.

    METHODS set_doctype
      IMPORTING
        VALUE(im_doctype) TYPE lif_doctype=>tt_doctype.

  PRIVATE SECTION.
    DATA doctype TYPE lif_doctype=>tt_doctype.
    METHODS retrieve_doctype
      IMPORTING
        im_plants        TYPE lif_doctype=>ttr_plants
      RETURNING
        VALUE(re_result) TYPE lif_doctype=>tt_doctype.

ENDCLASS.
