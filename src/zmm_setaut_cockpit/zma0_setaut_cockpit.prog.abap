************************************************************************
*                                                                      *
*                           Modification Log                           *
*                                                                      *
* Program Name: zma0_setaut_cockpit                                    *
*                                                                      *
* Author: Pitter R Silva                                               *
* Date Written: June 23th, 2021                                        *
* Request #: CAGK9C25HH                                                *
* Requested by: MM Direct Team                                         *
* Description: Cockpit for automate the configuration for new plants   *
*                                                                      *
* Mod date  Programmer    Reference   Description                      *
*----------------------------------------------------------------------*
*
************************************************************************
REPORT zma0_setaut_cockpit.

TABLES: sscrfields, MARA. " Required for the toolbar buttons

TYPES: matnr TYPE mara-matnr,
       ersda TYPE mara-ersda,
       ernam TYPE mara-ernam.

INCLUDE zm_setaut_cockpit_top.
INCLUDE zm_setaut_cockpit_classes. "classes definition/implementation

SELECTION-SCREEN BEGIN OF BLOCK b1.
PARAMETERS p_nplant TYPE zma0_setaut_nplant. "New Plant
PARAMETERS p_rplant TYPE zma0_setaut_rplant. "Reference Plant
PARAMETERS p_transp TYPE trkorr.             "Transport Request
SELECTION-SCREEN FUNCTION KEY 1.             "Setup Config Button
SELECTION-SCREEN FUNCTION KEY 2.             "Delete Plant Setup Button
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN SKIP 2.
SELECTION-SCREEN: PUSHBUTTON 1(12) text-001 USER-COMMAND new. "Button New Process

INITIALIZATION.

  PERFORM: set_screen_function
    USING icon_activity
          'Setup Auto. Config.'
          'Setup Automation Configuration'
    CHANGING sscrfields-functxt_01.

  PERFORM: set_screen_function
    USING icon_delete
          'Delete Plant Setup'
          'Delete Plant Setup'
    CHANGING sscrfields-functxt_02.

  DATA(r_report) = NEW lcl_report( ). "Create obj lcl_report(local Class)

AT SELECTION-SCREEN OUTPUT.

  PERFORM insert_into_excl(rsdbrunt) USING 'SPOS'. "Remove button Save
  PERFORM insert_into_excl(rsdbrunt) USING 'ONLI'. "Remove button execute

AT SELECTION-SCREEN.

  ok_code = sy-ucomm. "Get the screen command

* Fill the attributes of the class when start a new setup
  IF ok_code EQ 'NEW'.
    r_report->ref_plant = p_rplant. "Reference Plant
    r_report->new_plant = p_nplant. "New Plant
    r_report->request   = p_transp. "Transport Request
  ENDIF.

* Call method that control the screen actions
  r_report->handle_function_selected( ok_code ).

START-OF-SELECTION.

FORM set_screen_function
  USING
    p_icon TYPE icon_d
    p_text TYPE gui_ictext
    p_info TYPE gui_info
  CHANGING
    p_func TYPE rsfunc_txt.

  DATA: button TYPE smp_dyntxt.

  button-icon_id = p_icon.
  button-icon_text = p_text.
  button-quickinfo = p_info.
  p_func = button.

ENDFORM.                    "SET_SCREEN_FUNCTION
