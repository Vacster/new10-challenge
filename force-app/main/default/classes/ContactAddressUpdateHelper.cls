public with sharing class ContactAddressUpdateHelper {
    
    public static void updateContacts(List<Address_Registration__e> addresses) {
        Map<String, List<Address_Registration__e>> addressMap = 
            ContactAddressUpdateHelper.generateAddressMap(addresses);

        List<Contact> contacts = 
            ContactAddressUpdateHelper.getContacts(addressMap.keySet());

        List<Contact> updatedContacts = new List<Contact>();
        for (Contact currentContact : contacts) {
            Address_Registration__e address = 
                getMostRecentAddress(currentContact, addressMap.get(currentContact.User_Id__c));

            if (address != null) {
                changeAddress(currentContact, address);
                updatedContacts.add(currentContact);
            }
        }

        if (updatedContacts.size() > 0) {
            update updatedContacts;
        }
    }

    private static void changeAddress(Contact currentContact, Address_Registration__e address) {
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

        currentContact.Occurred_On__c = address.CreatedDate;
    }

    private static Address_Registration__e getMostRecentAddress(
        Contact currentContact, List<Address_Registration__e> addresses) {

        Address_Registration__e mostRecentAddress;

        for(Address_Registration__e address : addresses) {
            if (mostRecentAddress != null) {
                if (address.CreatedDate > mostRecentAddress.CreatedDate) {
                    mostRecentAddress = address;
                }
            } else if (currentContact.Occurred_On__c == null || 
                        address.CreatedDate > currentContact.Occurred_On__c) {
                mostRecentAddress = address;
            }
        }

        return mostRecentAddress;
    }

    private static List<Contact> getContacts(Set<String> externalIds) {
        List<Contact> contacts = [SELECT Id, User_Id__c, Occurred_On__c,
                                        MailingStreet, MailingCity, MailingState, 
                                        MailingPostalCode, MailingCountry, 
                                        OtherStreet, OtherCity, OtherState, 
                                        OtherPostalCode, OtherCountry 
                                    FROM Contact 
                                    WHERE User_Id__c IN :externalIds];

        return contacts;
    }

    private static Map<String, List<Address_Registration__e>> generateAddressMap(
        List<Address_Registration__e> addresses) {

        Map<String, List<Address_Registration__e>> addressMap = 
            new Map<String, List<Address_Registration__e>>();

        for (Address_Registration__e address : addresses) {
            if (!addressMap.containsKey(address.User_Id__c)) {
                addressMap.put(address.User_Id__c, new List<Address_Registration__e>());
            }
            addressMap.get(address.User_Id__c).add(address);
        }

        return addressMap;
    }
}
