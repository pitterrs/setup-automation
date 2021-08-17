@AbapCatalog.sqlViewName: 'ZMA0V_SETAUT_PSA'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - Release Creation Profile'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
define view ZMA0_CDS_SETAUT_PSA 
with parameters
p_werks: werks_d
as select from t163p as a
left outer join t163s as b
on b.werks = a.werks
and b.abueb = a.abueb
and b.spras = 'E'
 {
    a.mandt,
    a.werks,
    a.abueb,
    b.abbez
} where a.werks = $parameters.p_werks