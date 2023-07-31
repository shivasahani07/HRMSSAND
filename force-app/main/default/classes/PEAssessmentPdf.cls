public class PEAssessmentPdf {
    @AuraEnabled(cacheable=true)
    public static List<PE_Intervals__c> getPEIntervals() {
        return [SELECT Id, Name FROM PE_Intervals__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Summary__c> getChildSummaryData(Id intervalId) {
        List<Summary__c> summaries = [SELECT Id, Name, User__c, User__r.Name, User__r.Email
                                      FROM Summary__c
                                      WHERE PE_Intervals__c = :intervalId];
        return summaries;
    }

    @AuraEnabled(cacheable=true)
    public static User getUserDetails(Id userId) {
        User userDetails = [SELECT Id, Manager.Name, Manager.Email
                            FROM User
                            WHERE Id = :userId];
        return userDetails;
    }

    @AuraEnabled(cacheable=true)
    public static User getHREmail(Id userId) {
        User hrDetails = [SELECT Id, Email
                          FROM User
                          WHERE Profile.Name = 'HR'
                          LIMIT 1];
        return hrDetails;
    }
}