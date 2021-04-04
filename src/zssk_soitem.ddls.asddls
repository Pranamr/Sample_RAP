@AbapCatalog.sqlViewName: 'ZSSKSOITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Order Item'
@ObjectModel.representativeKey: 'Posnr'
define view Zssk_SoItem as select from zss_vbap as SOItem
association to parent Zssk_SoHeader as _SOHeader on  $projection.Vbeln = _SOHeader.Vbeln 
 {
    key SOItem.vbeln as Vbeln,
    key SOItem.posnr as Posnr,
    SOItem.matnr as Matnr,
    SOItem.zmeng as Zmeng,
    SOItem.meins as Meins,
    
    _SOHeader
}
