CLASS zma0_cl_setaut_batch_input DEFINITION
     PUBLIC CREATE PUBLIC ABSTRACT.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request)     TYPE REF TO zma0_cl_setaut_request
        VALUE(im_transaction) TYPE syst_tcode.

    METHODS get_bdcdata
      RETURNING VALUE(re_result) TYPE tab_bdcdata.

    METHODS set_bdcdata
      IMPORTING VALUE(im_bdcdata) TYPE tab_bdcdata.

    METHODS get_options
      RETURNING VALUE(re_result) TYPE ctu_params.

    METHODS set_options
      IMPORTING VALUE(im_options) TYPE ctu_params.

    METHODS get_request
      RETURNING VALUE(re_result) TYPE REF TO zma0_cl_setaut_request.

    METHODS set_request
      IMPORTING VALUE(im_request) TYPE REF TO zma0_cl_setaut_request.

    METHODS get_transaction
      RETURNING VALUE(re_result) TYPE syst_tcode.

    METHODS set_transaction
      IMPORTING VALUE(im_transaction) TYPE syst_tcode.

    METHODS call_transaction
      RETURNING VALUE(re_messages) TYPE tab_bdcmsgcoll
      RAISING zma0_cx_setaut_bdc_error.

  PROTECTED SECTION.

    DATA bdcdata TYPE tab_bdcdata.
    DATA options TYPE ctu_params.
    DATA request TYPE REF TO zma0_cl_setaut_request.
    DATA transaction TYPE syst_tcode.

ENDCLASS.

CLASS zma0_cl_setaut_batch_input IMPLEMENTATION.

  METHOD constructor.

    me->request = im_request.
    me->transaction = im_transaction.

    me->options-updmode = 'S'.
    me->options-dismode = 'N'.
    me->options-defsize = abap_true.
    me->options-racommit = abap_true.

  ENDMETHOD.

  METHOD get_bdcdata.
    re_result = me->bdcdata.
  ENDMETHOD.

  METHOD set_bdcdata.
    me->bdcdata = im_bdcdata.
  ENDMETHOD.

  METHOD get_options.
    re_result = me->options.
  ENDMETHOD.

  METHOD set_options.
    me->options = im_options.
  ENDMETHOD.

  METHOD get_request.
    re_result = me->request.
  ENDMETHOD.

  METHOD set_request.
    me->request = im_request.
  ENDMETHOD.

  METHOD get_transaction.
    re_result = me->transaction.
  ENDMETHOD.

  METHOD set_transaction.
    me->transaction = im_transaction.
  ENDMETHOD.

  METHOD call_transaction.

    CALL TRANSACTION me->transaction
    USING me->bdcdata
    OPTIONS FROM me->options
    MESSAGES INTO re_messages.

    " Set "no data for batch input" message as an error message
    " The same will be triggered in cases where the batch input
    " process doesn't have a '=BACK' function at the end or when
    " the transaction is already being used by other users.
    IF line_exists( re_messages[ msgid = '00' msgnr = '344' ] ).
      re_messages[ msgid = '00' msgnr = '344' ]-msgtyp = 'E'.
    ENDIF.

    IF line_exists( re_messages[ msgtyp = 'E' ] ).
      RAISE EXCEPTION TYPE zma0_cx_setaut_bdc_error
        EXPORTING
            im_messages = re_messages.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
