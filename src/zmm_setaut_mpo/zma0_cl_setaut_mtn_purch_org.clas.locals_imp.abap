CLASS lcl_maintain_purch_org IMPLEMENTATION.

  METHOD constructor.

    me->purch_org_data = im_ttr_purch_org.

    me->set_purch_org(
        me->retrive_purch_org( )
      ).

  ENDMETHOD.

  METHOD retrive_purch_org.

    SELECT
           mandt,
           ekorg,
           ekotx
      FROM zma0v_setaut_mpo
        FOR ALL ENTRIES IN @me->purch_org_data
       WHERE ekorg = @me->purch_org_data-ekorg INTO TABLE @re_purch_org.

  ENDMETHOD.

  METHOD set_purch_org.

    me->purch_org = im_purch_org.

  ENDMETHOD.

  METHOD get_purch_org.

    re_purch_org = me->purch_org.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'ZM_V_T024E'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    DATA lv_tabix TYPE sy-tabix.

    CLEAR me->bdcdata.

    LOOP AT im_purch_org_data INTO DATA(lw_purch_org_data).

      lv_tabix = sy-tabix.

      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ORG'   dynpro = '0120' dynbegin = 'X' )
        ( fnam = 'BDC_OKCODE'       fval = '=NEWL' )

        ( program = 'SAPL0ORG'   dynpro = '0120' dynbegin = 'X' )
        ( fnam = 'BDC_OKCODE'    fval = '=SAVE' )
        ( fnam = 'V_T024E-EKORG(01)' fval = lw_purch_org_data-ekorg )
        ( fnam = 'V_T024E-EKOTX(01)' fval = lw_purch_org_data-ekotx )
      ) TO me->bdcdata.

      IF lv_tabix EQ 1.

        APPEND LINES OF VALUE tab_bdcdata(
          ( program = 'SAPLSTRD'     dynpro = '0300' dynbegin = 'X' )
          ( fnam    = 'KO008-TRKORR' fval = me->request->get_number( ) )
          ( fnam    = 'BDC_OKCODE'   fval = '=LOCK' )
        ) TO me->bdcdata.

      ENDIF.

      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ORG'   dynpro = '0120' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'   fval = '=BACK' )
      ) TO me->bdcdata.

    ENDLOOP.

    APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ORG'   dynpro = '0120' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'   fval = '=BACK' )
      ) TO me->bdcdata.

  ENDMETHOD.

ENDCLASS.
