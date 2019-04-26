public with sharing class AddressRegistrationTriggerHandler {
    
    public void onAfterInsert(List<Address_Registration__e> addresses) {
        ContactAddressUpdateHelper.updateContacts(addresses);
    }
}
