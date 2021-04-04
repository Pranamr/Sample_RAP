@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel View - Consumption CDS Data model'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZPR_C_TRAVEL_M as projection on ZPR_I_Travel_M {
 @Search.defaultSearchElement: true
  key travel_id,      
 @Search.defaultSearchElement: true
 @Consumption.valueHelpDefinition: [{entity : {name: '/DMO/I_Agency', element: 'AgencyID'} }]
 @ObjectModel.text.element: ['AgencyName']
    agency_id,  
    AgencyName,       
    
 @Consumption.valueHelpDefinition: [{entity : {name: '/DMO/I_Customer', element: 'CustomerID'} }]
 @ObjectModel.text.element: ['CustomerName']   
 @Search.defaultSearchElement: true 
    customer_id, 
    CustomerName, 
    begin_date,  
    end_date,   

    @Semantics.amount.currencyCode: 'currency_code'
    total_price,  
    @Consumption.valueHelpDefinition: [{entity: { name: 'I_Currency', element: 'Currency'} }]
    currency_code,  
    overall_status,
    Description as Description,   
    @Semantics.user.createdBy: true 
    created_by,
    @Semantics.systemDateTime.createdAt: true       
    created_at,
    @Semantics.user.lastChangedBy: true    
    last_changed_by,
    //local ETag field --> OData ETag
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at    
}
