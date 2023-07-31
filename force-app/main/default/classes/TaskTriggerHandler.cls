public class TaskTriggerHandler {
    
    static TaskTriggerHandler handlerInstance;
    public static TaskTriggerHandler gethandlerInstance(){
        if(handlerInstance == null){
            handlerInstance = new TaskTriggerHandler();
        }
        return handlerInstance;
    }
    
    public void onBeforeUpdate(List<Task> newTskList, Map<Id, Task> oldTskMap){
        
        List<Id> demoId = new List<Id>();
        List<Id> leadId = new List<Id>();
        for(Task tsk : newTskList){
            demoId.add(tsk.WhatId);  
            leadId.add(tsk.WhoId);
        }
        Map<Id, Demo__c> demoMap = new Map<Id, Demo__c>([SELECT Id, Lead__c, Demo_Status__c, Demo_Requirements__c, Internal_Demo_Feedback__c, Dry_run_feedback__c, Client_Demo_Feedback__c FROM Demo__c WHERE Id IN: demoId]);
        system.debug('demoMap -- ' + demoMap);
        Map<Id, Lead> LeadMap = new Map<Id, Lead>([SELECT Id, Proposal_Submitted__c, All_Mandate_fields_Filled__c, Discovery_Notes__c, Team_Members_Tagged__c, Demo_Date_Time__c, Discovery_Date_Time__c, Proposal_Submission_Date__c, Status, Proposal_Uploaded__c FROM Lead WHERE Id IN: leadId]);
        system.debug('LeadMap -- ' + LeadMap);
        
        for(Task tsk : newTskList){
            if(tsk.Status != oldTskMap.get(tsk.Id).Status && tsk.Status == 'Completed'){
                if(demoMap.containsKey(tsk.WhatId)){
                    if(tsk.Subject.containsIgnoreCase('Discovery') && demoMap.get(tsk.WhatId).Demo_Requirements__c == null){
                        tsk.addError(Constants.Discovery_Error);
                    }
                    
                    system.debug('demoMap.get(tsk.WhatId).Demo_Status__c -- ' + demoMap.get(tsk.WhatId).Demo_Status__c);
                    if(tsk.Subject.containsIgnoreCase('Internal') && demoMap.get(tsk.WhatId).Internal_Demo_Feedback__c == null){
                        tsk.addError(Constants.InternalDemo_Error);
                    }
                    
                    if(tsk.Subject.containsIgnoreCase('Dry Run') && demoMap.get(tsk.WhatId).Dry_run_feedback__c == null){
                        tsk.addError(Constants.DryRun_Error);
                    }
                    
                    if(tsk.Subject.containsIgnoreCase('Client') && demoMap.get(tsk.WhatId).Client_Demo_Feedback__c == null){
                        tsk.addError(Constants.ClientDemo_Error);
                    }
                }
                
                if(LeadMap.containsKey(tsk.whoId)){
                    if(tsk.Subject.containsIgnoreCase('Discovery') && tsk.Subject.containsIgnoreCase('Demo') && (leadMap.get(tsk.WhoId).Discovery_Date_Time__c == null || leadMap.get(tsk.WhoId).Demo_Date_Time__c == null)){
                        tsk.addError(Constants.DiscDemoDate_Error);
                    }
                    if(tsk.Subject.containsIgnoreCase('Discovery') && tsk.Subject.containsIgnoreCase('Details') && (leadMap.get(tsk.WhoId).Demo_Date_Time__c == null || leadMap.get(tsk.WhoId).Discovery_Notes__c == null || !leadMap.get(tsk.WhoId).Team_Members_Tagged__c || !leadMap.get(tsk.WhoId).All_Mandate_fields_Filled__c )){
                        tsk.addError(Constants.DiscoveryDetails_Error);
                    }
                    if(tsk.Subject.containsIgnoreCase('AE') && tsk.Subject.containsIgnoreCase('Proposal') && leadMap.get(tsk.WhoId).Proposal_Submission_Date__c == null){
                        tsk.addError(Constants.AEProposal_Error);
                    }
                    if(tsk.Subject.containsIgnoreCase('Upload') && tsk.Subject.containsIgnoreCase('Proposal') && leadMap.get(tsk.WhoId).Proposal_Uploaded__c == false){
                        tsk.addError(Constants.UploadProposal_Error);
                    }
                    if(tsk.Subject.containsIgnoreCase('Submit') && tsk.Subject.containsIgnoreCase('Proposal') && !leadMap.get(tsk.WhoId).Proposal_Submitted__c){
                        tsk.addError(Constants.SubmitProposal_Error);
                    }
                }
            }
        }
        update demoMap.values();
        
    }
}