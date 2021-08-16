@AbapCatalog.sqlViewName: 'ZMA0V_SETAUT_PSA'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - Release Creation Profile'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
define view ZMA0_CDS_SETAUT_PSA 
as select from t163p
 {
    mandt,
    werks,
    abueb
}