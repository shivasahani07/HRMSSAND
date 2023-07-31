public class DemoTriggerHandler {
    static DemoTriggerHandler handlerInstance;
    public static DemoTriggerHandler getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new DemoTriggerHandler();
        return handlerInstance;
    }
    
    public void onBeforeUpdate(List<Demo__c> newDemoList, map<id, Demo__c> oldDemoMap) {
        system.debug('newDemoList :: ' + newDemoList);
        system.debug('oldDemoMap :: ' + oldDemoMap);
        try{
            Set<Id> dryRunDemoIdSet = new Set<Id>();
            Set<Id> internalDemoIdSet = new Set<Id>();
            for(Demo__c demo : newDemoList){
                if(demo.Dry_Run_Date_Time__c != oldDemoMap.get(demo.Id).Dry_Run_Date_Time__c && demo.Dry_Run_Date_Time__c != null){
                    dryRunDemoIdSet.add(demo.Id);  
                }
                if(demo.Internal_Demo_Date_Time__c != oldDemoMap.get(demo.Id).Internal_Demo_Date_Time__c && demo.Internal_Demo_Date_Time__c != null){
                    internalDemoIdSet.add(demo.Id);
                }
            }
            if(dryRunDemoIdSet != null){
                List<Demo__c> dryRunDemoList = [SELECT Id, Name, Dry_Run_Date_Time__c, Dry_Run_Tasks_Count__c, Lead__r.Name, Lead__r.Salesforce_AE__c, Lead__r.Salesforce_AE__r.Email FROM Demo__c WHERE Id IN: dryRunDemoIdSet AND Lead__c != null AND Lead__r.Salesforce_AE__r.Email != null];
                system.debug('dryRunDemoList :: ' + dryRunDemoList );
                
                for(Demo__c demo : dryRunDemoList){
                    system.debug('I am calling future method');
                    dryRunCllOutMthd(demo.Id);                
                }
            }
            
            if(internalDemoIdSet != null){
                List<Demo__c> internalDemoList = [SELECT Id, Name, Internal_Demo_Date_Time__c, Internal_Tasks_Count__c FROM Demo__c WHERE Id IN: internalDemoIdSet];
                system.debug('internalDemoList :: ' + internalDemoList );
                
                for(Demo__c demo : internalDemoList){
                    system.debug('I am calling future method');
                    internalCllOutMthd(demo.Id);                
                }
            }
            
        }
        catch (Exception e){
            system.debug('Error Before Update -- ' + e.getMessage() + 'At Line Number :: ' + e.getLineNumber());
        }
    }
    
    @future(callout=true)
    public static void dryRunCllOutMthd(Id demoId){
        try{
            string sDate = '';
            string eDate = '';
            
            List<Event> eventList = new List<Event>();
            
            Demo__c demoRec =[SELECT Id, Name, Dry_Run_Date_Time__c, Dry_Run_Tasks_Count__c, Lead__r.Name, Lead__r.Salesforce_AE__c, Lead__r.Salesforce_AE__r.Email, Lead__r.Salesforce_AE__r.FirstName
                              FROM Demo__c WHERE Id =: demoId AND Lead__c != null AND Lead__r.Salesforce_AE__r.Email != null]; 
            
            sDate = string.valueOf(demoRec.Dry_Run_Date_Time__c);
            eDate = string.valueOf(demoRec.Dry_Run_Date_Time__c);
            
            String body = 'Hi ' + demoRec.Lead__r.Salesforce_AE__r.FirstName + ',';
            body+= '<br> <br> Greetings. Our demo team has completed the demo of ' + demoRec.Name;
            body+='.<br>We would love to connect with you for half an hour on ' + demoRec.Dry_Run_Date_Time__c +  ' to give you a dry run of readied demo.';
            body+='<br> Please let us know your availability.';
            body+='<br> <br> Thanks and Regards,';
            body+='<br> UtilitarianLabs Pvt. Ltd.';
            
            String subject = 'Dry Run' ;
            if(demoRec.Dry_Run_Tasks_Count__c > 1){
                subject+= ' - Amendment Required';
            }   
            
            String eventLink = OutlookIntegration_New.GenerateEventLink(demoRec.Lead__r.Salesforce_AE__r.FirstName, demoRec.Lead__r.Salesforce_AE__r.Email, subject, body, sDate, eDate);
            
            /*Event e = new Event();
            e.StartDateTime = DateTime.valueOf(sDate.replace('T',' '));
            e.EndDateTime = DateTime.valueOf(eDate.replace('T',' '));
            e.Meeting_URL__c = eventLink;
            e.WhoId = demoRec.Lead__c;
            e.OwnerId = UserInfo.getUserId();
            e.Subject = 'Dry Run with Executive';
            e.IsReminderSet = true;
            eventList.add(e);        
            insert e;*/
        }
        catch (Exception e){
            system.debug('Error dryRunCllOutMthd -- ' + e.getMessage() + 'At Line Number :: ' + e.getLineNumber());
        }
    }
    
    @future(callout=true)
    public static void internalCllOutMthd(Id demoId){
        try{
            system.debug('I am being called');
            string sDate = '';
            string eDate = '';
            
            List<Event> eventList = new List<Event>();
            List<Demo_Team__c> demoTeamList = [SELECT Id, Name, Demo__c, Demo__r.Name, Demo__r.Internal_Demo_Date_Time__c, Demo__r.Internal_Tasks_Count__c, Resources__c, Resources__r.Email, Resources__r.FirstName FROM Demo_Team__c WHERE Demo__c =: demoId AND Resources__r.Email != null]; 
            for(Demo_Team__c demoTeamRec : demoTeamList){
                sDate = string.valueOf(demoTeamRec.Demo__r.Internal_Demo_Date_Time__c);
                eDate = string.valueOf(demoTeamRec.Demo__r.Internal_Demo_Date_Time__c);
                String body = 'Hi ' + demoTeamRec.Resources__r.FirstName + ',';
                body+= '<br> <br> Greetings. I hope you would have been doing fine.';
                body += ' <br> <br>I am delighted to inform that we have a new prospect in form of "' + demoTeamRec.Demo__r.Name + '" and you are assigned for the same.';
                body+='<br> Just wanted to remind you that the Internal demo date for "' + demoTeamRec.Demo__r.Name + '" demo is on "' +  demoTeamRec.Demo__r.Internal_Demo_Date_Time__c + '".';
                body+='<br> Join the below link on the specified date.';
                body+='<br> <br> Thanks and Regards,';
                body+='<br> UtilitarianLabs Pvt. Ltd.';
                
                String subject = 'Internal Demo' ;
                if(demoTeamRec.Demo__r.Internal_Tasks_Count__c > 1){
                    subject+= ' - Amendment Required';
                }   
                String eventLink = OutlookIntegration_New.GenerateEventLink(demoTeamRec.Name, demoTeamRec.Resources__r.Email, subject, body, sDate, eDate);
                
                /*Event e = new Event();
                e.StartDateTime = DateTime.valueOf(sDate.replace('T',' '));
                e.EndDateTime = DateTime.valueOf(eDate.replace('T',' '));
                e.Meeting_URL__c = eventLink;
                e.whatId = demoTeamRec.Id;
                e.OwnerId = UserInfo.getUserId();
                e.Subject = 'Internal Demo';
                e.IsReminderSet = true;
                eventList.add(e);   */
            }
            /*if(!eventList.isEmpty()){
                insert eventList;
            }  */          
        }
        catch (Exception e){
            system.debug('Error cllOutMthd -: ' + e.getMessage() + 'At Line Number :: ' + e.getLineNumber());
        }
    }
    
}