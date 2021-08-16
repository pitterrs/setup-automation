CLASS lcl_batch_input DEFINITION DEFERRED.

INTERFACE lif_stock_t_data.

  TYPES ttr_plant TYPE RANGE OF werks_d.

  TYPES tt_batch_input TYPE TABLE OF REF TO lcl_batch_input
  WITH DEFAULT KEY.

ENDINTERFACE.

CLASS lcl_stock_t_data_dao DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_plants) TYPE lif_stock_t_data=>ttr_plant.

    METHODS get_stock_t_data
      RETURNING
        VALUE(re_result)
          TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

    METHODS set_stock_t_data
      IMPORTING
        VALUE(im_stock_t_data)
          TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

  PRIVATE SECTION.

    DATA stock_t_data
    TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

    METHODS retrieve_stock_t_data
      IMPORTING
        VALUE(im_plants) TYPE lif_stock_t_data=>ttr_plant
      RETURNING
        VALUE(re_result)
          TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO zma0_cl_setaut_request
        VALUE(im_document_category) TYPE bstyp.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_new_plant)
          TYPE zma0_setaut_nplant.

    METHODS get_document_category
      RETURNING
        VALUE(re_result) TYPE bstyp.

    METHODS set_document_category
      IMPORTING
        VALUE(im_document_category) TYPE bstyp.

    METHODS get_ref_plant_info
      RETURNING
        VALUE(re_result)
          TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

    METHODS set_ref_plant_info
      IMPORTING
        VALUE(im_ref_plant_info)
          TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

  PRIVATE SECTION.

    DATA document_category TYPE bstyp.

    DATA ref_plant_info
        TYPE zma0_cl_setaut_stock_t_data=>tt_stock_t_data.

ENDCLASS.
