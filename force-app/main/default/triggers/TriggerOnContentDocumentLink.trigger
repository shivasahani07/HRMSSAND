trigger TriggerOnContentDocumentLink on ContentDocumentLink (after insert) {
    
    NewsObjectTriggerControl__c triggerConfig = NewsObjectTriggerControl__c.getValues('CDL');
    if(triggerConfig != null && triggerConfig.Status__c) {
        ContentDocumentLinkTrigger handlerInstance = ContentDocumentLinkTrigger.getInstance();
        if(Trigger.isAfter && Trigger.isInsert) {
            handlerInstance.onAfterInsert(Trigger.New);
        }
    }
}