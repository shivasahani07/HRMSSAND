public class PE_GotoHomeController {
    @AuraEnabled
    public static PE_Intervals__c getinterval(string intervalId){
        PE_Intervals__c activeInterval = [SELECT Id, Name, Close_Date__c, End_Date__c, No_Of_Reminders__c, Notification_Date__c, Start_Date__c FROM PE_Intervals__c where Id =: intervalId limit 1];  
        return activeInterval;
    }
    
    @AuraEnabled
    public static wrapperClass getFeedback(string intervalId){
        Set<Id> sendFeedbackIds = new  Set<Id>(); 
        Set<Id> submittedFeedbackIds = new  Set<Id>(); 
        Set<Id> pendingFeedbackIds = new  Set<Id>(); 
        try{
            List <PE_Intervals__c> activeInterval = new  List <PE_Intervals__c>();
            Summary__c userSummary = new  Summary__c();
            
            activeInterval =[Select id,Name from PE_Intervals__c where Id =: intervalId limit 1 ];
            System.debug('activeInterval'+activeInterval);
            if( activeInterval.size()>0){
                userSummary = [SELECT ID,Status__c FROM Summary__c where Active__c =: true AND User__c =: UserInfo.getUserId() AND PE_Intervals__c =:activeInterval[0].id  limit 1];
                //         System.debug('userSummary'+userSummary);
            }
            if( userSummary != null){
                List<PE_Feedback_New__c> feedbackList = [SELECT Id,Peers_ID__c,User__c,Status__c from PE_Feedback_New__c where PE_Summary__c =:userSummary.id  AND User__c =: UserInfo.getUserId()];	
                //  System.debug('activeInterval'+activeInterval);	
                
                //System.debug('feedbackListttttt'+feedbackList);
                for(PE_Feedback_New__c feedObj : feedbackList){
                    if(feedObj.Status__c =='Open' || feedObj.Status__c == 'In Draft'){
                        pendingFeedbackIds.add(feedObj.Id);
                    }/*else if(feedObj.Status__c =='Submitted'){
submittedFeedbackIds.add(feedObj.Id);
}*/else if(feedObj.Status__c =='Submitted'){
    submittedFeedbackIds.add(feedObj.Id);
}
                    sendFeedbackIds.add(feedObj.Id);
                }
            }
            wrapperClass wrapperclassObj = new  wrapperClass ();        
            wrapperclassObj.allCount = sendFeedbackIds.size(); 
            wrapperclassObj.submittedCount = submittedFeedbackIds.size(); 
            wrapperclassObj.pendingCount = pendingFeedbackIds.size();
            
            return wrapperclassObj;  
        }catch(Exception e){
            //     System.debug(e.getLineNumber());
            //    System.debug(e.getMessage());
            return null;
        }  
    }
    
    
    
    public class wrapperClass{
        @AuraEnabled public Integer allCount{get;set;}
        @AuraEnabled public Integer submittedCount{get;set;}
        @AuraEnabled public Integer pendingCount {get;set;}
    }
    
}