INTERFACE lif_purch_group.

  TYPES: BEGIN OF ty_purch_group,
           purch_group TYPE ekgrp,
           description TYPE eknam,
         END OF ty_purch_group.

ENDINTERFACE.

CLASS lcl_purch_group_dao DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_code) TYPE ekgrp.

    METHODS get_purch_group
      RETURNING
        VALUE(re_result) TYPE lif_purch_group=>ty_purch_group.

    METHODS set_purch_group
      IMPORTING
        VALUE(im_purch_group) TYPE lif_purch_group=>ty_purch_group.

  PRIVATE SECTION.

    DATA purch_group TYPE lif_purch_group=>ty_purch_group.

    METHODS retrieve_purch_group
      IMPORTING
        VALUE(im_code)   TYPE ekgrp
      RETURNING
        VALUE(re_result) TYPE lif_purch_group=>ty_purch_group.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_purch_group_code) TYPE ekgrp
        VALUE(im_purch_group_desc) TYPE eknam.

ENDCLASS.
