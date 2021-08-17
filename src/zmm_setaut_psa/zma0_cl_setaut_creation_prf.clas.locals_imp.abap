CLASS lcl_creation_profile_dao IMPLEMENTATION.

  METHOD get_rel_creation_profile.
    re_rel_creation_profile = me->rel_creation_profile.

  ENDMETHOD.

  METHOD set_rel_creation_profile.

    me->rel_creation_profile = im_rel_creation_profile.

  ENDMETHOD.

  METHOD constructor.

    DATA(lo_rel_creation_profile) =
    me->retrieve_rel_creation_profile(
        im_new_plant = im_new_plant
        im_ref_plant = im_ref_plant
    ).
    me->set_rel_creation_profile( lo_rel_creation_profile ).

  ENDMETHOD.

  METHOD retrieve_rel_creation_profile.

    CHECK im_ref_plant IS NOT INITIAL AND im_new_plant IS NOT INITIAL.

    SELECT  mandt,
            werks,
            abueb,
            abbez
        FROM ZMA0V_SETAUT_PSA(
            p_werks = @im_ref_plant
        )
        INTO TABLE @re_rel_creation_profile.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'ZOMUP'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    DATA v_tabix TYPE sy-tabix.

    CLEAR me->bdcdata.

    LOOP AT im_reference_data INTO DATA(w_reference_data).

        v_tabix = sy-tabix.

        APPEND LINES OF VALUE tab_bdcdata(

            ( program = 'SAPL0MEV' dynpro = '1100' dynbegin = 'X' )
            ( fnam = 'BDC_OKCODE' fval = '=NEWL' )
            ( program = 'SAPL0MEV' dynpro = '1200' dynbegin = 'X' )
            ( fnam = 'V_T163P-WERKS' fval = im_new_plant )
            ( fnam = 'V_T163P-ABUEB' fval = w_reference_data-abueb )
            ( fnam = 'V_T163P-ABBEZ' fval = w_reference_data-abbez )
            ( fnam = 'BDC_OKCODE' fval = '=SAVE' )
            ) TO me->bdcdata.

        IF v_tabix EQ 1.

          APPEND LINES OF VALUE tab_bdcdata(
           ( program = 'SAPLSTRD'     dynpro = '0300' dynbegin = 'X' )
           ( fnam    = 'KO008-TRKORR' fval = me->request->get_number( ) )
           ( fnam    = 'BDC_OKCODE'   fval = '=LOCK' )
          ) TO me->bdcdata.

        ENDIF.


        APPEND LINES OF VALUE tab_bdcdata(

            ( program = 'SAPL0MEV' dynpro = '1200' dynbegin = 'X' )
            ( fnam = 'BDC_OKCODE' fval = '=UEBE' )

        ) TO me->bdcdata.

    ENDLOOP.

    APPEND LINES OF VALUE tab_bdcdata(

            ( program = 'SAPL0MEV' dynpro = '1100' dynbegin = 'X' )
            ( fnam = 'BDC_OKCODE' fval = '=BACK' )

        ) TO me->bdcdata.

  ENDMETHOD.

ENDCLASS.
