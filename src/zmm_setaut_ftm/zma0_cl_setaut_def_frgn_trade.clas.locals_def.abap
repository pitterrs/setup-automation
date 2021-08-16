CLASS lcl_foreign_trade_msg_dao DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant
        VALUE(im_new_plant) TYPE zma0_setaut_nplant.

    METHODS set_def_frgn_trade
      IMPORTING
        VALUE(im_def_frgn_trade) TYPE
          zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

    METHODS get_def_frgn_trade
      RETURNING
        VALUE(re_def_frgn_trade)
          TYPE zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

          PROTECTED SECTION.

  PRIVATE SECTION.

    DATA rel_plant_mat_type
        TYPE zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

    METHODS retrieve_def_frgn_trade
      IMPORTING
        VALUE(im_ref_plant) TYPE zma0_setaut_rplant
      RETURNING
        VALUE(re_result)
          TYPE zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg.

ENDCLASS.


CLASS lcl_batch_input DEFINITION
INHERITING FROM zma0_cl_setaut_batch_input.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_request) TYPE REF TO  zma0_cl_setaut_request.

    METHODS fill_bdcdata
      IMPORTING
        VALUE(im_foreign_trade_msg)
          TYPE zma0_cl_setaut_def_frgn_trade=>tty_foreign_trade_msg
        VALUE(im_new_plant)         TYPE zma0_setaut_nplant.

ENDCLASS.
