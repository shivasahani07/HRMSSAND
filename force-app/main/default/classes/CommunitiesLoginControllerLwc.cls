global without sharing class CommunitiesLoginControllerLwc {
    
    @AuraEnabled
    public static String performLogout(String hashCode) {
        CommunitiesLoginController controller = new CommunitiesLoginController();
        controller.performLogout(hashCode);
        return 'SUCCESS';
    }
    
    
    @AuraEnabled(cacheable=true)
    public static ResponseBody getUserdata(String recordId){
        contact getCondata=[SELECT Id,Name,email,Password__c,Login_Hash_Code__c FROM contact WHERE Login_Hash_Code__c =:recordId];
        ResponseBody collectdata = new ResponseBody();
        collectdata.conrecord=getCondata;
        collectdata.piclistValues= AllPiclistvalues.getAllPicklistsValues('Mandate__c');
        system.debug('collectdata----------------->'+collectdata);
        return collectdata;
        
    }
    
    @AuraEnabled
    Public static void updateContact(contact updatConact){
        system.debug('updatConact----------------->'+updatConact);
        update updatConact;
        
    }
    // this class will return data on lwc wire
    public class ResponseBody {
        @AuraEnabled 
        public contact conrecord {get; set;}
        @AuraEnabled 
        public List<string> piclistValues {get; set;}
        
    }
}