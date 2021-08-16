CLASS lcl_plant_parameters_dao IMPLEMENTATION.

  METHOD constructor.

    me->set_plants( im_ttr_plants ).

    DATA(lo_plant_parameters) =
    me->retrive_plant_parameters( im_ttr_plants ).

    me->set_plant_parameters( lo_plant_parameters ).

  ENDMETHOD.


  METHOD set_plants.

    me->plants = im_plants.

  ENDMETHOD.

  METHOD retrive_plant_parameters.

    CHECK im_ttr_plants IS NOT INITIAL.

    SELECT werks
       FROM t159l
       INTO TABLE re_result
       WHERE werks IN im_ttr_plants.

  ENDMETHOD.

  METHOD set_plant_parameters.

    me->plant_parameters = im_plant_parameters.

  ENDMETHOD.

  METHOD get_plant_parameters.

    re_result = me->plant_parameters.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
        im_request     = im_request
        im_transaction = 'ZM_V_159L'
    ).

  ENDMETHOD.

  METHOD fill_bdcdata.

    me->bdcdata = VALUE tab_bdcdata(

      ( program = 'SAPL0MB8'        dynpro = '0003' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=POSI' )
      ( program = 'SAPLSPO4'        dynpro = '0300' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=FURT' )
      ( fnam    = 'SVALD-VALUE(01)' fval = im_ref_plant )
      ( program = 'SAPL0MB8'        dynpro = '0003' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=KOPE' )
      ( fnam    = 'VIM_MARKED(01)'  fval = 'X' )
      ( program = 'SAPL0MB8'        dynpro = '0004' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=KOPF' )
      ( fnam    = 'V_159L-WERKS'    fval = im_new_plant )
      ( program = 'SAPL0MB8'        dynpro = '0003' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=SAVE' )
      ( program = 'SAPLSTRD'        dynpro = '0300' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=LOCK' )
      ( fnam    = 'KO008-TRKORR'    fval = me->request->get_number( ) )
      ( program = 'SAPL0MB8'        dynpro = '0003' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )

    ).

  ENDMETHOD.

ENDCLASS.
