@AbapCatalog.sqlViewName: 'ZSSKSOHDR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Order Header'
define root view Zssk_SoHeader as select from zss_vbak as SOHeader {
    key SOHeader.vbeln as Vbeln,
    SOHeader.erdat as Erdat,
    SOHeader.ernam as Ernam,
    SOHeader.vkorg as Vkorg,
    SOHeader.vtweg as Vtweg
}
