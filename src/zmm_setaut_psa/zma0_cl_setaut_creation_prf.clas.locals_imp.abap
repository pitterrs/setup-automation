CLASS lcl_creation_profile_dao IMPLEMENTATION.

  METHOD get_plants.
    re_plants = me->plants.

  ENDMETHOD.

  METHOD set_plants.
    me->plants = im_plants.

  ENDMETHOD.

  METHOD get_rel_creation_profile.
    re_rel_creation_profile = me->rel_creation_profile.

  ENDMETHOD.

  METHOD set_rel_creation_profile.
    me->rel_creation_profile = im_rel_creation_profile.

  ENDMETHOD.

  METHOD constructor.
    me->set_plants( im_plants ).

    DATA(lo_rel_creation_profile) =
    me->retrieve_rel_creation_profile( im_plants ).
    me->set_rel_creation_profile( lo_rel_creation_profile ).

  ENDMETHOD.

  METHOD retrieve_rel_creation_profile.

    CHECK im_plants IS NOT INITIAL.

    SELECT werks abueb
        FROM t163p
        INTO TABLE re_rel_creation_profile
        WHERE werks IN im_plants.

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
    CLEAR me->bdcdata.
    LOOP AT im_creation_profiles INTO DATA(lw_creation_profile).
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0MEV' dynpro = '1100' dynbegin = 'X' )
*        ( fnam = 'BDC_CURSOR' fval = 'V_T163P-ABBEZ(01)' )
        ( fnam = 'BDC_OKCODE' fval = '=POSI' )
        ( program = 'SAPLSPO4' dynpro = '300' dynbegin = 'X' )
*        ( fnam = 'BDC_CURSOR' fval = 'SVALD-VALUE(02)' )
        ( fnam = 'BDC_OKCODE' fval = '=FURT' )
        ( fnam = 'SVALD-VALUE(01)' fval = lw_creation_profile-plant )
        ( fnam = 'SVALD-VALUE(02)' fval = lw_creation_profile-profile )
        ( program = 'SAPL0MEV' dynpro = '1100' dynbegin = 'X' )
*        ( fnam = 'BDC_CURSOR' fval = 'V_T163P-WERKS(01)' )
        ( fnam = 'BDC_OKCODE' fval = '=KOPE' )
        ( fnam = 'VIM_MARKED(01)' fval = 'X' )
        ( program = 'SAPL0MEV' dynpro = '1200' dynbegin = 'X' )
*        ( fnam = 'BDC_CURSOR' fval = 'V_T163P-WERKS' )
        ( fnam = 'BDC_OKCODE' fval = '=KOPF' )
        ( fnam = 'V_T163P-WERKS' fval = im_new_plant )
        ( fnam = 'V_T163P-ABUEB' fval = lw_creation_profile-profile )
        ( fnam = 'V_T163P-ABBEZ' fval = 'T:W AG:D-75, M76-260' )
        ( fnam = 'BDC_SUBSCR' fval = 'SAPL0MEV 1205SUB' )
        ( fnam = 'V_T163P-LAEODT' fval = 'X' )
      )
       TO me->bdcdata.
    ENDLOOP.

    APPEND LINES OF VALUE tab_bdcdata(

       "Save and add to Transport
       ( program = 'SAPL0MEV' dynpro = '1100' dynbegin = 'X' )
*       ( fnam = 'BDC_CURSOR' fval = 'V_T163P-WERKS(01)' )
       ( fnam = 'BDC_OKCODE' fval = '=SAVE' )
       ( program = 'SAPLSTRD' dynpro = '300' dynbegin = 'X' )
*       ( fnam = 'BDC_CURSOR' fval = 'KO008-TRKORR' )
       ( fnam = 'BDC_OKCODE' fval = '=LOCK' )
       ( fnam = 'KO008-TRKORR' fval = me->get_request( )->get_number( ) )
       ( program = 'SAPL0MEV' dynpro = '1100' dynbegin = 'X' )
       ( fnam = 'BDC_OKCODE' fval = '=BACK' )
    ) TO me->bdcdata.

  ENDMETHOD.

ENDCLASS.
