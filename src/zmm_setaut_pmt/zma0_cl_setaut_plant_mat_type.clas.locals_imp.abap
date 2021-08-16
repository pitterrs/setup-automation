CLASS lcl_plant_mat_type_dao IMPLEMENTATION.

  METHOD get_rel_plant_mat_type.
    re_rel_plant_mat_type = me->rel_plant_mat_type.

  ENDMETHOD.

  METHOD set_rel_plant_mat_type.
    me->rel_plant_mat_type = im_rel_plant_mat_type.

  ENDMETHOD.

  METHOD constructor.

    me->set_rel_plant_mat_type(
        me->retrieve_rel_plant_mat_type(
            im_ref_plant = im_ref_plant
            im_new_plant = im_new_plant
        )
    ).

  ENDMETHOD.

  METHOD retrieve_rel_plant_mat_type.

    CHECK im_new_plant IS NOT INITIAL
    AND im_ref_plant IS NOT INITIAL.

    SELECT mandt,
           bwkey,
           mtart,
           mengu,
           wertu,
           kzpip,
           xpizu
        FROM zma0v_setaut_pmt(
            p_new_plant = @im_new_plant,
            p_ref_plant = @im_ref_plant
        ) INTO TABLE @re_result.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'ZMA0_VT134M'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    DATA lv_tabix TYPE sy-tabix.

    CLEAR me->bdcdata.

    LOOP AT im_plant_mat_types INTO DATA(lw_plant_mat_type).

      lv_tabix = sy-tabix.

      APPEND LINES OF VALUE tab_bdcdata(

* Set Position
        ( program = 'SAPLMGCT134M'  dynpro = '0200' dynbegin = 'X' )
        ( fnam = 'BDC_OKCODE'       fval = '=POSI' )

* Set Plant and Material Type to position
        ( program = 'SAPLSPO4'      dynpro = '0300' dynbegin = 'X' )
        ( fnam = 'BDC_OKCODE'       fval = '=FURT' )
        ( fnam = 'SVALD-VALUE(01)'  fval = im_new_plant )
        ( fnam = 'SVALD-VALUE(02)'  fval = lw_plant_mat_type-mtart )

* Set Checkbox equal plant reference
        ( program = 'SAPLMGCT134M'  dynpro = '0200' dynbegin = 'X' )
        ( fnam = 'VT134M-MENGU(01)' fval = lw_plant_mat_type-mengu )
        ( fnam = 'VT134M-WERTU(01)' fval = lw_plant_mat_type-wertu )
        ( fnam = 'VT134M-KZPIP(01)' fval = lw_plant_mat_type-kzpip )
        ( fnam = 'VT134M-XPIZU(01)' fval = lw_plant_mat_type-xpizu )
        ( fnam = 'BDC_OKCODE'       fval = '=SAVE' ) ) TO me->bdcdata.

      IF lv_tabix EQ 1.

* Set request to changes
        APPEND LINES OF VALUE tab_bdcdata(
          ( program = 'SAPLSTRD'     dynpro = '0300' dynbegin = 'X' )
          ( fnam    = 'KO008-TRKORR' fval = me->request->get_number( ) )
          ( fnam    = 'BDC_OKCODE'   fval = '=LOCK' )
        ) TO me->bdcdata.
      ENDIF.

    ENDLOOP.

* Leave the transaction
    APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPLMGCT134M'   dynpro = '0200' dynbegin = 'X' )
       ( fnam    = 'BDC_OKCODE'     fval = '=BACK' )
     ) TO me->bdcdata.

  ENDMETHOD.

ENDCLASS.
