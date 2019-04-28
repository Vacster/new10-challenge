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

}
