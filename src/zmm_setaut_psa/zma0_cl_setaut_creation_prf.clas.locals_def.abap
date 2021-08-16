INTERFACE lif_creation_profile.

  TYPES: BEGIN OF ty_creation_profile,
           plant   TYPE werks_d,
           profile TYPE abueb,
         END OF ty_creation_profile.
  TYPES: tty_creation_profile TYPE SORTED TABLE OF ty_creation_profile
         WITH UNIQUE KEY plant profile.
  TYPES: range_werks TYPE RANGE OF werks_d.

ENDINTERFACE.

CLASS lcl_creation_profile_dao DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING VALUE(im_plants) TYPE lif_creation_profile=>range_werks.

    METHODS get_plants
      RETURNING VALUE(re_plants) TYPE lif_creation_profile=>range_werks.

    METHODS set_plants
      IMPORTING VALUE(im_plants) TYPE lif_creation_profile=>range_werks.

    METHODS get_rel_creation_profile
      RETURNING VALUE(re_rel_creation_profile) TYPE
                  lif_creation_profile=>tty_creation_profile.

    METHODS set_rel_creation_profile
      IMPORTING VALUE(im_rel_creation_profile) TYPE
                  lif_creation_profile=>tty_creation_profile.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA plants TYPE lif_creation_profile=>range_werks.

    DATA rel_creation_profile TYPE
    lif_creation_profile=>tty_creation_profile.

    METHODS retrieve_rel_creation_profile
      IMPORTING VALUE(im_plants)
                  TYPE lif_creation_profile=>range_werks
      RETURNING VALUE(re_rel_creation_profile)
                  TYPE lif_creation_profile=>tty_creation_profile.

ENDCLASS.

CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_creation_profiles)
          TYPE lif_creation_profile=>tty_creation_profile
        VALUE(im_new_plant)         TYPE werks_d.

ENDCLASS.
