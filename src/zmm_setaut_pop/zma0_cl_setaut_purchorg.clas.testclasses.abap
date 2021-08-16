CLASS lcl_purchorg_test DEFINITION
FOR TESTING DURATION SHORT
RISK LEVEL HARMLESS .

  PRIVATE SECTION.

    DATA purchorg TYPE REF TO zma0_cl_setaut_purchorg.

    DATA database TYPE REF TO lcl_purchorg_dao.

    METHODS setup.

    METHODS existence_validation_test FOR TESTING.

    METHODS do_not_exist_validation_test FOR TESTING.

ENDCLASS.

CLASS lcl_purchorg_test IMPLEMENTATION.

  METHOD setup.

    me->purchorg = NEW #(
          im_new_plant = ''
          im_ref_plant = ''
*          im_purchorg = ''
          "im_description = ''"
          im_request = NEW zma0_cl_setaut_request( '' )
       ).

    me->purchorg->set_ref_plant( '123' ).

    me->database ?= me->purchorg->get_database(  ).

  ENDMETHOD.

  METHOD existence_validation_test.

    " Tabela interna
    DATA lt_purchorg TYPE lif_purchorg=>tt_purchorg.

    " Estrutura
    DATA lw_purchorg TYPE lif_purchorg=>ty_purchorg.

    lw_purchorg-werks = '123'.
    APPEND lw_purchorg TO lt_purchorg.

    "Set purchorg espera receber uma tabela:
    me->database->set_purchorg( lt_purchorg ).

    DATA(lv_is_created) = me->purchorg->is_created( lw_purchorg-werks ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_is_created
        exp                  = abap_true
        msg                  = 'Plant do not exist.'
    ).

  ENDMETHOD.

  METHOD do_not_exist_validation_test.

   " Tabela interna
    DATA lt_purchorg TYPE lif_purchorg=>tt_purchorg.

    " Estrutura
    DATA lw_purchorg TYPE lif_purchorg=>ty_purchorg.

    CLEAR lw_purchorg.
    me->database->set_purchorg( lt_purchorg ).

    DATA(lv_is_created) = me->purchorg->is_created( lw_purchorg-werks ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_is_created
        exp                  = abap_false
        msg                  = 'Plant is created.'
    ).

  ENDMETHOD.

ENDCLASS.
