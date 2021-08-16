*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_storage_loc_dao IMPLEMENTATION.

  METHOD constructor.
    me->storage = me->retrieve_storage( im_plants = im_plants ).
  ENDMETHOD.

  METHOD get_storage.
    re_result = me->storage.
  ENDMETHOD.

  METHOD set_storage.
    me->storage = im_storage.
  ENDMETHOD.

  METHOD retrieve_storage.
    CHECK im_plants IS NOT INITIAL.

    SELECT
            mandt
            werks
            lgort
            lgobe
    FROM ZMA0V_SETAUT_SLO
    INTO TABLE re_result
    WHERE werks IN im_plants.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
            im_request = im_request
            im_transaction = 'ZM_V_T001L'
            ).
  ENDMETHOD.

  METHOD fill_bdcdata.

    DATA l_tabix TYPE sy-tabix.
    me->bdcdata = VALUE tab_bdcdata(
                ( program = 'SAPLSVIX' dynpro = '0100' dynbegin = 'X' )
                ( fnam = 'D0100_FIELD_TAB-LOWER_LIMIT(01)'
                  fval = im_new_plant )
                ( fnam    = 'BDC_OKCODE'      fval = '=OKAY' )
                ) .

    LOOP AT im_ref_plant_info INTO DATA(lw_ref_plant_info).
      l_tabix = sy-tabix.

      "New entry
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ORG' dynpro = '0060' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=NEWL' )
        ) TO me->bdcdata.

      "Add the storage location number and description from the ref plant
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ORG' dynpro = '0060' dynbegin = 'X' )
        ( fnam    = 'V_T001L-LGORT(01)' fval = lw_ref_plant_info-lgort )
        ( fnam    = 'V_T001L-LGOBE(01)' fval = lw_ref_plant_info-lgobe )
        ( fnam    = 'BDC_OKCODE'      fval = '=SAVE' )
        ) TO me->bdcdata.

      IF l_tabix EQ 1.
        "Add the request number after the first entry
        APPEND LINES OF VALUE tab_bdcdata(
          ( program = 'SAPLSTRD' dynpro = '0300' dynbegin = 'X' )
          ( fnam    = 'KO008-TRKORR'
            fval = me->request->get_number( ) )
          ( fnam    = 'BDC_OKCODE'      fval = '=LOCK' )
          ) TO me->bdcdata.
      ENDIF.

      "Back
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ORG' dynpro = '0060' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )
        ) TO me->bdcdata.

    ENDLOOP.

    "Back
    APPEND LINES OF VALUE tab_bdcdata(
      ( program = 'SAPL0ORG' dynpro = '0060' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )
      ) TO me->bdcdata.

  ENDMETHOD.

  METHOD call_transaction.
    super->call_transaction( ).
  ENDMETHOD.

ENDCLASS.
