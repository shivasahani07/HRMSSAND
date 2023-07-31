trigger MonthlyLineItemTrigger on Time_Entry_Monthly_Card__c (after update) {
    
    if(trigger.isAfter && trigger.isUpdate){
        // MonthlyLineItemTriggerHelper.getDataFromJira(Trigger.new);    
    }

}