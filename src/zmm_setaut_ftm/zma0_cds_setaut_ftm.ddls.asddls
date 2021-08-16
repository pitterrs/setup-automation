@AbapCatalog.sqlViewName: 'ZMA0V_SETAUT_FTM'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - Define Control of Foreign Trade Messages'
define view ZMA0_CDS_SETAUT_FTM
with parameters
p_ref_plant: zma0_setaut_rplant
 as select from t609p as a
 inner join t685 as b on
 b.kvewe = 'B' and
 b.kappl = a.kappl and
 b.kschl = a.kschl {
    a.mandt,
    a.kappl,
    a.kschl,
    a.werks,
    a.stawd,
    a.packd,
    a.ftpra
} where a.werks = $parameters.p_ref_plant
    and a.kappl = 'V3'