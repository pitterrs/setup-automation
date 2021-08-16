************************************************************************
*                                                                      *
*                           Modification Log                           *
*                                                                      *
* Program Name: zm_setaut_class_def                                    *
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

CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

    METHODS constructor.

    METHODS handle_function_selected FOR EVENT function_selected
    OF if_salv_gui_toolbar_ida IMPORTING ev_fcode.

  PRIVATE SECTION.

    METHODS set_toolbar.

    METHODS set_report_events.

    DATA alv TYPE REF TO if_salv_gui_table_ida.




ENDCLASS.
