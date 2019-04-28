/**
 * The handler for the Contact Trigger
 */
public with sharing class ContactTriggerHandler {
    
    /**
     * Called on Contact's after update trigger
     * @param  oldContacts The Trigger.oldMap value from the Trigger
     * @param  newContacts The Trigger.newMap value from the Trigger
     */
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
