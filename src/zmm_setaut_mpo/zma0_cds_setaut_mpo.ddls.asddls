@AbapCatalog.sqlViewName: 'ZMA0V_SETAUT_MPO'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - Maintain Purchasing Organization'
define view ZMA0_CDS_SETAUT_MPO
//with parameters
//p_ekorg: ekorg
as select from t024e
 {
    mandt,
    ekorg,
    ekotx
} //where ekorg = $parameters.p_ekorg