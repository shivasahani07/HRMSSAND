public class SimilarAccountHelper {
    @AuraEnabled
    public static List<Account>  getAccounts( string recordId){
        system.debug('recordId==>'+recordId);
        List<Account> accountListWithSameCIN = new List<Account>();
        try{
            if(recordId != null){
                Account accRecord= [Select id,CIN_Registration_No__c from Account where id=:recordId];
                if(accRecord.CIN_Registration_No__c !=null){
                    accountListWithSameCIN = [Select Id,Name,Phone,Stage__c From Account where CIN_Registration_No__c = : accRecord.CIN_Registration_No__c and Id !=:  recordId];
                    return accountListWithSameCIN;
                }                
                else{
                    return null;
                }
            }   
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }  
        return null;
    }
}