@AbapCatalog.sqlViewName: 'ZMA0_SETAUT_LOGV'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Setup Automation Log - CDS'
define view ZMA0_CDS_SETAUT_LOG
with parameters
p_langu: langu 
as select from zma0_setaut_log as a
left outer join zma0_setaut_logm as b 
on b.new_plant = a.new_plant
left outer join zma0_setaut_conf as c
on c.function_name = b.function_name
left outer join dd07t as d
on d.domvalue_l = b.status 
{
    key a.new_plant,
    key b.function_name,
    a.ref_plant,
    a.ernam,
    a.erdat,
    b.status,
    @EndUserText.label: 'Status'
    @EndUserText.quickInfo: 'Status Text' d.ddtext,
    c.step,
    c.description,
    a.trnumber
}
where d.domname = 'ZMA0_SETAUT_STATUS'
and d.as4local = 'A'
and d.ddlanguage = :p_langu
