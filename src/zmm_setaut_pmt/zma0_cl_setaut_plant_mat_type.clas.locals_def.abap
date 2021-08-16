CLASS lcl_plant_mat_type_dao DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING VALUE(im_ref_plant) TYPE zma0_setaut_rplant
                VALUE(im_new_plant) TYPE zma0_setaut_nplant.

    METHODS get_rel_plant_mat_type
      RETURNING VALUE(re_rel_plant_mat_type) TYPE
                  zma0_cl_setaut_plant_mat_type=>tty_plant_mat_type.

    METHODS set_rel_plant_mat_type
      IMPORTING VALUE(im_rel_plant_mat_type) TYPE
                  zma0_cl_setaut_plant_mat_type=>tty_plant_mat_type.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA rel_plant_mat_type
        TYPE zma0_cl_setaut_plant_mat_type=>tty_plant_mat_type.

    METHODS retrieve_rel_plant_mat_type
      IMPORTING VALUE(im_ref_plant) TYPE zma0_setaut_rplant
                VALUE(im_new_plant) TYPE zma0_setaut_nplant
      RETURNING VALUE(re_result)
                TYPE zma0_cl_setaut_plant_mat_type=>tty_plant_mat_type.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_plant_mat_types)
          TYPE zma0_cl_setaut_plant_mat_type=>tty_plant_mat_type
        VALUE(im_new_plant)       TYPE zma0_setaut_nplant.

ENDCLASS.
