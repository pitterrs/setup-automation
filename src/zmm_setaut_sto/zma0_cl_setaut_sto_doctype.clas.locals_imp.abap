*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_sto_doctype_dao IMPLEMENTATION.

  METHOD constructor.
    me->doctype = me->retrieve_doctype( im_plants = im_plants ).
  ENDMETHOD.

  METHOD get_doctype.
    re_result = me->doctype.
  ENDMETHOD.

  METHOD set_doctype.
    me->doctype = im_doctype.
  ENDMETHOD.

  METHOD retrieve_doctype.
    "The im_plants range is not empty
    CHECK im_plants IS NOT INITIAL.

    "Select all the Receiving plants
    SELECT
            reswk
            werks
            bstyp
            bsart
      FROM t161w
      INTO TABLE re_result
      WHERE werks IN im_plants.

    "Select all the Supplying plants
    SELECT
            reswk
            werks
            bstyp
            bsart
      FROM t161w
      APPENDING TABLE re_result
      WHERE reswk IN im_plants.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
             im_request     = im_request
             im_transaction = 'ZM_V_T161W'
         ).
    me->document_category = im_document_category.
  ENDMETHOD.

  METHOD get_ref_plant_info.
    re_result = me->ref_plant_info.
  ENDMETHOD.

  METHOD set_ref_plant_info.
    me->ref_plant_info = im_ref_plant_info.
  ENDMETHOD.

  METHOD fill_bdcdata.
    "Enter in the transaction with the doc category F or L
    me->bdcdata = VALUE tab_bdcdata(
  ( program = 'SAPLSVIX'                dynpro = '0100' dynbegin = 'X' )
  ( fnam    = 'BDC_OKCODE'              fval = '=OKAY' )
  ( fnam = 'D0100_FIELD_TAB-LOWER_LIMIT(01)'
                                        fval = im_document_category )
  ).
    "Loop in all the values from the ref plant to copy it
    LOOP AT me->ref_plant_info INTO DATA(lw_ref_plant_info).

      APPEND LINES OF VALUE tab_bdcdata(
         ( program = 'SAPL0ME6'        dynpro = '0150' dynbegin = 'X' )
         ( fnam    = 'BDC_OKCODE'      fval = '=POSI' )
       ) TO me->bdcdata.
      "Position with the Supplying and Receiving plants from the ref
      APPEND LINES OF VALUE tab_bdcdata(
         ( program = 'SAPLSPO4'        dynpro = '0300' dynbegin = 'X' )
         ( fnam    = 'BDC_OKCODE'      fval = '=FURT' )
         ( fnam    = 'SVALD-VALUE(01)' fval = lw_ref_plant_info-reswk )
         ( fnam    = 'SVALD-VALUE(02)' fval = lw_ref_plant_info-werks )
       ) TO me->bdcdata.

      APPEND LINES OF VALUE tab_bdcdata(
         ( program = 'SAPL0ME6' dynpro = '0150' dynbegin = 'X' )
         ( fnam    = 'BDC_OKCODE'      fval = '=KOPE' )
          ( fnam    = 'VIM_MARKED(01)'      fval = 'X' )
       ) TO me->bdcdata.
      "If copying the Receiving plant, need to use the Supplying plant
      "in the position and the document type
      IF im_is_supplying_plant EQ abap_false.
        APPEND LINES OF VALUE tab_bdcdata(
           ( program = 'SAPL0ME6'   dynpro = '0150' dynbegin = 'X' )
           ( fnam    = 'BDC_OKCODE' fval = '=KOPF' )
           ( fnam    = 'V_T161W-RESWK(01)'
                                    fval = lw_ref_plant_info-reswk )
           ( fnam    = 'V_T161W-WERKS(01)'
                                    fval = im_new_plant )
           ( fnam    = 'V_T161W-BSART(01)'
                                    fval = lw_ref_plant_info-bsart )
         ) TO me->bdcdata.
      ELSE.
        "If copying the Supplying plant, just need the Supplying plant
        "and the document type
        APPEND LINES OF VALUE tab_bdcdata(
          ( program = 'SAPL0ME6'        dynpro = '0150' dynbegin = 'X' )
          ( fnam    = 'BDC_OKCODE'      fval = '=KOPF' )
          ( fnam    = 'V_T161W-RESWK(01)'
                                        fval = im_new_plant )
          ( fnam    = 'V_T161W-BSART(01)'
                                        fval = lw_ref_plant_info-bsart )
        ) TO me->bdcdata.

      ENDIF.
    ENDLOOP.
    "Save the changes
    APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPL0ME6'        dynpro = '0150' dynbegin = 'X' )
       ( fnam    = 'BDC_OKCODE'      fval = '=SAVE' )
     ) TO me->bdcdata.
    "Insert the request number
    APPEND LINES OF VALUE tab_bdcdata(
   ( program = 'SAPLSTRD'        dynpro = '0300' dynbegin = 'X' )
   ( fnam    = 'KO008-TRKORR'    fval = me->request->get_number( ) )
   ( fnam    = 'BDC_OKCODE'      fval = '=LOCK' )
   ) TO me->bdcdata.

    APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPL0ME6'        dynpro = '0150' dynbegin = 'X' )
       ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )
     ) TO me->bdcdata.

  ENDMETHOD.

  METHOD call_transaction.
    super->call_transaction( ).
  ENDMETHOD.

  METHOD get_document_category.
    re_result = me->document_category.
  ENDMETHOD.

  METHOD set_document_category.
    me->document_category = im_document_category.
  ENDMETHOD.

ENDCLASS.
