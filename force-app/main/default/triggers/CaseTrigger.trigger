trigger CaseTrigger on Case (before insert, after update) {

    CaseTriggerHandler handler = new CaseTriggerHandler();

    if (Trigger.isInsert && Trigger.isBefore) {
        handler.onBeforeInsert(Trigger.new);
    }
    
    if (Trigger.isUpdate && Trigger.isAfter) {
        handler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }

}