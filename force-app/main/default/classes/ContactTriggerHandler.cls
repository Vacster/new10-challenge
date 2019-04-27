public with sharing class ContactTriggerHandler {
    
     public void onAfterUpdate(Map<Id, Contact> oldContacts, Map<Id, Contact> newContacts) {
         List<Id> contactIds = new List<Id>();

         for (Contact newContact : newContacts.values()) {
            if (newContact.Occurred_On__c != oldContacts.get(newContact.Id).Occurred_On__c) {
                contactIds.add(newContact.Id);
            }
         }

        ContactGeolocationHelper.updateContactsGeolocations(contactIds);
     }

}
