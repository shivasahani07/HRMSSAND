public class CreateInvoiceFromMilestoneHelper {
    @AuraEnabled
    public static Milestone__c getMilestoneData(string recordId){
        system.debug('recordId---->'+recordId);
        List<Milestone__c> milestoneRecordList = [SELECT Account__c,CreatedById,CreatedDate,Id,IsDeleted,Is_Collected__c,Milestone_Weightage_Rs__c,Milestone_Weightage__c,Name,Name__c,
                                                  Tentative_Date_of_Payment__c,Tentative_Month_of_Payment__c FROM Milestone__c WHERE Id =:recordId];
        system.debug('milestoneRecordList---->'+milestoneRecordList);
        return milestoneRecordList[0];
    }
    @AuraEnabled
    public static void saveInvoiceRecord(Invoice__c invoiceRecord){
        try{
            insert invoiceRecord;
        }catch(exception ex){
            system.debug('Error-->'+ex.getMessage());
            system.debug('Error at line --->'+ex.getLineNumber());
        }
    }
    
}