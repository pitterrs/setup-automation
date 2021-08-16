CLASS zma0_cl_setaut_request DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        VALUE(im_number) TYPE trkorr.

    METHODS get_number
      RETURNING VALUE(re_result) TYPE trkorr.

    METHODS set_number
      IMPORTING VALUE(im_number) TYPE trkorr.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA number TYPE trkorr.

ENDCLASS.

CLASS zma0_cl_setaut_request IMPLEMENTATION.

  METHOD constructor.

    me->number = im_number.

  ENDMETHOD.

  METHOD get_number.

    re_result = me->number.

  ENDMETHOD.

  METHOD set_number.

    me->number = im_number.

  ENDMETHOD.

ENDCLASS.
