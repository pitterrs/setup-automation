CLASS lcl_purchorg_dao IMPLEMENTATION.

  METHOD constructor.

    CHECK im_is_test IS INITIAL.

    "passando estrutura TY completa e não só o numero de purchorg
    me->purchorg = me->retrieve_purchorg_plants(
        im_plants = im_plants ).
*   im_purchorg = im_purchorg ).


  ENDMETHOD.

  METHOD get_purchorg.

    re_result = me->purchorg.

  ENDMETHOD.

  METHOD set_purchorg.

    me->purchorg = im_purchorg.

  ENDMETHOD.


  METHOD retrieve_purchorg_plants.


    CHECK im_plants IS NOT INITIAL.

*    SELECT mandt ekorg werks ekotx name1 status_mm_assign
    SELECT mandt werks ekorg
*    FROM zw_t024w_assign
        FROM t024w
        INTO TABLE re_result
        WHERE werks IN im_plants.


  ENDMETHOD.


ENDCLASS.

CLASS lcl_batch_input IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
            im_request     = im_request
            im_transaction = 'OX17'
        ).

  ENDMETHOD.

  METHOD fill_bdcdata.
    "Call the position button"
    LOOP AT im_ref_plant_info INTO DATA(lw_ref_plant_info).
      APPEND LINES OF VALUE tab_bdcdata(
      ( program = 'SAPLCUST_ASSIGN_MM' dynpro = '0004' dynbegin = 'X' )
      ( fnam    = 'BDC_OKCODE'      fval = '=POSI' )
      ) TO me->bdcdata.

      "Inform the reference plant w/ the purch. organization to be selected"
      APPEND LINES OF VALUE tab_bdcdata(
         ( program = 'SAPLSPO4' dynpro = '0300' dynbegin = 'X' )
         ( fnam    = 'SVALD-VALUE(01)' fval = lw_ref_plant_info-ekorg )
         ( fnam    = 'SVALD-VALUE(02)' fval = lw_ref_plant_info-werks )
         ( fnam    = 'BDC_OKCODE'      fval = '=FURT' )
       ) TO me->bdcdata.

      "Click in copy"
      APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPLCUST_ASSIGN_MM' dynpro = '0004' dynbegin = 'X' )
       ( fnam    = 'VIM_MARKED(01)'  fval = 'X' )
       ( fnam    = 'BDC_OKCODE'      fval = '=KOPE' )
       ) TO me->bdcdata.

      "Input the new plant value and ENTER"
      APPEND LINES OF VALUE tab_bdcdata(
       ( program = 'SAPLCUST_ASSIGN_MM' dynpro = '0004' dynbegin = 'X' )
       ( fnam    = 'W_T024W_ASSIGN-EKORG(01)' fval = lw_ref_plant_info-ekorg )
       ( fnam    = 'W_T024W_ASSIGN-WERKS(01)' fval = im_new_plant )
       ( fnam    = 'BDC_OKCODE'      fval = '=KOPF' )
       ) TO me->bdcdata.
    ENDLOOP.

    "Save the registers after the loop execution"
    APPEND LINES OF VALUE tab_bdcdata(
     ( program = 'SAPLCUST_ASSIGN_MM' dynpro = '0004' dynbegin = 'X' )
     ( fnam    = 'BDC_OKCODE'      fval = '=SAVE' )
     ) TO me->bdcdata.

    "Inform the Transportation Request and ENTER"
    APPEND LINES OF VALUE tab_bdcdata(
   ( program = 'SAPLSTRD' dynpro = '0300' dynbegin = 'X' )
   ( fnam    = 'KO008-TRKORR'    fval = me->request->get_number( ) )
   ( fnam    = 'BDC_OKCODE'      fval = '=LOCK' )
   ) TO me->bdcdata.

    APPEND LINES OF VALUE tab_bdcdata(
    ( program = 'SAPLCUST_ASSIGN_MM'  dynpro = '0004' dynbegin = 'X' )
    ( fnam    = 'BDC_OKCODE'      fval = '=BACK' )
  ) TO me->bdcdata.

  ENDMETHOD.

ENDCLASS.
