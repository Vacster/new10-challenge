/**
 * Helper that updates the Contact's Geolocation values based on their address.
 * It works with Google's Geocoding API.
 */
public with sharing class ContactGeolocationHelper {

    /**
     * These variables should be stored elsewhere in a Real Environment 
     * but for the purpose of this challenge they do fine as static strings.
     */
    private static final String API_KEY = 'AIzaSyAsM4Y5PY5-OGI_C8HCLRTwBQKUqUuNy74';
    private static final string BASE_URI = 'https://maps.googleapis.com/maps/api/geocode/json?';
    
    /**
     * Future method that updates a contact's Geolocation values based on their address
     * @param  contactIds The list of Ids of the Contacts to query
     */
    @future(callout=true)
    private static void updateGeolocation(List<Id> contactIds) {
        List<Contact> contacts = 
            [SELECT Id, MailingStreet, MailingCity, 
                    MailingState, MailingCountry,
                    MailingPostalCode, OtherStreet,
                    OtherCity, OtherState, 
                    OtherPostalCode, OtherCountry
            FROM Contact
            WHERE Id IN :contactIds];

        List<Contact> updatedContacts = new List<Contact>();
        for (Contact currentContact : contacts) {
            Boolean updatedMailingAddress = getMailingGeolocation(currentContact);
            Boolean updatedOtherAddress = getOtherGeolocation(currentContact);

            if (updatedMailingAddress || updatedOtherAddress) {
                updatedContacts.add(currentContact);
            }
        }
        
        if (updatedContacts.size() > 0) {
            update updatedContacts;
        }
    }

    /**
     * Update's the contact's MailingGeolocation if it has an MailingAddress
     * @param  currentContact The contact to update their MailingGeolocation
     * @return                returns true if the contact was updated, false otherwise
     */
    private static Boolean getMailingGeolocation(Contact currentContact) {

        String mailingAddress = '';
        if (currentContact.MailingStreet != null) {
            mailingAddress += currentContact.MailingStreet + ',';
        }
        if (currentContact.MailingCity != null) {
            mailingAddress += currentContact.MailingCity + ',';
        }
        if (currentContact.MailingState != null) {
            mailingAddress += currentContact.MailingState + ',';
        }
        if (currentContact.MailingPostalCode != null) {
            mailingAddress += currentContact.MailingPostalCode + ',';
        }
        if (currentContact.MailingCountry != null) {
            mailingAddress += currentContact.MailingCountry;
        }

        mailingAddress = EncodingUtil.urlEncode(mailingAddress, 'UTF-8');
        
        if (String.isBlank(mailingAddress)) {
            System.debug('Mailing Address is blank');
            return false;
        }

        /**
         * Create and send the callout.
         * In a real environment this would be more standarized and probably use a helper class
         * with error handling and common debugging/reporting methods.
         */
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(BASE_URI + '&address=' + mailingAddress + '&key=' + API_KEY);
        req.setMethod('GET');
        req.setTimeout(60000);

        HttpResponse res = h.send(req);
        if (res.getStatusCode() == 200) {
            //Deserializes the response into an easily readable Apex class
            GoogleGeocodingContainer container = GoogleGeocodingContainer.parse(res.getBody());

            currentContact.MailingLatitude = container.results.get(0).geometry.location.lat;
            currentContact.MailingLongitude = container.results.get(0).geometry.location.lng;
            return true;
        }
        return false;
    }

    /**
     * Update's the contact's OtherGeolocation if it has an OtherAddress
     * @param  currentContact The contact to update their OtherGeolocation
     * @return                returns true if the contact was updated, false otherwise
     */
    private static Boolean getOtherGeolocation(Contact currentContact) {

        String otherAddress = '';
        if (currentContact.OtherStreet != null) {
            otherAddress += currentContact.OtherStreet + ',';
        }
        if (currentContact.OtherCity != null) {
            otherAddress += currentContact.OtherCity + ',';
        }
        if (currentContact.OtherState != null) {
            otherAddress += currentContact.OtherState + ',';
        }
        if (currentContact.OtherPostalCode != null) {
            otherAddress += currentContact.OtherPostalCode + ',';
        }
        if (currentContact.OtherCountry != null) {
            otherAddress += currentContact.OtherCountry;
        }

        otherAddress = EncodingUtil.urlEncode(OtherAddress, 'UTF-8');
        
        if (String.isBlank(OtherAddress)) {
            System.debug('Other Address is blank');
            return false;
        }

        /**
         * Create and send the callout.
         * In a real environment this would be more standarized and probably use a helper class
         * with error handling and common debugging/reporting methods.
         */
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(BASE_URI + '&address=' + otherAddress + '&key=' + API_KEY);
        req.setMethod('GET');
        req.setTimeout(60000);

        HttpResponse res = h.send(req);
        if (res.getStatusCode() == 200) {
            //Deserializes the response into an easily readable Apex class
            GoogleGeocodingContainer container = GoogleGeocodingContainer.parse(res.getBody());

            currentContact.OtherLatitude = container.results.get(0).geometry.location.lat;
            currentContact.OtherLongitude = container.results.get(0).geometry.location.lng;
            return true;
        }
        return false;
    }

    /**
     * Invocable Method that calls a future method to update each contact's geolocation
     * @param  contactIds The Id of the contacts to update
     */
    @InvocableMethod(label='Update Geolocations')
    public static void updateContactsGeolocations(List<Id> contactIds) {
        updateGeolocation(contactIds);
    }
}
