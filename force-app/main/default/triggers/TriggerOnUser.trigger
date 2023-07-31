trigger TriggerOnUser on User (after insert,after update) {
    UserTriggerHandler userTriggerHelperInstance = UserTriggerHandler.getInstance();
    
    if(Trigger.isInsert && Trigger.isAfter){
        //userTriggerHelperInstance.afterInsert(Trigger.newMap);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        // userTriggerHelperInstance.afterUpdate(Trigger.oldMap, Trigger.newMap);
    }
    
}