/**
 * The handler for the Address Registration Platform Event trigger.
 */
public with sharing class AddressRegistrationTriggerHandler {
    
    /**
     * Creates new Address__c records based on the incoming address from Platform Events
     * and calls ContactAddressUpdateHelper to update the appropriate contacts.
     * @param  addresses List of Address_Registrations__e messages
     */
    public void onAfterInsert(List<Address_Registration__e> addresses) {
        Set<String> contactExternalIds = new Set<String>();
        for (Address_Registration__e address : addresses) {
            contactExternalIds.add(address.User_Id__c);
        }

        //Create a Map relating External_Id to Contact Id
        List<Contact> contacts = [SELECT Id, User_Id__c
                                    FROM Contact 
                                    WHERE User_Id__c 
                                    IN :contactExternalIds];

        Map<String, Id> contactsMap = new Map<String, Id>();
        for (Contact currentContact : contacts) {
            contactsMap.put(currentContact.User_Id__c, currentContact.Id);
        }

        //Create the address records
        List<Address__c> newAddresses = new List<Address__c>();
        for (Address_Registration__e address : addresses) {
            Address__c newAddress = new Address__c(
                Contact__c = contactsMap.get(address.User_Id__c),
                Occurred_On__c = System.now(),
                Mailing_City__c = address.Mailing_City__c,
                Mailing_Country__c = address.Mailing_Country__c,
                Mailing_State_Province__c = address.Mailing_State_Province__c,
                Mailing_Street__c = address.Mailing_Street__c,
                Mailing_Zip_Postal_Code__c = address.Mailing_Zip_Postal_Code__c,
                Other_City__c = address.Other_City__c,
                Other_Country__c = address.Other_Country__c,
                Other_State_Province__c = address.Other_State_Province__c,
                Other_Street__c = address.Other_Street__c,
                Other_Zip_Postal_Code__c = address.Other_Zip_Postal_Code__c
            );

            newAddresses.add(newAddress);
        }

        if (newAddresses.size() > 0) {
            insert newAddresses;
        }

        //Update the appropriate contacts
        Set<Id> contactIds = (new Map<Id, SObject>(contacts)).keySet();
        ContactAddressUpdateHelper.updateContacts(contactIds);
    }
}
