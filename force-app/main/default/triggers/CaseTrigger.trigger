trigger CaseTrigger on Case (before insert) {

    CaseTriggerHandler handler = new CaseTriggerHandler();

    if (Trigger.isInsert && Trigger.isBefore) {
        handler.onBeforeInsert(Trigger.new);
    }
    
}