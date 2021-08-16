*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
INTERFACE lif_storage.

  TYPES: BEGIN OF ty_storage,
           werks TYPE t001l-werks,
           lgort TYPE t001l-lgort,
           lgobe TYPE t001l-lgobe,
         END OF ty_storage.

  TYPES ttr_plants TYPE RANGE OF werks_d.

ENDINTERFACE.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request)     TYPE REF TO zma0_cl_setaut_request.
*        VALUE(im_storage_loc) TYPE lgort.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_new_plant) TYPE werks_d
        VALUE(im_ref_plant_info)
          TYPE zma0_cl_setaut_storage_loc=>tt_storage.

        METHODS call_transaction REDEFINITION.

  PRIVATE SECTION.

*    DATA storage_loc    TYPE lgort.
    DATA ref_plant_info TYPE zma0_cl_setaut_storage_loc=>tt_storage.

ENDCLASS.

CLASS lcl_storage_loc_dao DEFINITION.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        VALUE(im_plants) TYPE lif_storage=>ttr_plants.

    METHODS get_storage
      RETURNING
        VALUE(re_result) TYPE zma0_cl_setaut_storage_loc=>tt_storage.

    METHODS set_storage
      IMPORTING
        VALUE(im_storage) TYPE zma0_cl_setaut_storage_loc=>tt_storage.

  PRIVATE SECTION.
    DATA storage TYPE zma0_cl_setaut_storage_loc=>tt_storage.

    METHODS retrieve_storage
      IMPORTING
        VALUE(im_plants) TYPE lif_storage=>ttr_plants
      RETURNING
        VALUE(re_result) TYPE zma0_cl_setaut_storage_loc=>tt_storage.

ENDCLASS.
