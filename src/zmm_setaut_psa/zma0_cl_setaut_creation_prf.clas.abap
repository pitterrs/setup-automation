CLASS zma0_cl_setaut_creation_prf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

      TYPES: tty_creation_prf TYPE TABLE OF zma0v_setaut_psa
           WITH DEFAULT KEY.

    INTERFACES zma0_if_setaut_process.

    METHODS get_ref_plant
      RETURNING VALUE(re_ref_plant) TYPE werks_d.

    METHODS set_ref_plant
      IMPORTING VALUE(im_ref_plant) TYPE werks_d.

    METHODS get_database
      RETURNING VALUE(re_database) TYPE REF TO object.

    METHODS set_database
      IMPORTING VALUE(im_database) TYPE REF TO object.

    METHODS get_new_plant
      RETURNING VALUE(re_new_plant) TYPE werks_d.

    METHODS set_new_plant
      IMPORTING VALUE(im_new_plant) TYPE werks_d.

    METHODS constructor
      IMPORTING VALUE(im_ref_plant) TYPE werks_d
                VALUE(im_new_plant) TYPE werks_d
                VALUE(im_request)   TYPE REF TO zma0_cl_setaut_request.

    METHODS get_request
      RETURNING VALUE(re_request) TYPE REF TO zma0_cl_setaut_request .

    METHODS set_request
      IMPORTING VALUE(im_request) TYPE REF TO zma0_cl_setaut_request.

    METHODS get_reference_data
        RETURNING
            VALUE(re_result)
                TYPE zma0_cl_setaut_creation_prf=>tty_creation_prf.

    METHODS set_reference_data
        IMPORTING
            VALUE(im_reference_data)
                TYPE zma0_cl_setaut_creation_prf=>tty_creation_prf.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA database TYPE REF TO lcl_creation_profile_dao.

    DATA ref_plant TYPE werks_d.

    DATA new_plant TYPE werks_d.

    DATA request TYPE REF TO zma0_cl_setaut_request.

    DATA t_reference_data
        TYPE zma0_cl_setaut_creation_prf=>tty_creation_prf.

ENDCLASS.

CLASS zma0_cl_setaut_creation_prf IMPLEMENTATION.

  METHOD get_ref_plant.
    re_ref_plant = me->ref_plant.

  ENDMETHOD.

  METHOD set_ref_plant.
    me->ref_plant = im_ref_plant.

  ENDMETHOD.

  METHOD get_new_plant.
    re_new_plant = me->new_plant.

  ENDMETHOD.

  METHOD set_new_plant.
    me->new_plant = im_new_plant.

  ENDMETHOD.

  METHOD get_database.
    re_database ?= me->database.

  ENDMETHOD.

  METHOD set_database.

    me->database ?= im_database.

  ENDMETHOD.

  METHOD constructor.

    me->set_ref_plant( im_ref_plant ).
    me->set_new_plant( im_new_plant ).
    me->set_request( im_request ).

    " Create DAO
    me->database = NEW lcl_creation_profile_dao(
        im_new_plant = im_new_plant
        im_ref_plant = im_ref_plant
     ).

     me->t_reference_data = me->get_reference_data( ).

  ENDMETHOD.

  METHOD get_request.
    re_request = me->request.
  ENDMETHOD.

  METHOD set_request.
    me->request = im_request.
  ENDMETHOD.


  METHOD zma0_if_setaut_process~execute.

    DATA(lr_batch_input) = NEW lcl_batch_input( me->get_request( ) ).

    CHECK t_reference_data IS NOT INITIAL.

    lr_batch_input->fill_bdcdata(
      EXPORTING
        im_reference_data = t_reference_data
        im_new_plant      = me->get_new_plant(  )
    ).

    lr_batch_input->call_transaction(  ).

  ENDMETHOD.

  METHOD get_reference_data.

  DATA(t_rel_creation_prof) = me->database->get_rel_creation_profile( ).

    LOOP AT t_rel_creation_prof INTO DATA(w_rel_creation_prof).

      CHECK NOT line_exists( t_rel_creation_prof[
          werks   = me->new_plant
          abueb = w_rel_creation_prof-abueb
      ] ).

      APPEND w_rel_creation_prof TO re_result.

    ENDLOOP.

  ENDMETHOD.

  METHOD set_reference_data.

    me->t_reference_data = im_reference_data.

  ENDMETHOD.

ENDCLASS.
