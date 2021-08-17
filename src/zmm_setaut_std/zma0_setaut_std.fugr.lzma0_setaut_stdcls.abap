*&---------------------------------------------------------------------*
*&  Include           LZMA0_SETAUT_STDCLS
*&---------------------------------------------------------------------*
CLASS lcl_event DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS handle_toolbar_preparation
      FOR EVENT on_toolbar_preparation
          OF zma0_cl_salv_buddy
      IMPORTING
          ex_toolbar.

ENDCLASS.

CLASS lcl_event IMPLEMENTATION.

  METHOD handle_toolbar_preparation.

    TRY.
        ex_toolbar->remove_function( 'CREATE' ).
        ex_toolbar->remove_function( 'UPDATE' ).
        ex_toolbar->remove_function( 'DELETE' ).
      CATCH cx_salv_not_found.    "
      CATCH cx_salv_wrong_call.    "
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
