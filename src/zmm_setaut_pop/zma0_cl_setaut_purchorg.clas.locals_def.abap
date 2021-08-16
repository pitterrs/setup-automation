INTERFACE lif_purchorg.

*  TYPES:ty_purchorg TYPE zw_t024w_assign.
  TYPES:ty_purchorg TYPE t024w.
  TYPES tt_purchorg TYPE SORTED TABLE OF ty_purchorg
  WITH NON-UNIQUE KEY werks. "a chave irá o ordernar o sort da tabela"


  "range = terá + de 1 valor dentro do campo"
  TYPES ttr_plant
  TYPE RANGE OF werks_d. "elemento de dados que é do tipo do dominio"

ENDINTERFACE.

CLASS lcl_purchorg_dao DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_plants)  TYPE lif_purchorg=>ttr_plant
*        VALUE(im_purchorg) TYPE ekorg
        VALUE(im_is_test) TYPE abap_bool DEFAULT abap_false.


    METHODS get_purchorg
      RETURNING
        VALUE(re_result) TYPE lif_purchorg=>tt_purchorg.

    METHODS set_purchorg
      IMPORTING
        VALUE(im_purchorg) TYPE lif_purchorg=>tt_purchorg.


  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA purchorg TYPE lif_purchorg=>tt_purchorg.

    METHODS retrieve_purchorg_plants
      IMPORTING
        VALUE(im_plants) TYPE lif_purchorg=>ttr_plant
*        VALUE(im_purchorg) TYPE ekorg
      RETURNING
        VALUE(re_result) TYPE lif_purchorg=>tt_purchorg.


ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_new_plant)      TYPE werks_d
        VALUE(im_ref_plant_info) TYPE lif_purchorg=>tt_purchorg.

ENDCLASS.
