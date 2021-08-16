CLASS lcl_def_ship_data_dao IMPLEMENTATION.

  METHOD constructor.

    me->plants = im_ttr_plants.

    me->plant_data = me->retrive_plant_data( im_ttr_plants ).

  ENDMETHOD.


  METHOD set_plants.

    me->plants = im_plants.

  ENDMETHOD.

  METHOD retrive_plant_data.

    CHECK im_ttr_plants IS NOT INITIAL.

    SELECT werks name1 vkorg vtweg vstel spart
       FROM t001w
       INTO TABLE re_result
       WHERE werks IN im_ttr_plants.

  ENDMETHOD.

  METHOD set_plant_data.

    me->plant_data = im_plant_data.

  ENDMETHOD.

  METHOD get_plant_data.

    re_result = me->plant_data.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'ZM_V_T001W_L'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    me->bdcdata = VALUE tab_bdcdata(

      ( program = 'SAPL0MB9'        dynpro = '0002' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=POSI' )
      ( program = 'SAPLSPO4'        dynpro = '0300' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=FURT' )
      ( fnam    = 'SVALD-VALUE(01)' fval = im_new_plant )
      ( program = 'SAPL0MB9'        dynpro = '0002' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=SAVE' )
      ( fnam    = 'V_T001W_L-VKORG(01)'  fval = im_sales_org )
      ( fnam    = 'V_T001W_L-VTWEG(01)'  fval = im_dist_channel )
      ( fnam    = 'V_T001W_L-VSTEL(01)'  fval = im_ship_point )
      ( fnam    = 'V_T001W_L-SPART(01)'  fval = im_division )
      ( program = 'SAPLSTRD'        dynpro = '0300' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=LOCK' )
      ( fnam    = 'KO008-TRKORR'    fval = me->request->get_number( ) )
      ( program = 'SAPL0MB9'        dynpro = '0002' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )

    ).

  ENDMETHOD.

ENDCLASS.
