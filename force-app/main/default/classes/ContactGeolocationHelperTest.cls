/**
 * Test class for ContactGeolocationHelper
 */
@isTest
public class ContactGeolocationHelperTest {

    /**
     * 40 Contacts are created for the callout.
     * 20 of them have addresses and 20 of them do not.
     */
    @TestSetup
    private static void makeData() {
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 20; i++) {
            Contact c = new Contact(
                LastName = 'PositiveTest' + i,
                MailingStreet = 'MailingStret' + i,
                MailingCity = 'MailingCity' + i, 
                MailingState = 'MailingState' + i,
                MailingCountry = 'MailingCountry' + i,
                MailingPostalCode = 'MailingPostalCode' + i,
                OtherStreet = 'OtherStreet' + i,
                OtherCity = 'OtherCity' + i, 
                OtherState = 'OtherState' + i, 
                OtherPostalCode = 'OtherPostalCode' + i, 
                OtherCountry = 'OtherCountry' + i
            );

            contacts.add(c);
        }

        for (Integer i = 0; i < 20; i++) {
            Contact c = new Contact(
                LastName = 'NegativeTest' + i
            );
            contacts.add(c);
        }

        insert contacts;

        Integer arrSize = [SELECT Id FROM Contact].size();
        System.assertEquals(40, arrSize, 'Contacts not being inserted.');
    }

    /**
     * Performs a Geocoding callout with good contacts and a good response.
     */
    @isTest
    private static void positiveCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new GeolocationCalloutMock(true));

        List<Id> contactIds = new List<Id>();
        for (Contact c : [SELECT Id FROM Contact WHERE LastName LIKE 'Positive%']) {
            contactIds.add(c.Id);
        }
        
        Test.startTest();
            ContactGeolocationHelper.updateContactsGeolocations(contactIds);
        Test.stopTest();
        
        Integer caseAmount = [SELECT Id FROM Case].size();
        System.assertEquals(20, caseAmount, 'Cases not created.');

        for (Contact c : [SELECT Id, MailingLatitude, MailingLongitude, 
            OtherLatitude, OtherLongitude FROM Contact
            WHERE LastName LIKE 'Positive%']) {
                System.assertNotEquals(null, c.MailingLatitude, 'MailingLatitude not set');
                System.assertNotEquals(null, c.MailingLongitude, 'MailingLongitude not set');
                System.assertNotEquals(null, c.OtherLatitude, 'OtherLatitude not set');
                System.assertNotEquals(null, c.OtherLongitude, 'OtherLongitude not set');
        }
    }

    /**
     * Performs a Geocoding callout with good contacts and a bad response.
     */
    @isTest
    private static void negativeCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new GeolocationCalloutMock(false));

        List<Id> contactIds = new List<Id>();
        for (Contact c : [SELECT Id FROM Contact WHERE LastName LIKE 'Positive%']) {
            contactIds.add(c.Id);
        }
        
        Test.startTest();
            ContactGeolocationHelper.updateContactsGeolocations(contactIds);
        Test.stopTest();
        
        Integer caseAmount = [SELECT Id FROM Case].size();
        System.assertEquals(0, caseAmount, 'Cases created');

        for (Contact c : [SELECT Id, MailingLatitude, MailingLongitude, 
            OtherLatitude, OtherLongitude FROM Contact 
            WHERE LastName LIKE 'Positive%']) {
                System.assertEquals(null, c.MailingLatitude, 'MailingLatitude set');
                System.assertEquals(null, c.MailingLongitude, 'MailingLongitude set');
                System.assertEquals(null, c.OtherLatitude, 'OtherLatitude set');
                System.assertEquals(null, c.OtherLongitude, 'OtherLongitude set');
        }
    }

    /**
     * Performs a good callout with empty contacts.
     */
    @isTest
    private static void blankContactCallout() {
        Test.setMock(HttpCalloutMock.class, new GeolocationCalloutMock(true));

        List<Id> contactIds = new List<Id>();
        for (Contact c : [SELECT Id FROM Contact WHERE LastName LIKE 'Negative%']) {
            contactIds.add(c.Id);
        }
        
        Test.startTest();
            ContactGeolocationHelper.updateContactsGeolocations(contactIds);
        Test.stopTest();
        
        Integer caseAmount = [SELECT Id FROM Case].size();
        System.assertEquals(0, caseAmount, 'Cases created.');

        for (Contact c : [SELECT Id, MailingLatitude, MailingLongitude, 
            OtherLatitude, OtherLongitude FROM Contact
            WHERE LastName LIKE 'Negative%']) {
                System.assertEquals(null, c.MailingLatitude, 'MailingLatitude set');
                System.assertEquals(null, c.MailingLongitude, 'MailingLongitude set');
                System.assertEquals(null, c.OtherLatitude, 'OtherLatitude set');
                System.assertEquals(null, c.OtherLongitude, 'OtherLongitude set');
        }
    }
}