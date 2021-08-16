************************************************************************
*                                                                      *
*                           Modification Log                           *
*                                                                      *
* Program Name: zm_setaut_cockpit_classes                              *
*                                                                      *
* Author:         Pitter R Silva                                       *
* Date Written:   23Jun2021                                            *
* Requested by:   MM Direct Team                                       *
*                                                                      *
* Descriptions: Classes from Setup Automation Cockpit                  *
*                                                                      *
*                                                                      *
* Program Specifications: zma0_setaut_cockpit                          *
*   Local Class - lcl_report                                           *
*     Main methods - execute_step: method that execute the functions to*
*                                  run the plant config                *
*                                                                      *
*                                                                      *
* Mod date    Programmer  Reference    Description                     *
*----------------------------------------------------------------------*
INTERFACE lif_report.

  TYPES: BEGIN OF ty_function,
           function_name TYPE rs38l_fnam,
           step          TYPE i,
         END OF ty_function,

         BEGIN OF ty_nplant,
           nplant TYPE werks_d,
         END OF ty_nplant.

  TYPES: sty_cds TYPE zma0_setaut_logv.

  TYPES: tty_function TYPE SORTED TABLE OF ty_function
         WITH UNIQUE KEY step.

  TYPES  tty_nplant TYPE SORTED TABLE OF ty_nplant
         WITH UNIQUE KEY nplant.

ENDINTERFACE.

CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

    METHODS constructor.

    METHODS handle_function_selected FOR EVENT function_selected
    OF if_salv_gui_toolbar_ida IMPORTING ev_fcode.

    METHODS refresh_report.

    DATA ref_plant TYPE zma0_setaut_rplant.
    DATA new_plant TYPE zma0_setaut_nplant.
    DATA request   TYPE trkorr.

  PRIVATE SECTION.

    METHODS set_toolbar.

    METHODS set_report_events.

    METHODS execute_step
      IMPORTING
        VALUE(im_step) TYPE i.

    METHODS create_log
      IMPORTING
        im_ucomm    TYPE zma0_setaut_status
        im_function TYPE rs38l_fnam.

    METHODS get_all_steps
      RETURNING
        VALUE(re_result) TYPE lif_report=>tty_function.

    METHODS get_selected_row
      RETURNING
        VALUE(re_result) TYPE lif_report=>sty_cds.

    METHODS delete_row.

    METHODS change_fieldcat.

    METHODS set_filter.

    METHODS get_container
      RETURNING
        VALUE(re_result) TYPE REF TO cl_gui_docking_container.

    METHODS call_setup_config.

    METHODS get_all_newplants
      RETURNING
        VALUE(re_result) TYPE lif_report=>tty_nplant.

    METHODS is_created
      RETURNING
        VALUE(re_result) TYPE abap_bool.

    METHODS delete_setup_config.

    DATA alv TYPE REF TO if_salv_gui_table_ida.

    DATA steps TYPE lif_report=>tty_function.

ENDCLASS.

CLASS lcl_report IMPLEMENTATION.

  METHOD constructor.

*   Create alv using CDS View
    me->alv = cl_salv_gui_table_ida=>create_for_cds_view(
            iv_cds_view_name = `ZMA0_CDS_SETAUT_LOG`
            io_gui_container = me->get_container( )
          ).

*   Pass the system language for CDS View
    me->alv->set_view_parameters(
    it_parameters = VALUE #( ( name = 'p_langu' value = sy-langu ) ) ).

*   Add the filters in ALV
    me->set_filter( ).

*   Change the columns in ALV Grid
    me->change_fieldcat( ).

*   Add buttons in toolbar
    me->set_toolbar( ).

*   Get the screen event
    me->set_report_events( ).

*   Get all function module
    me->steps = me->get_all_steps( ).

  ENDMETHOD.


  METHOD set_toolbar.

    me->alv->toolbar(  )->add_separator( ).

    me->alv->toolbar(  )->add_button(
        iv_fcode     = 'CONT'
        iv_icon      = icon_arrow_right
        iv_text      = 'Continue' "Create text element and translate
        iv_quickinfo = CONV iconquick( 'Executar' ) "Create text element and translate
    ).

    me->alv->toolbar(  )->add_button(
        iv_fcode     = 'DEL'
        iv_icon      = icon_delete
        iv_text      = 'Delete' "Create text element and translate
        iv_quickinfo = CONV iconquick( 'Delete Process' ) "Create text element and translate
    ).

  ENDMETHOD.

  METHOD handle_function_selected.

* Check if the import parameter is filled
    CHECK ev_fcode IS NOT INITIAL.

    CASE ev_fcode.
      WHEN 'NEW'. "When start a new Setup
        CHECK NOT me->is_created( ).
        me->execute_step( 0 ).
      WHEN 'DEL'. "Delete all data from plant selected
*       Check if one row is selected
        CHECK me->alv->selection( )->is_row_selected( ).
*       Get the selected row
        DATA(lw_delete_row) = me->get_selected_row( ).
*       Delete selected row
        me->delete_row( ).
      WHEN 'CONT'. "Continue a process that is not finished
        CHECK me->alv->selection( )->is_row_selected( ).
        DATA(lw_selected_row) = me->get_selected_row( ).
        CHECK lw_selected_row-step IS NOT INITIAL.
*       Continue the process from the selected row
        me->execute_step( lw_selected_row-step ).
      WHEN 'FC01'.
        me->call_setup_config( ).
      WHEN 'FC02'.
        me->delete_setup_config( ).
    ENDCASE.

    me->refresh_report(  ).

  ENDMETHOD.

  METHOD set_report_events.

    SET HANDLER me->handle_function_selected FOR ALL INSTANCES.

    me->alv->selection( )->set_selection_mode(
        if_salv_gui_selection_ida=>cs_selection_mode-single
    ).

  ENDMETHOD.

  METHOD execute_step.

    DATA lv_process_status TYPE zma0_setaut_status.

    DATA(lr_request) = NEW zma0_cl_setaut_request( me->request ).

*   Loop in all function module
    LOOP AT me->steps INTO DATA(lw_steps) WHERE step >= im_step.

      CLEAR lv_process_status.

*     Create log with the status "Not completed"
      me->create_log(
          im_ucomm = lv_process_status
          im_function = lw_steps-function_name
      ).

*     Execute the function module
      CALL FUNCTION lw_steps-function_name
        EXPORTING
          im_request    = lr_request
          im_ref_plant  = me->ref_plant    " Reference Plant
          im_new_plant  = me->new_plant    " New Plant
        IMPORTING
          ex_action     = lv_process_status "screen action
        EXCEPTIONS
          error_message = 1
          OTHERS        = 2.

*     Create log with the real status after that execute the function
      me->create_log(
          im_ucomm = lv_process_status "screen action
          im_function = lw_steps-function_name "Function name
      ).

*     If the action is "Not Completed" or "Error" stop the process.
      IF lv_process_status = ' ' OR lv_process_status = 'E'.
        EXIT.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD create_log.

    DATA lt_log TYPE TABLE OF zma0_setaut_log.
    DATA lt_logm TYPE TABLE OF zma0_setaut_logm.

    lt_log = VALUE #( (
      mandt = sy-mandt
      new_plant = me->new_plant
      ref_plant = me->ref_plant
      ernam = sy-uname
      erdat = sy-datum
      trnumber = me->request
    ) ).

    lt_logm = VALUE #(
    (
      mandt = sy-mandt
      new_plant = me->new_plant
      function_name = im_function
      status = COND #( WHEN im_ucomm = 'S' THEN 'S'
      WHEN im_ucomm = 'E' THEN ' '
      WHEN im_ucomm = 'N' THEN 'N' ELSE ' ')
      message = COND #( WHEN im_ucomm = 'S' THEN text-006
      WHEN im_ucomm = 'N' THEN text-007
      WHEN im_ucomm = 'E' THEN text-008
      ELSE text-008 )
    ) ).

    MODIFY zma0_setaut_log FROM TABLE lt_log.
    MODIFY zma0_setaut_logm FROM TABLE lt_logm.

    COMMIT WORK AND WAIT.

  ENDMETHOD.

  METHOD get_all_steps.

*   Get all function modules that are configured
    SELECT function_name step
      FROM zma0_setaut_conf
      INTO TABLE re_result.

  ENDMETHOD.

  METHOD refresh_report.

    me->set_filter( ).

  ENDMETHOD.

  METHOD get_selected_row.

    DATA(lr_selection) = me->alv->selection( ).

*   get the selected row
    lr_selection->get_selected_row(
        IMPORTING
            es_row = re_result
     ).
*   Fill the attributes with the data selected
    me->new_plant = re_result-new_plant.
    me->ref_plant = re_result-ref_plant.
    me->request   = re_result-trnumber.

  ENDMETHOD.


  METHOD delete_row.

*   Get the user confirmation to delete all data from selected plant
    DATA(lv_answer) = c_utils=>popup_to_confirm(
        id_caption = text-002
        id_message = text-003
        id_text_button1 = text-004
        id_text_button2 = text-005
    ).

    CHECK lv_answer = '1'.

    DELETE FROM zma0_setaut_logm WHERE new_plant = me->new_plant.
    DELETE FROM zma0_setaut_log  WHERE new_plant = me->new_plant.

    COMMIT WORK AND WAIT.

  ENDMETHOD.

  METHOD change_fieldcat.

    DATA lt_available_fields TYPE if_salv_gui_types_ida=>yts_field_name.

*   Get the field catalog
    me->alv->field_catalog( )->get_available_fields(
    IMPORTING
        ets_field_names = lt_available_fields
     ).

*   Delete the column "Status"
    DELETE lt_available_fields WHERE table_line = 'STATUS'.

*   Set new field catalog
    me->alv->field_catalog( )->set_available_fields(
    EXPORTING
        its_field_names = lt_available_fields
     ).

  ENDMETHOD.

  METHOD set_filter.

    DATA lr_step TYPE RANGE OF ddtext.

    DATA lo_range_table TYPE REF TO cl_salv_range_tab_collector.

    IF lo_range_table IS NOT BOUND.
*   Create the parameter filter
      INSERT VALUE #(
          sign = 'I'
          option = 'EQ'
          low = 'Not Completed'
      ) INTO TABLE lr_step.

*   Create local obj
      lo_range_table = NEW #( ).

*   Add the new filter
      lo_range_table->add_ranges_for_name(
       iv_name = 'DDTEXT' it_ranges = lr_step[]
       ).

*   Create a table with the filter
      lo_range_table->get_collected_ranges(
          IMPORTING et_named_ranges = DATA(lt_named_ranges)
      ).

*   Set the filter in alv
      me->alv->set_select_options( it_ranges = lt_named_ranges ).

    ELSE.

*   Set the filter in alv
      me->alv->set_select_options( it_ranges = lt_named_ranges ).

    ENDIF.

  ENDMETHOD.


  METHOD get_container.

*   Create docking obj
    re_result = NEW #(
        repid      = sy-cprog
        extension  = 450
    ).

*   lock a screen space
    re_result->dock_at(
       EXPORTING
         side =  cl_gui_docking_container=>dock_at_bottom
         ).

  ENDMETHOD.

  METHOD call_setup_config.

    c_utils=>call_transaction(
      EXPORTING
        id_tcode  = 'ZM_SETAUT_CONF'
    ).

  ENDMETHOD.


  METHOD is_created.

    DATA(lt_nplant) =
        FILTER lif_report=>tty_nplant(
            me->get_all_newplants( )
            WHERE nplant = me->new_plant
        ).

    IF lt_nplant IS NOT INITIAL.
      MESSAGE text-009 TYPE 'S' DISPLAY LIKE 'E'.
      re_result = abap_true.
    ELSE.
      re_result = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD get_all_newplants.

    SELECT new_plant
      FROM zma0_setaut_log
      INTO TABLE re_result.

  ENDMETHOD.

  METHOD delete_setup_config.

    DATA lt_plant_value TYPE TABLE OF sval.
    DATA wa_plant_value TYPE sval.

    CLEAR wa_plant_value.

    wa_plant_value-tabname   = 'MARC'.
    wa_plant_value-fieldname = 'WERKS'.
    APPEND wa_plant_value TO lt_plant_value.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title     = 'Inform Plant Code'    " Text of title line
      TABLES
        fields          = lt_plant_value   " Table fields, values and attributes
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR wa_plant_value.

    READ TABLE lt_plant_value INTO wa_plant_value INDEX 1.

    CHECK wa_plant_value-value IS NOT INITIAL.

    DELETE FROM zma0_setaut_logm WHERE new_plant = wa_plant_value-value.
    DELETE FROM zma0_setaut_log  WHERE new_plant = wa_plant_value-value.

    IF sy-subrc IS NOT INITIAL.
      MESSAGE 'Plant not found' TYPE 'S' DISPLAY LIKE 'E'.
    ELSE.
      COMMIT WORK AND WAIT.
      MESSAGE 'Setup deleted with successfully' TYPE 'S'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
