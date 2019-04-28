public with sharing class GeocodingCaseClosedTriggerHandler {

    /**
     * Creates new Cases with the subject 'I am done' for every
     * case specified in the Platform Event messages
     * @param  casesEvents The list of messages from the Platform Event
     */
    public void onAfterInsert(List<Geocoding_Case_Closed__e> casesEvents) {
        Set<String> externalIds = new Set<String>();

        for (Geocoding_Case_Closed__e message : casesEvents) {
            externalIds.add(message.External_Id__c);
        }
        
        List<Case> closedCases = [SELECT Id 
                                    FROM Case
                                    WHERE External_Id__c IN :externalIds];

        List<Case> newCases = new List<Case>();
        for (Case currentCase : closedCases) {
            /**
             * The owner of the case would be 'Automated Process'.
             * A user could be defined as the owner, either by querying
             * or setting it the same as the last one but I'm leaving it 
             * like this for simplicity's sake as it's not too relevant
             * to the challenge.
             */
            Case c = new Case(
                Subject = 'I am done',
                ParentId = currentCase.Id
            );
            newCases.add(c);
        }
        
        if (newCases.size() > 0) {
            insert newCases;
        }
    }

}
