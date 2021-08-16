*&---------------------------------------------------------------------*
*&  Include           LZMA0_SETAUT_PMTCLS
*&---------------------------------------------------------------------*

CLASS lcl_event DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS handle_columns_preparation
      FOR EVENT on_columns_preparation
          OF zma0_cl_salv_buddy
      IMPORTING
          ex_columns.

ENDCLASS.

CLASS lcl_event IMPLEMENTATION.

  METHOD handle_columns_preparation.

    DATA lr_column TYPE REF TO cl_salv_column_list.

    TRY.

        lr_column ?= ex_columns->get_column( 'MENGU' ).
        lr_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
        FREE lr_column.

        lr_column ?= ex_columns->get_column( 'WERTU' ).
        lr_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
        FREE lr_column.

        lr_column ?= ex_columns->get_column( 'KZPIP' ).
        lr_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
        FREE lr_column.

        lr_column ?= ex_columns->get_column( 'XPIZU' ).
        lr_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
        FREE lr_column.

      CATCH cx_salv_not_found.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
