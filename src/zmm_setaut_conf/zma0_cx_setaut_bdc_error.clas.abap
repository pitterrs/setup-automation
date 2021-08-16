CLASS zma0_cx_setaut_bdc_error DEFINITION PUBLIC CREATE PUBLIC
INHERITING FROM cx_static_check.

  PUBLIC SECTION.

    METHODS constructor
        IMPORTING
            VALUE(im_messages) TYPE tab_bdcmsgcoll.

    METHODS get_messages
        RETURNING
            VALUE(re_result) TYPE tab_bdcmsgcoll.

    METHODS set_messages
        IMPORTING
            VALUE(im_messages) TYPE tab_bdcmsgcoll.

    METHODS display_messages.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA messages TYPE tab_bdcmsgcoll.

ENDCLASS.

CLASS zma0_cx_setaut_bdc_error IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).
    me->messages = im_messages.
  ENDMETHOD.

  METHOD get_messages.
    re_result = me->messages.
  ENDMETHOD.

  METHOD set_messages.
    me->messages = im_messages.
  ENDMETHOD.

  METHOD display_messages.

    DATA lt_bapiret2 TYPE bapiret2_tt.

    CALL FUNCTION 'CONVERT_BDCMSGCOLL_TO_BAPIRET2'
      TABLES
        imt_bdcmsgcoll = me->messages
        ext_return     = lt_bapiret2
      EXCEPTIONS
        error_message = 1
        OTHERS        = 2.

    CHECK sy-subrc IS INITIAL.

*    CALL FUNCTION 'RSCRMBW_DISPLAY_BAPIRET2'
*      TABLES
*        it_return = lt_bapiret2
*      EXCEPTIONS
*        error_message = 1
*        OTHERS        = 2.

    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = lt_bapiret2
      EXCEPTIONS
        error_message = 1
        OTHERS        = 2.

  ENDMETHOD.

ENDCLASS.
