/**
 * The handler for the Case's trigger
 */
public with sharing class CaseTriggerHandler {

    /**
     * Called on a before insert trigger for a Case.
     * In a real environment this would probably further call another handler
     * instead of doing some logic (even if it's very little).
     * @param  cases The list of cases from Trigger.new
     */
    public void onBeforeInsert(List<Case> cases) {
        for (Case currentCase : cases) {
            String guid = UUIDHelper.generateUUID();
            currentCase.External_Id__c = guid;
        }
    }

    /**
     * Called on after update trigger for a Case.
     * In a real environment this would probably further call another handler
     * instead of doing some logic.
     * @param  oldCases The Case map from Trigger.oldMap
     * @param  newCases The Case map from Trigger.newMap
     */
    public void onAfterUpdate(Map<Id, Case> oldCases, Map<Id, Case> newCases) {
        List<Geocoding_Case_Closed__e> events = new List<Geocoding_Case_Closed__e>();
        for (Case currentCase : newCases.values()) {
            if (currentCase.Subject == 'Check Geocoding Data') {

                //If the Case has just been closed
                if (currentCase.isClosed && !oldCases.get(currentCase.Id).isClosed) {
                    Geocoding_Case_Closed__e event = new Geocoding_Case_Closed__e (
                        External_Id__c = currentCase.External_Id__c
                    );
                    events.add(event);
                }
            }
        }

        /** 
         * Success checking and reporting can be handled here but 
         * it's outsie the scope of this challenge
         */
        List<Database.SaveResult> results = EventBus.publish(events);
    }

}
