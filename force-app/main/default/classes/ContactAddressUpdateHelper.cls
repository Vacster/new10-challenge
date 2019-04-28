/**
 * A helper class to update the contact to their latest Address.
 */
public with sharing class ContactAddressUpdateHelper {

    /**
     * Updates the contacts to their latest address
     * @param  addresses List of incoming messages from Platform Event
     */
    @future
    public static void updateContacts(Set<Id> contactIds) {
        List<Contact> contacts = getContacts(contactIds);

        List<Contact> updatedContacts = new List<Contact>();
        for (Contact currentContact : contacts) {
            Address__c address = getMostRecentAddress(currentContact);

            if (address != null) {
                changeAddress(currentContact, address);
                updatedContacts.add(currentContact);
            }
        }

        if (updatedContacts.size() > 0) {
            update updatedContacts;
        }
    }

    /**
     * Updates the contact's address to the one in the Address object but doesn't commit
     * @param  currentContact The contact which will be updated
     * @param  address        The address with which to update the currentContact
     */
    private static void changeAddress(Contact currentContact, Address__c address) {
        currentContact.MailingStreet = address.Mailing_Street__c;
        currentContact.MailingCity = address.Mailing_City__c;
        currentContact.MailingState = address.Mailing_State_Province__c;
        currentContact.MailingPostalCode = address.Mailing_Zip_Postal_Code__c;
        currentContact.MailingCountry = address.Mailing_Country__c;

        currentContact.OtherStreet = address.Other_Street__c;
        currentContact.OtherCity = address.Other_City__c;
        currentContact.OtherState = address.Other_State_Province__c;
        currentContact.OtherPostalCode = address.Other_Zip_Postal_Code__c;
        currentContact.OtherCountry = address.Other_Country__c;

        currentContact.Occurred_On__c = address.Occurred_On__c;
    }

    /**
     * Returns the most recent address for a specific Contact
     * @param currentContact    The Contact with its addresses from which to compare
     * @return  The latest Address, or null if none are newer than the Contact's current one
     */
    private static Address__c getMostRecentAddress(Contact currentContact) {

        Address__c mostRecentAddress;

        for(Address__c address : currentContact.Addresses__r) {
            if (mostRecentAddress != null) {
                if (address.Occurred_On__c > mostRecentAddress.Occurred_On__c) {
                    mostRecentAddress = address;
                }
            } else if (currentContact.Occurred_On__c == null || 
                        address.Occurred_On__c > currentContact.Occurred_On__c) {
                mostRecentAddress = address;
            }
        }

        return mostRecentAddress;
    }

    /**
     * Returns a list of Contacts with their Addresses based on the set of External Ids from 
     * the incoming messages
     * @param   Contact Ids which to query from 
     * @return  List of unique contacts with their addresses and Occurred On fields 
     */
    private static List<Contact> getContacts(Set<Id> contactIds) {
        List<Contact> contacts = [SELECT Id, Occurred_On__c,
                                        (SELECT Id, Occurred_On__c, Contact__c,
                                                Mailing_Street__c, Mailing_City__c, 
                                                Mailing_State_Province__c, Mailing_Country__c,
                                                Mailing_Zip_Postal_Code__c, Other_Street__c,
                                                Other_City__c, Other_State_Province__c, 
                                                Other_Zip_Postal_Code__c, Other_Country__c
                                        FROM Addresses__r)
                                    FROM Contact 
                                    WHERE Id IN :contactIds];

        return contacts;
    }

}
