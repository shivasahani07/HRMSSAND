public without sharing class PE_ParentComponentHelper {
    
    @AuraEnabled
    Public static Summary__c getCurrentUserSummary(){
        Summary__c sumRec = [SELECT Id, Active__c, PE_Intervals__c, Status__c, User__c, ApprovalStatus__c FROM Summary__c WHERE User__c =: UserInfo.getUserId() LIMIT 1];
        system.debug('sumRec -- ' + sumRec);
        return sumRec;
    }
    
    @AuraEnabled
    Public static string initiateSummary(){
        List<PE_Intervals__c> peIntervalList = [SELECT Id, Name, Start_Date__c, End_Date__c FROM PE_Intervals__c WHERE CALENDAR_YEAR(Start_Date__c) = : Date.Today().year() LIMIT 1];
        system.debug('peIntervalList -- ' + peIntervalList);
        Summary__c newSum = new Summary__c();
        newSum.Active__c = true;
        newSum.Name = UserInfo.getFirstName() + ' ' + peIntervalList[0].Name;
        newSum.PE_Intervals__c = peIntervalList[0].Id;
        newSum.User__c = UserInfo.getUserId();
        newSum.Status__c = 'Requested';
        insert newSum;
        return newSum.Id;
    }
    
    @AuraEnabled
    public static List < PE_Intervals__c > getIntervalDetailsSFDC() {
        List < PE_Intervals__c > intervalList = new List < PE_Intervals__c > ([SELECT ID, Name, Close_Date__c, End_Date__c, No_Of_Reminders__c, Notification_Date__c, Start_Date__c,Active__c FROM PE_Intervals__c ORDER BY Start_Date__c DESC]);
        return intervalList;
    }
    
}