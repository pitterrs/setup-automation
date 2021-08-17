
CLASS lcl_stock_t_data_dao IMPLEMENTATION.

  METHOD constructor.

    me->stock_t_data = me->retrieve_stock_t_data( im_plants ).

  ENDMETHOD.

  METHOD get_stock_t_data.

    re_result = me->stock_t_data.

  ENDMETHOD.

  METHOD set_stock_t_data.

    me->stock_t_data = im_stock_t_data.

  ENDMETHOD.

  METHOD retrieve_stock_t_data.

    CHECK im_plants IS NOT INITIAL.

   SELECT
            bstyp
            bsart
            reswk
            lfart
            prreg
            mevst
            merfp
            lfart1
            lfart2
            lfcon
            atpconfmrp
        FROM ZMA0V_CDS_STD
        INTO TABLE re_result
        WHERE reswk IN im_plants
        AND bstyp <> space.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
          im_request     =   im_request
          im_transaction = 'ZM_V_161V'
    ).

    me->document_category = im_document_category.

  ENDMETHOD.

  METHOD fill_bdcdata.

* Set document category for plant to be copied
    me->bdcdata = VALUE tab_bdcdata(
          ( program = 'SAPLSVIX'        dynpro = '0100' dynbegin = 'X' )
          ( fnam    = 'D0100_FIELD_TAB-LOWER_LIMIT(01)'
            fval = me->document_category )
          ( fnam    = 'BDC_OKCODE'      fval = '=OKAY' )
       ).

    LOOP AT me->ref_plant_info INTO DATA(lw_ref_plant_info).

* Click on the maintenance view position button
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ME6'        dynpro = '0180' dynbegin = 'X' )
        ( fnam    = 'BDC_OKCODE'      fval = '=POSI' )
      ) TO me->bdcdata.

* Search for a specific document type and supplying plant
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPLSPO4'        dynpro = '0300' dynbegin = 'X' )
        ( fnam    = 'SVALD-VALUE(01)' fval = lw_ref_plant_info-bsart )
        ( fnam    = 'SVALD-VALUE(02)' fval = lw_ref_plant_info-reswk )
        ( fnam    = 'BDC_OKCODE'      fval = '=FURT' )
      ) TO me->bdcdata.

* Mark the line found and click at the copy button
      APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPL0ME6'        dynpro = '0180' dynbegin = 'X' )
       ( fnam    = 'VIM_MARKED(01)'  fval = 'X' )
       ( fnam    = 'BDC_OKCODE'      fval = '=KOPE' )
     ) TO me->bdcdata.

* Set the new plant
      APPEND LINES OF VALUE tab_bdcdata(
        ( program = 'SAPL0ME6'         dynpro = '0180' dynbegin = 'X' )
        ( fnam    = 'V_161V-RESWK(01)' fval = im_new_plant )
        ( fnam    = 'BDC_OKCODE'       fval = '=KOPF' )
      ) TO me->bdcdata.

    ENDLOOP.

* Save the operation
    APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPL0ME6'       dynpro = '0180' dynbegin = 'X' )
       ( fnam    = 'BDC_OKCODE'     fval = '=SAVE' )
     ) TO me->bdcdata.

* Set the transport request
    APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPLSTRD'       dynpro = '0300' dynbegin = 'X' )
       ( fnam    = 'KO008-TRKORR'   fval = me->request->get_number( ) )
       ( fnam    = 'BDC_OKCODE'     fval = '=LOCK' )
    ) TO me->bdcdata.

* Leave the transaction
    APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPL0ME6'       dynpro = '0180' dynbegin = 'X' )
       ( fnam    = 'BDC_OKCODE'     fval = '=BACK' )
     ) TO me->bdcdata.

  ENDMETHOD.

  METHOD get_document_category.
    re_result = me->document_category.
  ENDMETHOD.

  METHOD set_document_category.
    me->document_category = im_document_category.
  ENDMETHOD.

  METHOD get_ref_plant_info.
    re_result = me->ref_plant_info.
  ENDMETHOD.

  METHOD set_ref_plant_info.
    me->ref_plant_info = im_ref_plant_info.
  ENDMETHOD.

ENDCLASS.
