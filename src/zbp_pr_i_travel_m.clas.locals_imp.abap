*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
PRIVATE SECTION.
* Early Numering
METHODS earlynumbering_create FOR NUMBERING IMPORTING entities FOR CREATE travel.
* Action
METHODS set_status FOR MODIFY IMPORTING keys FOR ACTION travel~acceptTravel RESULT changeddata.
* Validation
METHODS validate_customer FOR VALIDATE ON SAVE IMPORTING keys FOR travel~validateCustomer.
METHODS addDiscount FOR DETERMINE ON MODIFY IMPORTING keys FOR travel~addDiscount.
METHODS discount.
endclass.

class lhc_travel IMPLEMENTATION.
METHOD earlynumbering_create.
DATA : entity TYPE STRUCTURE FOR CREATE ZPR_I_Travel_M,
       travel_id_max TYPE /dmo/travel_id.

LOOP AT entities INTO entity WHERE travel_id IS NOT INITIAL.
APPEND CORRESPONDING #( entity ) TO mapped-travel.
ENDLOOP.

DATA(entities_wo_travelid) = entities.
DELETE entities_wo_travelid WHERE travel_id IS NOT INITIAL.

" Numbering
TRY.
cl_numberrange_runtime=>number_get(
  EXPORTING
*    ignore_buffer     =
    nr_range_nr       = '01'
    object            = '/DMO/TRV_M'
    quantity          = CONV #( lines( entities_wo_travelid ) )
*    subobject         =
*    toyear            =
  IMPORTING
    number            = DATA(number_range_key)
    returncode        = DATA(number_range_return_code)
    returned_quantity = DATA(number_range_returned_quantity)
).

*CATCH cx_nr_object_not_found.
CATCH cx_number_ranges INTO DATA(lx_number_ranges).
ENDTRY.
*number_range_returned_quantity = 2.
ASSERT number_range_returned_quantity = lines( entities_wo_travelid ).
travel_id_max = number_range_key - number_range_returned_quantity.

* Set Value for Travel ID
LOOP AT entities_wo_travelid into entity.
travel_id_max = travel_id_max + 1.
entity-travel_id = travel_id_max.
APPEND CORRESPONDING #( entity ) TO mapped-travel.
ENDLOOP.
ENDMETHOD.


METHOD set_status.
MODIFY ENTITIES OF ZPR_I_Travel_M IN LOCAL MODE
  ENTITY travel
    UPDATE FIELDS ( overall_status )
    WITH VALUE #( FOR key IN KEYS (
     travel_id = key-travel_id
     overall_status = 'B'
    )
)
FAILED failed
REPORTED reported.

*Read Entity
READ ENTITIES OF ZPR_I_Travel_M IN LOCAL MODE
ENTITY travel
FIELDS ( agency_id
         AgencyName
         CustomerName
         Description
         begin_date
         created_at
         created_by
         currency_code
         customer_id
         end_date
         last_changed_at
         last_changed_by
         overall_status
         total_price
         travel_id )
WITH VALUE #( FOR key IN keys ( travel_id = key-travel_id ) )
RESULT DATA(travels).

changeddata = VALUE #( FOR travel IN travels ( travel_id = travel-travel_id
                                               %param = travel ) ).

ENDMETHOD.

METHOD validate_customer.

DATA : lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

READ ENTITIES OF ZPR_I_Travel_M IN LOCAL MODE
ENTITY travel
FIELDS ( customer_id )
WITH VALUE #( FOR key IN KEYS ( travel_id = key-travel_id ) )
RESULT DATA(lt_travel).

lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = customer_id EXCEPT * ).
DELETE lt_customer WHERE customer_id IS INITIAL.

if lt_customer IS NOT INITIAL.
  SELECT FROM /dmo/customer FIELDS customer_id
  FOR ALL ENTRIES IN @lt_customer
  WHERE customer_id = @lt_customer-customer_id
  INTO TABLE @DATA(lt_customer_db).
endif.

loop at lt_travel INTO DATA(ls_travel).
  if ls_travel-customer_id IS INITIAL
  OR NOT line_exists( lt_customer_db[ customer_id = ls_travel-customer_id ] ).
  APPEND VALUE #( travel_id = ls_travel-travel_id ) TO failed-travel.
  APPEND VALUE #(  travel_id = ls_travel-travel_id
                         %msg = new /dmo/cm_flight_messages(
                              textid = /dmo/cm_flight_messages=>customer_unkown
                              severity = IF_ABAP_BEHV_MESSAGE=>SEVERITY-error )
                         %element-customer_id = if_abap_behv=>mk-on )
          TO reported-travel.
  endif.
endloop.
ENDMETHOD.

METHOD addDiscount.
MODIFY ENTITIES OF ZPR_I_Travel_M IN LOCAL MODE
ENTITY travel
EXECUTE discount
FROM CORRESPONDING #( keys )
REPORTED DATA(lt_reported).
ENDMETHOD.

METHOD discount.
DATA a TYPE c.
a = '1'.
ENDMETHOD.

ENDCLASS.
