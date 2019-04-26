public with sharing class CaseTriggerHandler {

    public void onBeforeInsert(List<Case> cases) {
        for (Case currentCase : cases) {
            String guid = UUIDHelper.generateUUID();
            currentCase.External_Id__c = guid;
        }
    }

}
