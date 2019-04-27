public with sharing class ContactGeolocationHelper {

    private static final string BASE_URI = 'https://maps.googleapis.com/maps/api/geocode/json?';
    private static final String API_KEY = 'AIzaSyAsM4Y5PY5-OGI_C8HCLRTwBQKUqUuNy74';

    @future(callout=true)
    private static void updateGeolocation(Id contactId) {
        Contact currentContact = 
            [SELECT Id, MailingStreet, MailingCity, 
                    MailingState, MailingCountry,
                    MailingPostalCode, OtherStreet,
                    OtherCity, OtherState, 
                    OtherPostalCode, OtherCountry
            FROM Contact
            WHERE Id = :contactId];

        Boolean updatedMailingAddress = getMailingGeolocation(currentContact);
        Boolean updatedOtherAddress = getOtherGeolocation(currentContact);

        if (updatedMailingAddress || updatedOtherAddress) {
            update currentContact;
        }
    }

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

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(BASE_URI + '&address=' + mailingAddress + '&key=' + API_KEY);
        req.setMethod('GET');
        req.setTimeout(60000);

        HttpResponse res = h.send(req);
        if (res.getStatusCode() == 200) {
            GoogleGeocodingContainer container = GoogleGeocodingContainer.parse(res.getBody());

            currentContact.MailingLatitude = container.results.get(0).geometry.location.lat;
            currentContact.MailingLongitude = container.results.get(0).geometry.location.lng;
            return true;
        }
        return false;
    }

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

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(BASE_URI + '&address=' + otherAddress + '&key=' + API_KEY);
        req.setMethod('GET');
        req.setTimeout(60000);

        HttpResponse res = h.send(req);
        if (res.getStatusCode() == 200) {
            GoogleGeocodingContainer container = GoogleGeocodingContainer.parse(res.getBody());

            currentContact.OtherLatitude = container.results.get(0).geometry.location.lat;
            currentContact.OtherLongitude = container.results.get(0).geometry.location.lng;
            return true;
        }
        return false;
    }

    @InvocableMethod(label='Update Geolocations')
    public static void updateContactsGeolocations(List<Id> contactIds) {
        for (Id contactId : contactIds) {
            updateGeolocation(contactId);
        }
    }
}
