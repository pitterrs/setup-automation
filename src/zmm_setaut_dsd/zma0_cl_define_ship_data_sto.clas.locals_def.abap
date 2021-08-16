INTERFACE lif_def_ship_data.

  TYPES: BEGIN OF ty_plant_info,
           plant        TYPE werks_d,
           name         TYPE name1,
           sales_org    TYPE vkorg,
           dist_channel TYPE vtweg,
           ship_point   TYPE vstel,
           division     TYPE spart,
         END OF ty_plant_info.

  TYPES: tty_plant_info TYPE SORTED TABLE OF ty_plant_info
       WITH UNIQUE KEY plant name.

  TYPES ttr_plant TYPE RANGE OF werks_d.

ENDINTERFACE.

CLASS lcl_def_ship_data_dao DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_ttr_plants) TYPE lif_def_ship_data=>ttr_plant.

    METHODS set_plants
      IMPORTING
        im_plants TYPE lif_def_ship_data=>ttr_plant.

    METHODS retrive_plant_data
      IMPORTING
        VALUE(im_ttr_plants) TYPE lif_def_ship_data=>ttr_plant
      RETURNING
        VALUE(re_result)     TYPE lif_def_ship_data=>tty_plant_info.

    METHODS set_plant_data
      IMPORTING
        VALUE(im_plant_data)
          TYPE lif_def_ship_data=>tty_plant_info.

    METHODS get_plant_data
      RETURNING
        VALUE(re_result) TYPE lif_def_ship_data=>tty_plant_info.

  PRIVATE SECTION.

    DATA plants TYPE lif_def_ship_data=>ttr_plant.
    DATA plant_data TYPE lif_def_ship_data=>tty_plant_info.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_new_plant)    TYPE zma0_setaut_nplant
        VALUE(im_sales_org)    TYPE vkorg
        VALUE(im_dist_channel) TYPE vtweg
        VALUE(im_ship_point)   TYPE vstel
        VALUE(im_division)     TYPE spart.

ENDCLASS.
