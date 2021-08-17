CLASS lcl_creation_profile_dao DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_new_plant) TYPE werks_d
        VALUE(im_ref_plant) TYPE werks_d.

    METHODS get_rel_creation_profile
      RETURNING
        VALUE(re_rel_creation_profile) TYPE
                  zma0_cl_setaut_creation_prf=>tty_creation_prf.

    METHODS set_rel_creation_profile
      IMPORTING
        VALUE(im_rel_creation_profile) TYPE
                  zma0_cl_setaut_creation_prf=>tty_creation_prf.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA rel_creation_profile TYPE
    zma0_cl_setaut_creation_prf=>tty_creation_prf.

    METHODS retrieve_rel_creation_profile
      IMPORTING
        VALUE(im_new_plant) TYPE werks_d
        VALUE(im_ref_plant) TYPE werks_d
      RETURNING
        VALUE(re_rel_creation_profile)
                  TYPE zma0_cl_setaut_creation_prf=>tty_creation_prf.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_reference_data)
          TYPE zma0_cl_setaut_creation_prf=>tty_creation_prf
        VALUE(im_new_plant)         TYPE werks_d.

ENDCLASS.
