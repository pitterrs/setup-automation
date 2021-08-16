@AbapCatalog.sqlViewName: 'ZMA0V_SETAUT_PMT'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Assign Plant to Mat. Type Reference Information'
define view ZMA0_CDS_SETAUT_PMT
with parameters
p_new_plant: zma0_setaut_nplant,
p_ref_plant: zma0_setaut_rplant
as select from t134m as ref
inner join t134m as new
on new.bwkey = $parameters.p_new_plant
and new.mtart = ref.mtart {
    ref.mandt,
    ref.bwkey,
    ref.mtart,
    ref.mengu,
    ref.wertu,
    ref.kzpip,
    ref.xpizu 
} where ref.bwkey = $parameters.p_ref_plant