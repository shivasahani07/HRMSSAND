global class batchClassForExtendingTask implements Database.Batchable<sObject>
{		date Todadate=system.today();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {	
        
        String query = 'SELECT Id,Name,Estimated_Start_Date__c,Task_End_Date__c,Task_Start_Date__c FROM Jira_Task__c where Estimated_Start_Date__c =: Todadate AND Task_End_Date__c=null AND Task_Start_Date__c =null';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Jira_Task__c> scope)
    {
        for(Jira_Task__c a : scope)
        {
            a.Estimated_Start_Date__c = a.Estimated_Start_Date__c.addDays(1);
            system.debug('scope='+a.Estimated_Start_Date__c);
        }
        //system.debug('scope='+a.Estimated_Start_Date__c);
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
    }
}

//Task_End_Date__c
//Task_Start_Date__c