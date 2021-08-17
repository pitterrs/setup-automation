@AbapCatalog.sqlViewName: 'ZMA0V_CDS_STD'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - Assign Delivery Type and Checking Rules'
define view ZMA0_CDS_SETAUT_STD
as select from t161v {
    bstyp,
    bsart,
    reswk,
    lfart,
    prreg,
    mevst,
    merfp,
    lfart1,
    lfart2,
    lfcon,
    atpconfmrp
} 