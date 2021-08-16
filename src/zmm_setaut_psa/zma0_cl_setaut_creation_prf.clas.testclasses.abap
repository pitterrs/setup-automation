CLASS ltcl_creation_profile DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA creation_profile TYPE REF TO zma0_cl_setaut_creation_prf.
    DATA database TYPE REF TO lcl_creation_profile_dao.

    METHODS:
      setup,
      test_is_created_false FOR TESTING  ,
      test_is_created_true FOR TESTING.

ENDCLASS.

CLASS ltcl_creation_profile IMPLEMENTATION.

  METHOD setup.
    me->creation_profile = NEW #(
    im_new_plant = 'XX01'
    im_ref_plant = 'CQ01'
    im_request = NEW #( 'CAG123' )
    ).
    me->database ?= me->creation_profile->get_database( ).
  ENDMETHOD.

  METHOD test_is_created_false.
    me->database->set_rel_creation_profile( VALUE #(  ) ).
    DATA(result) = me->creation_profile->is_created( ).
    cl_abap_unit_assert=>assert_equals(
        act = result
        exp = abap_false
        msg = 'Creation Profile is not Created'
    ).

  ENDMETHOD.

  METHOD test_is_created_true.
    me->database->set_rel_creation_profile( VALUE #(
    ( plant = 'XX01' )
     ) ).
    DATA(result) = me->creation_profile->is_created( ).
    cl_abap_unit_assert=>assert_equals(
        act = result
        exp = abap_true
        msg = 'Creation Profile is Created'
    ).

  ENDMETHOD.

ENDCLASS.
