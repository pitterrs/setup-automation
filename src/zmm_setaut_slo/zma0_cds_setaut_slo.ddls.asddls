@AbapCatalog.sqlViewName: 'ZMA0V_SETAUT_SLO'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MM Setup Automation: Create Storage Location'
define view ZMA0_CDS_SETAUT_SLO
as select from t001l {
  mandt,
  werks,
  lgort,
  lgobe
}