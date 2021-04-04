@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel view - CDS data model'
@Metadata.allowExtensions: true
@UI: {headerInfo : {typeName: 'Travel' , typeNamePlural: 'Travels' , title: {type: #STANDARD, value: 'travel_id'} }}
define root view entity ZPR_I_Travel_M as select from zpr_travel2_m as Travel 
  composition [0..*] of ZPR_I_Booking_M as _Booking

  association [0..1] to /DMO/I_Agency    as _Agency   on $projection.agency_id     = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer  as _Customer on $projection.customer_id   = _Customer.CustomerID
  association [0..1] to I_Currency       as _Currency on $projection.currency_code = _Currency.Currency
 {

  key travel_id,      
    agency_id,  
    _Agency.Name as AgencyName,          
    customer_id as customer_id, 
    _Customer.LastName as CustomerName, 
    begin_date, //as BeginDate,  
    end_date,   //as EndDate,   
    @Semantics.amount.currencyCode: 'currency_code'
    total_price, // as TotalPrice,  

    currency_code, //as CurrencyCode,  
    overall_status, //as TravelStatus,
    description as Description,   
    @Semantics.user.createdBy: true 
    created_by,
    @Semantics.systemDateTime.createdAt: true       
    created_at,
    @Semantics.user.lastChangedBy: true    
    last_changed_by,
    //local ETag field --> OData ETag
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at,

    
    /* Associations */
    _Booking,
    _Agency,
    _Customer, 
    _Currency    
}
