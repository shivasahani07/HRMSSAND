trigger TriggerOnDemo on Demo__c (before update) {
    
    NewsObjectTriggerControl__c triggerConfig = NewsObjectTriggerControl__c.getValues('Demo');
    if(triggerConfig != null && triggerConfig.Status__c) {
        DemoTriggerHandler handlerInstance = DemoTriggerHandler.getInstance();
        if(Trigger.isBefore && Trigger.isUpdate) {
            handlerInstance.onBeforeUpdate(Trigger.New, trigger.oldMap);
        }
    }
    
}