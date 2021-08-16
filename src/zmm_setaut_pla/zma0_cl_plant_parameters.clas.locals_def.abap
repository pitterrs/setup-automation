INTERFACE lif_plant_parameters.

  TYPES: BEGIN OF ty_plant_info,
           plant TYPE werks,
         END OF ty_plant_info.

  TYPES: tty_plant_info TYPE SORTED TABLE OF ty_plant_info
       WITH UNIQUE KEY plant.

  TYPES ttr_plant TYPE RANGE OF werks_d.

ENDINTERFACE.

CLASS lcl_plant_parameters_dao DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_ttr_plants) TYPE lif_plant_parameters=>ttr_plant.

    METHODS set_plants
      IMPORTING
        im_plants TYPE lif_plant_parameters=>ttr_plant.

     METHODS retrive_plant_parameters
        IMPORTING
            VALUE(im_ttr_plants) TYPE lif_plant_parameters=>ttr_plant
        RETURNING
            VALUE(re_result) TYPE lif_plant_parameters=>tty_plant_info.

     METHODS set_plant_parameters
        IMPORTING
            VALUE(im_plant_parameters)
             TYPE lif_plant_parameters=>tty_plant_info.

     METHODS get_plant_parameters
        RETURNING
            VALUE(re_result) TYPE lif_plant_parameters=>tty_plant_info.

  PRIVATE SECTION.

    DATA plants TYPE lif_plant_parameters=>ttr_plant.
    DATA plant_parameters TYPE lif_plant_parameters=>tty_plant_info.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant
        VALUE(im_new_plant) TYPE zma0_setaut_nplant.

ENDCLASS.
