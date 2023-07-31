global without sharing class CandidateOnboardingHomeHelper {

    //THIS METHODS WILL RETURN USER CONTACT DATA
    @AuraEnabled(cacheable=true)
    public static contact getUserdata(String recordId){
        contact getCondata=[SELECT Id,Name,email,Password__c,Login_Hash_Code__c FROM contact WHERE id =:recordId];
        return getCondata;

    }

}