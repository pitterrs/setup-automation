************************************************************************
*                                                                      *
*                           Modification Log                           *
*                                                                      *
* Program Name: zm_setaut_class_imp                                    *
*                                                                      *
* Author:         Pitter R Silva                                       *
* Date Written:   23Jun2021                                            *
* Requested by:   MM Direct Team                                       *
*                                                                      *
* Descriptions:                                                        *
*                                                                      *
*                                                                      *
* Program Specifications:                                              *
*   Local Class - *                                                    *
*     Main methods - *                                                 *
*                  - *                                                 *
*                                                                      *
* Mod date    Programmer  Reference    Description                     *
*----------------------------------------------------------------------*

CLASS lcl_report IMPLEMENTATION.

  METHOD constructor.

    CREATE OBJECT r_docking
      EXPORTING
        repid      = sy-cprog
        extension  = 300
*       side       = cl_gui_docking_container=>dock_at_bottom
      EXCEPTIONS
        cntl_error = 1
        OTHERS     = 2.

    r_docking->dock_at(
       EXPORTING
         side =  cl_gui_docking_container=>dock_at_bottom
       EXCEPTIONS
         cntl_error = 1
         OTHERS     = 2
         ).

    me->alv = cl_salv_gui_table_ida=>create_for_cds_view(
            iv_cds_view_name = `ZMA0_CDS_SETAUT_LOG`
            io_gui_container = r_docking

          ).

    me->set_toolbar(  ).

    me->set_report_events(  ).

  ENDMETHOD.


  METHOD set_toolbar.

    me->alv->toolbar(  )->add_separator( ).

    me->alv->toolbar(  )->add_button(
        iv_fcode     = 'Continue'
        iv_icon      = icon_arrow_right
        iv_text      = 'Continue' "Create text element and translate
        iv_quickinfo = CONV iconquick( 'Executar' ) "Create text element and translate
    ).

  ENDMETHOD.

  METHOD handle_function_selected.

    CHECK ev_fcode IS INITIAL.

  ENDMETHOD.

  METHOD set_report_events.

    SET HANDLER me->handle_function_selected FOR ALL INSTANCES.

    me->alv->selection( )->set_selection_mode(
        if_salv_gui_selection_ida=>cs_selection_mode-single
    ).

  ENDMETHOD.

ENDCLASS.
