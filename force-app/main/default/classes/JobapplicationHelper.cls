public class JobapplicationHelper {

    @AuraEnabled(cacheable=true)
    public static  List<Application__c> getJobApplications(String recordId){
        System.debug('recordId--'+recordId);
        List<Application__c> Applications =[SELECT ID,Origin__c,Contact__c,mandate_company_name__c,Last_Working_Day__c,Mandate_Start_Date__c,Name,Mandate__c,Status_Summary_Line__c,Contact__r.Name,Contact__r.Phone,
                                            Contact__r.Email,Contact__r.LinkedIn_URL__c,Contact__r.Contact_Role__c FROM Application__c  where Last_Working_Day__c != null Limit 5];

        System.debug('Applications--'+Applications);
        return Applications;
    }

    @AuraEnabled(cacheable=true)
    public static  List<Application__c> getJobApplicationsFinsl(String recordId){
        System.debug('recordId--'+recordId);
        List<Application__c> Applications =[SELECT ID,Origin__c,Contact__c,mandate_company_name__c,Last_Working_Day__c,Mandate_Start_Date__c,Name,Mandate__c,Status_Summary_Line__c,Contact__r.Name,Contact__r.Phone,
                                            Contact__r.Email,Contact__r.LinkedIn_URL__c,Contact__r.Contact_Role__c FROM Application__c where Last_Working_Day__c != null Limit 5];

        System.debug('Applications--'+Applications);
        return Applications;
    } 
    
    @AuraEnabled(cacheable=true)
    public static  List<Application__c> getJobApplicationsInterViewing(String recordId){
        System.debug('recordId--'+recordId);
        List<Application__c> Applications =[SELECT ID,Origin__c,Contact__c,mandate_company_name__c,Last_Working_Day__c,Mandate_Start_Date__c,Name,Mandate__c,Status_Summary_Line__c,Contact__r.Name,Contact__r.Phone,
                                            Contact__r.Email,Contact__r.LinkedIn_URL__c,Contact__r.Contact_Role__c FROM Application__c where Last_Working_Day__c != null Limit 5] ;

        System.debug('Applications--'+Applications);
        return Applications;
    }

}