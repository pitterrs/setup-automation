CLASS lcl_foreign_trade_msg_dao IMPLEMENTATION.

  METHOD constructor.

    me->set_def_frgn_trade(
        me->retrieve_def_frgn_trade(
            im_ref_plant = im_ref_plant
        )
    ).

  ENDMETHOD.

  METHOD set_def_frgn_trade.

    me->rel_plant_mat_type = im_def_frgn_trade.

  ENDMETHOD.

  METHOD retrieve_def_frgn_trade.

    CHECK im_ref_plant IS NOT INITIAL.

    SELECT mandt,
           kappl,
           kschl,
           werks,
           stawd,
           packd,
           ftpra
        FROM zma0v_setaut_ftm(
            p_ref_plant = @im_ref_plant
        ) INTO TABLE @re_result.

  ENDMETHOD.

  METHOD get_def_frgn_trade.

    re_def_frgn_trade = me->rel_plant_mat_type.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'VED1'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    DATA lv_tabix TYPE sy-tabix.

    CLEAR me->bdcdata.

    LOOP AT im_foreign_trade_msg INTO DATA(lw_foreign_trade_msg).

      lv_tabix = sy-tabix.

      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0SBP'   dynpro = '0100' dynbegin = 'X' )
        ( fnam = 'BDC_OKCODE'       fval = '=NEWL' )
        ( program = 'SAPL0SBP'   dynpro = '0120' dynbegin = 'X' )
        ( fnam = 'BDC_OKCODE'    fval = '=SAVE' )
        ( fnam = 'V_T609P-KSCHL' fval = lw_foreign_trade_msg-kschl )
        ( fnam = 'V_T609P-WERKS' fval = im_new_plant )
        ( fnam = 'V_T609P-PACKD' fval = lw_foreign_trade_msg-packd )
        ( fnam = 'V_T609P-STAWD' fval = lw_foreign_trade_msg-stawd )
        ( fnam = 'V_T609P-FTPRA' fval = lw_foreign_trade_msg-ftpra )
      ) TO me->bdcdata.

      IF lv_tabix EQ 1.

        APPEND LINES OF VALUE tab_bdcdata(
          ( program = 'SAPLSTRD'     dynpro = '0300' dynbegin = 'X' )
          ( fnam    = 'KO008-TRKORR' fval = me->request->get_number( ) )
          ( fnam    = 'BDC_OKCODE'   fval = '=LOCK' )
        ) TO me->bdcdata.

      ENDIF.

      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0SBP'     dynpro = '0120' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'   fval = '=UEBE' )
      ) TO me->bdcdata.

    ENDLOOP.

    APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0SBP'     dynpro = '0100' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'   fval = '=BACK' )
      ) TO me->bdcdata.

  ENDMETHOD.

ENDCLASS.
