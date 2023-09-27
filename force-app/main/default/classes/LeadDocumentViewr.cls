global without sharing class LeadDocumentViewr {
    public String blobData {
        get {
            try{
                return EncodingUtil.Base64Encode(docWrapperInstance.blobFile);
            }catch(Exception e){
                return '';
            }
            
        }
    }
    public docWrapper docWrapperInstance{get;set;}
    public LeadDocumentViewr() {
        viewPDF();
    }
    
    @RemoteAction
    global static List<DocumentTreeWrapper> getDocuments(String oppId) {
        //oppId = '0060w00000BqhJQAAZ';
        if(String.isBlank(oppId))
            return null;
        Map<Id,DocumentTreeWrapper> uiWrapper = new Map<Id,DocumentTreeWrapper>();
        List<Document_Template__c> docList=  [Select id,Name from Document_Template__c where Lead__c =:oppId];
        String Obj = '';
        if(docList.size() > 0){
            for(Document_Template__c appDoc : [SELECT Id, Name,(SELECT Id, Name FROM Documents_Attachments__r) FROM Document_Template__c WHERE Lead__c =:oppId ORDER BY CreatedDate]) {
                //Handle First level cat Here
                DocumentTreeWrapper appDocWrapper;
                
                appDocWrapper = new DocumentTreeWrapper(appDoc.Id, appDoc.Name); 
                if(!appDoc.Documents_Attachments__r.isEmpty()){
                    for(Documents_Attachment__c appAttachment : appDoc.Documents_Attachments__r) {
                        appDocWrapper.childNodes.add(new DocumentTreeWrapper(appAttachment.Id, appAttachment.Name));
                    }
                }
                uiWrapper.put(appDoc.Id, appDocWrapper);
            }
        }
        system.debug('uiWrapper'+uiWrapper);
        return uiWrapper.values();
    }
    
    public void viewPDF(){
        String appDocId = Apexpages.currentPage().getParameters().get('attachId');
        system.debug('para::'+appDocId);
        docWrapperInstance = new docWrapper();
        Documents_Attachment__c appDocAttach = new Documents_Attachment__c();
        if(appDocId != null){
            appDocAttach = [SELECT id,Name,Attachement_Id__c FROM Documents_Attachment__c WHERE id =: appDocId];
            if(appDocAttach != null && appDocAttach.Attachement_Id__c != null){
                try{
                    system.debug('appDocAttach.Attachement_Id__c'+appDocAttach.Attachement_Id__c);
                    Attachment att = [select id,name,body,contenttype  from attachment where id =: appDocAttach.Attachement_Id__c limit 1];
                    //if(att.contenttype !=null){
                    docWrapperInstance.contentType = att.contenttype;
                    docWrapperInstance.blobFile = att.body;
                    //}
                }catch(Exception e){
                    System.debug('e.getmshg'+e.getMessage());
                }
            }
        }else{
            //System.debug('e.getmshg'+e.getMessage());
            docWrapperInstance = new docWrapper();
            docWrapperInstance.contentType = 'application/';
            docWrapperInstance.blobFile = blob.valueOf('');
        }
    }
    
    @RemoteAction
    global static void deleteDoc(string selectedAttId){
        system.debug('attachId---'+selectedAttId);
        //String appDocId = Apexpages.currentPage().getParameters().get('attachId');
        system.debug('attachId---'+selectedAttId);
        Documents_Attachment__c appDocAttach = new Documents_Attachment__c();
        if(selectedAttId != null){
            appDocAttach = [SELECT id,Name,Attachement_Id__c FROM Documents_Attachment__c WHERE id =: selectedAttId];
            
        }
        delete appDocAttach;
    }
    
    
    global class DocumentTreeWrapper {
        public String documentID;
        public String documentName;
        public List<DocumentTreeWrapper> childNodes = new List<DocumentTreeWrapper>();
        
        public DocumentTreeWrapper(String documentID, String documentName) {
            this.documentID = documentID;
            this.documentName = documentName;
        }
    }
    
    global class docWrapper{
        public String contentType{get;set;}
        public blob blobFile{get;set;}
    }
    
    
    //THIS METHOD WILL BE USED TO CREATE DOCS CATEGORY UNDER LEADS
    Public Static void createDocscategoryforLlead(List<lead> newLeads){
        List<Document_Template__c> TemplatesToBeInserted = new List<Document_Template__c>();
        List<LeadsDocCategory__mdt> LeadsDocCategoryList =[SELECT id,DocsLabel__c	FROM LeadsDocCategory__mdt];
        for(lead ld:newLeads){
            for(LeadsDocCategory__mdt  docName:LeadsDocCategoryList){
                Document_Template__c dtRec = new Document_Template__c();
                dtRec.Name = docName.DocsLabel__c;
                dtRec.Lead__c = ld.Id;
                TemplatesToBeInserted.add(dtRec); 
            }
        }
        if(TemplatesToBeInserted.size() > 0){
            insert TemplatesToBeInserted;
        }
    }
    
    
}