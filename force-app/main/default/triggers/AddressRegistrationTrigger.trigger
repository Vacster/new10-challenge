trigger AddressRegistrationTrigger on Address_Registration__e (after insert) {

    AddressRegistrationTriggerHandler handler = new AddressRegistrationTriggerHandler();

    if (Trigger.isInsert && Trigger.isAfter) {
        handler.onAfterInsert(Trigger.new);
    }
}