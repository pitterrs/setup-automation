CLASS lcl_stock_t_data_test DEFINITION
FOR TESTING DURATION SHORT
RISK LEVEL HARMLESS .

  PRIVATE SECTION.

    DATA stock_t_data TYPE REF TO zma0_cl_setaut_stock_t_data.

    DATA database TYPE REF TO lcl_stock_t_data_dao.

    METHODS setup.

    METHODS existence_validation_test FOR TESTING.

    METHODS do_not_exist_validation_test FOR TESTING.

ENDCLASS.

CLASS lcl_stock_t_data_test IMPLEMENTATION.

  METHOD setup.

    me->stock_t_data = NEW #(
        im_new_plant = ''
        im_ref_plant = ''
        im_request   = new zma0_cl_setaut_request( '' )
     ).

    me->stock_t_data->set_new_plant( 'XXXX' ).

    me->database ?= me->stock_t_data->get_database( ).

  ENDMETHOD.

  METHOD existence_validation_test.

*    me->database->set_stock_t_data(
*        VALUE zma0_cl_setaut_stock_t_data=>tt_stock_t_data(
*            ( reswk = 'XXXX' )
*        )
*    ).
*
*    DATA(lv_is_created) = me->stock_t_data->is_created(
*        im_document_category = 'L'
*        im_plant = me->stock_t_data->get_new_plant( )
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*     EXPORTING
*       act                  = lv_is_created
*       exp                  = abap_true
*       msg                  = 'Stock Transfer Data is not created yet.'
*   ).

  ENDMETHOD.

  METHOD do_not_exist_validation_test.

*    me->database->set_stock_t_data(
*         VALUE zma0_cl_setaut_stock_t_data=>tt_stock_t_data( (  ) )
*     ).
*
*    DATA(lv_is_created) = me->stock_t_data->is_created(
*        im_document_category = 'L'
*        im_plant = me->stock_t_data->get_new_plant( )
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*     EXPORTING
*       act                  = lv_is_created
*       exp                  = abap_false
*       msg                  = 'Stock Transfer Data is already created.'
*   ).

  ENDMETHOD.

ENDCLASS.
