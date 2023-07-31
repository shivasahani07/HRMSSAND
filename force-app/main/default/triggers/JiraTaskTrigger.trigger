trigger JiraTaskTrigger on Jira_Task__c (after update,after insert,before insert,before update) {
    
    if(trigger.isAfter && trigger.isUpdate){
        JiraTaskTriggerHelper.updateDailyLineItems(Trigger.newMap,Trigger.oldmap);
    }
    if(trigger.isAfter && trigger.isInsert){
        JiraTaskTriggerHelper.updatePRM(Trigger.newMap,Trigger.oldmap);
        //updateModuleOnJiraTask.checkjtConflictTiming(Trigger.new);
    }
    if(trigger.isBefore && trigger.isInsert){
        JiraTaskTriggerHelper.updateDailyTasks(Trigger.new);
        updateModuleOnJiraTask.preventPrevioudDate(Trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
       // JiraTaskTriggerHelper.updateDailyTasks(Trigger.new);
    }
    
   
     if(trigger.isInsert && trigger.isAfter){
        updateModuleOnJiraTask.StartModule(Trigger.oldMap, Trigger.newMap);
        updateModuleOnJiraTask.totalEstimatedValueOnModule(Trigger.new);
    }
    
   
   
}