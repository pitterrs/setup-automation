CLASS zma0_cl_setaut_creation_prf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

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

    METHODS is_created
      RETURNING VALUE(re_return) TYPE abap_bool.

    METHODS get_request
      RETURNING VALUE(re_request) TYPE REF TO zma0_cl_setaut_request .

    METHODS set_request
      IMPORTING VALUE(im_request) TYPE REF TO zma0_cl_setaut_request.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA database TYPE REF TO lcl_creation_profile_dao.

    DATA ref_plant TYPE werks_d.

    DATA new_plant TYPE werks_d.

    DATA request TYPE REF TO zma0_cl_setaut_request.

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
    DATA(lr_database) = NEW lcl_creation_profile_dao(
        VALUE #(
            (  sign = 'I' option = 'EQ' low = im_ref_plant )
            (  sign = 'I' option = 'EQ' low = im_new_plant )
        )
     ).

    me->set_database( lr_database ).

  ENDMETHOD.

  METHOD is_created.
    DATA(lt_creation_profiles) =
        FILTER lif_creation_profile=>tty_creation_profile(
            me->database->get_rel_creation_profile( )
            WHERE plant = me->get_new_plant( )
        ).
    IF lt_creation_profiles IS INITIAL.
      re_return = abap_false.
    ELSE.
      re_return = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD get_request.
    re_request = me->request.
  ENDMETHOD.

  METHOD set_request.
    me->request = im_request.
  ENDMETHOD.


  METHOD zma0_if_setaut_process~execute.

    DATA(lr_batch_input) = NEW lcl_batch_input( me->get_request( ) ).

    DATA(lt_creation_profiles) =
    FILTER lif_creation_profile=>tty_creation_profile(
        me->database->get_rel_creation_profile( )
        WHERE plant = me->get_ref_plant( )
    ).

    CHECK lt_creation_profiles IS NOT INITIAL.

    lr_batch_input->fill_bdcdata(
      EXPORTING
        im_creation_profiles = lt_creation_profiles
        im_new_plant         = me->get_new_plant(  )
    ).

    lr_batch_input->call_transaction(  ).

  ENDMETHOD.

ENDCLASS.
