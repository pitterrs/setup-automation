CLASS zma0_cl_setaut_utils DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS convert_action_to_status
    IMPORTING VALUE(im_action) TYPE sy-ucomm
    RETURNING VALUE(re_result) TYPE zma0_setaut_status.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS zma0_cl_setaut_utils IMPLEMENTATION.

  METHOD convert_action_to_status.

    re_result = cond #(
        when im_action = 'BACK'
          or im_action = 'EXIT'
          or im_action = 'CANCEL'
        THEN '' " Not Completed
        WHEN im_action = 'SKIP'
        THEN 'N' " Skipped
        WHEN im_action = 'EXE'
        THEN 'S' " Completed
    ).

  ENDMETHOD.

ENDCLASS.
