public class CustompathHelper {


    @AuraEnabled(cacheable=true)
    Public static Mandate__c  getJobReqrecord(string recordId){
         System.debug('recordId'+recordId);
        Mandate__c jobReq =[SELECT Id,Name,Approval_Status__c FROM Mandate__c WHERE id =:recordId LIMIT 1];
        System.debug('jobReq'+jobReq);
        return jobReq;
    }

}