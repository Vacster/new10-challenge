trigger ContactTrigger on Contact (after update) {

    ContactTriggerHandler handler = new ContactTriggerHandler();

    if (Trigger.isAfter && Trigger.isUpdate) {
        handler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }

}