public class ContentDocumentLinkTrigger {
    
    static ContentDocumentLinkTrigger handlerInstance;
    public static ContentDocumentLinkTrigger getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new ContentDocumentLinkTrigger();
        return handlerInstance;
    }
    
    public void onAfterInsert(List<ContentDocumentLink> cdlList) {
        try{
            Sales_Process_Configurations__c config = Sales_Process_Configurations__c.getall().values();
            system.debug('config -- ' + config);
            Set<ID> parentIds = new Set<ID>();
            Set<ID> parentId2 = new Set<ID>();
            
            for( ContentDocumentLink cdl : cdlList ) {
                ContentDocument cdDetail = getContentDoc(cdl.ContentDocumentId);
                if((cdDetail.FileExtension == 'pptx' || cdDetail.FileExtension == 'pdf' )&& cdDetail.Title.containsIgnoreCase(config.Demo_PPT_File_Name__c)){
                    parentIds.add( cdl.LinkedEntityId );    	
                }
                if((cdDetail.FileExtension == 'docx' || cdDetail.FileExtension == 'pdf' ) && cdDetail.Title.containsIgnoreCase(config.Demo_Proposal_File_Name__c)){
                    parentId2.add( cdl.LinkedEntityId );
                }
            }
            
            List<Demo__c> dmListoBeUpdated = new List<Demo__c>();
            List<Demo__c> demoList = [SELECT Id, Demo_Status__c, ( SELECT Id FROM ContentDocumentLinks LIMIT 1 ) FROM Demo__c WHERE Id IN :parentIds];
            for (Demo__c dm : demoList) {
                dm.Demo_Status__c = 'PPT Uploaded';
                dmListoBeUpdated.add(dm);
            }
            
            List<Lead> ldListoBeUpdated = new List<Lead>();
            List<Lead> leadList = [SELECT Id, Proposal_Uploaded__c, ( SELECT Id FROM ContentDocumentLinks LIMIT 1 ) FROM Lead WHERE Id IN :parentId2];
            for (Lead ld : leadList) {
                ld.Proposal_Uploaded__c = true;
                ldListoBeUpdated.add(ld);
            }
            
            system.debug('dmListoBeUpdated :: ' + dmListoBeUpdated);
            if(dmListoBeUpdated != null){
                update dmListoBeUpdated;
            }  
            if(ldListoBeUpdated != null){
                update ldListoBeUpdated;
            }  
        }
        catch (Exception e){
            system.debug('Error :: ' + e.getMessage() + 'At Line Number :: ' + e.getLineNumber());
        }
    }
    
    public ContentDocument getContentDoc(Id cdId) {
        return [SELECT Id, FileExtension, Title FROM ContentDocument WHERE Id=: cdId];
    }
}