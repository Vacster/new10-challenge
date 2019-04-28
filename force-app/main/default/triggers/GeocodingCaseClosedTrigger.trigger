trigger GeocodingCaseClosedTrigger on Geocoding_Case_Closed__e (after insert) {

    GeocodingCaseClosedTriggerHandler handler = new GeocodingCaseClosedTriggerHandler();

    if (Trigger.isInsert && Trigger.isAfter) {
        handler.onAfterInsert(Trigger.new);
    }

}