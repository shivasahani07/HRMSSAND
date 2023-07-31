public without sharing class NeedAmendmentHelper {
    
    @AuraEnabled
    public static DmoTskwrapper getDataDemo(string recordId) {
        try{
            DmoTskwrapper dtWrapper = new DmoTskwrapper();
            Task tk= [SELECT id, WhatId, Subject, Status, OwnerId, ActivityDate FROM Task WHERE id=:recordId AND WhatId !=null AND  WhatId IN (SELECT Id FROM Demo__c) LIMIT 1];
            dtWrapper.tsk = tk;
            Demo__c demo = [Select Id,Internal_Demo_Date_Time__c, Internal_Demo_Feedback__c, Dry_Run_Date_Time__c, Dry_run_feedback__c, Demo_Date_Time__c, Client_Demo_Feedback__c from Demo__c where Id=:tk.WhatId ];
            dtWrapper.dmo = demo;
            system.debug('dtWrapper -- ' + dtWrapper);
            return dtWrapper;  
        }
        catch(Exception e){
            system.debug('Error in Updation -- ' + e.getMessage() + 'At Line No -- ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string updateDemo(Demo__c demo, string recid){
        try{
            update demo;
            Task tsk = new Task(Id = recid, status = 'Need Amendment', isClickable__c = false);
            update tsk;
            return 'SUCCESS';
        }
        catch(Exception e){
            system.debug('Error in Updation -- ' + e.getMessage() + 'At Line No -- ' + e.getLineNumber());
            return e.getMessage();
        }
    }
    
    public class DmoTskwrapper{
        @AuraEnabled
        public Demo__c dmo{get;set;}
        @AuraEnabled
        public Task tsk{get;set;}
    }
}