# New10 Challenge

This challenge has been completed by Kamil Segebre for the interview process in New10 in Amsterdam.

## Resources

For this challenge, only the resources in https://developer.salesforce.com were used except for the case of UUID generation.
For code style, Google's Java Style Guide was followed: https://google.github.io/styleguide/javaguide.html

## Notes Before Reading
- Everything done in the project has a reason. The more odd-looking parts are usually commented and I'm open to *any* question in terms of why I did something a certain way.
- Every Class and Method has been commented in a realistic way.
- The challenge was developed exclusively with SFDX and Visual Studio Code except for declarative parts like Flow creation and Platform Events declarations.
- Class names are more explicit (longer) than normal, but again this was done to follow the most general approach possible in terms of style.
- Every Trigger has a Handler similar to how it would be developed in a real scenario but they are 'incomplete' in the sense that not every event is being handled in the Trigger/Handler (even if only to do a System.debug print) like it would normally be done when following a Trigger framework.
- Error handling and reporting, especially when it comes to Exceptions is done to a minimum or not at all besides Apex Tests as I considered them outside the scope of the project, especially due to time constraints. I also consider an uncaught exception that sends an email could be better than a caught, unreported one.

## Description of Files and Directories

The project consists of several files, these are:

### Triggers
All Triggers have their respective Trigger Handler in order to follow Salesforce's best practices.

| Name | Description |
| --- | --- | 
| AddressRegistrationTrigger | The Trigger from the Address Registration PE | 
| GeocodingCaseClosedTrigger | The Trigger from the Geocoding Case Closed PE | 
| CaseTrigger | Trigger for Cases, handles before insert and after update |
| ContactTrigger | Trigger for Contacts, handles after update |

### Trigger Handlers
| Name | Description |
| --- | --- |
| AddressRegistrationTriggerHandler | Handles the creation of Address__c records for their respective Contacts. Also calls to update the contacts' geolocations which were updated |
| GeocodingCaseClosedTriggerHandler | Handles the creation of new Cases with the Subject 'I am done' |
| CaseTriggerHandler | Handles the assignment of UUID to each new Case and also publishes the Geocoding Case Closed PE on Case Closed|
| ContactTriggerHandler | Handles the call to update the Contact's geolocation when the Ocurred_On__c field is changed (so when a newer Address has been assigned) |

### Classes
These classes include helpers and other useful things

| Name | Description |
| --- | --- |
| ContactAddressUpdateHelper | Helper that updates the Contact's address to the newest one based on their related Address__c records, especially their Ocurred_On__c field to determine the newest one |
| ContactGeolocationHelper | The class which include an InvocableMethod (for the Flow) and also the Web Callouts inside a Future method (async) and updates the Contacts accordingly |
| GoogleGeocodingContainer | A container class for Google's Geocoding API response to be deserialized into. Useful for easier handling of a consistent JSON response. |
| UUIDHelper | A simple class which generates an (almost fully valid) appropriate 36-char UUID v4 for Cases |

### Test Classes and Mocks
Not much Unit Testing was done due to lack of time but the ones done do a good job at understanding the usual structure.
The test classes aren't too atomic but this was done on purpose to show a more complex scenario than single-method-testing would provide.
An HttpCalloutMock Class was created to test the Web Callout for Google's Geocoding API

| Name | Description |
| --- | --- |
| CaseTriggerTest | Tests Cases in relation to their Trigger, so UUID Generation and the creation of 'I am done' cases |
| ContactGeolocationHelperTest | Tests the Web Callout specifically, a positive and negative scenario. Also tests when a Contact's Address has not been set |
| GeolocationCalloutMock | The HttpCalloutMock to test Google's Geocoding API Web Callout |

## Final Notes
I will send an email which will ask for a change of password of you in order to enter the Salesforce Org. 
Also if we could schedule a meeting in order for me to show around how it works or just answering questions it would be great.

