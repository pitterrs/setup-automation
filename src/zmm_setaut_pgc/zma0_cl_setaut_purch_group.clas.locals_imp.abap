CLASS lcl_purch_group_dao IMPLEMENTATION.

  METHOD constructor.

    me->purch_group = me->retrieve_purch_group( im_code ).

  ENDMETHOD.

  METHOD get_purch_group.

    re_result = me->purch_group.

  ENDMETHOD.

  METHOD set_purch_group.

    me->purch_group = im_purch_group.

  ENDMETHOD.

  METHOD retrieve_purch_group.

    CHECK im_code IS NOT INITIAL.

    SELECT SINGLE ekgrp eknam
        FROM t024
        INTO re_result
        WHERE ekgrp = im_code.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'OME4'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    me->bdcdata = VALUE tab_bdcdata(
        ( program = 'SAPL0ME6'        dynpro = '0020' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=NEWL' )
        ( program = 'SAPL0ME6'        dynpro = '0020' dynbegin = 'X' )
        ( fnam    = 'V_024-EKGRP(01)' fval = im_purch_group_code )
        ( fnam    = 'V_024-EKNAM(01)' fval = im_purch_group_desc )
        ( fnam    = 'BDC_OKCODE'      fval = '/00' )
        ( program = 'SAPL0ME6'        dynpro = '0020' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=SAVE' )
        ( program = 'SAPLSTRD'        dynpro = '0300' dynbegin = 'X' )
        ( fnam    = 'KO008-TRKORR'   fval = me->request->get_number( ) )
        ( fnam    = 'BDC_OKCODE'      fval = '=LOCK' )
        ( program = 'SAPL0ME6'        dynpro = '0020' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )
        ( program = 'SAPL0ME6'        dynpro = '0020' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )
     ).

  ENDMETHOD.

ENDCLASS.
