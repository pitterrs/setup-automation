CLASS lcl_purch_group_test DEFINITION
FOR TESTING DURATION SHORT
RISK LEVEL HARMLESS .

  PRIVATE SECTION.

    DATA purchasing_group TYPE REF TO zma0_cl_setaut_purch_group.

    DATA database TYPE REF TO lcl_purch_group_dao.

    METHODS setup.

    METHODS existence_validation_test FOR TESTING.

    METHODS do_not_exist_validation_test FOR TESTING.

ENDCLASS.

CLASS lcl_purch_group_test IMPLEMENTATION.

  METHOD setup.

    me->purchasing_group = NEW #(
        im_purch_group = ''
        im_description = ''
        im_request = NEW zma0_cl_setaut_request( '' )
     ).

    me->purchasing_group->set_purch_group( '123' ).

    me->database ?= me->purchasing_group->get_database(  ).

  ENDMETHOD.

  METHOD existence_validation_test.

    DATA lw_purch_group TYPE lif_purch_group=>ty_purch_group.

    lw_purch_group-purch_group = '123'.
    me->database->set_purch_group( lw_purch_group ).

    DATA(lv_is_created) = me->purchasing_group->is_created(  ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_is_created
        exp                  = abap_true
        msg                  = 'Purchasing Group is not created yet.'
    ).

  ENDMETHOD.

  METHOD do_not_exist_validation_test.

    DATA lw_purch_group TYPE lif_purch_group=>ty_purch_group.

    CLEAR lw_purch_group.
    me->database->set_purch_group( lw_purch_group ).

    DATA(lv_is_created) = me->purchasing_group->is_created(  ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_is_created
        exp                  = abap_false
        msg                  = 'Purchasing Group is created.'
    ).

  ENDMETHOD.

ENDCLASS.
