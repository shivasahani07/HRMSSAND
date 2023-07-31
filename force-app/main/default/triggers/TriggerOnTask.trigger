trigger TriggerOnTask on Task (after update) {
    
    NewsObjectTriggerControl__c triggerConfig = NewsObjectTriggerControl__c.getValues('Task');
    if(triggerConfig != null && triggerConfig.Status__c){
        TaskTriggerHandler handlerInstance = TaskTriggerHandler.gethandlerInstance();    
        if(Trigger.isAfter && Trigger.isUpdate){
            handlerInstance.onBeforeUpdate(Trigger.New, Trigger.OldMap);
        }
    }
}