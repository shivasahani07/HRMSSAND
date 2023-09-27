public class JobRequestion_Trigger_Helper {

    /*
    public static void DocCategoriesMgt(List<Mandate__c> mandateList){
        
        List<Document_Template__c> TemplatesToBeInserted = new List<Document_Template__c>();
        List<String> DocTemplatesName = new List<String>();
        
        //Custom setting
        DocTemplatesName.add('Employee Profile');
        DocTemplatesName.add('Executive Summary');
        DocTemplatesName.add('Job Description');
        DocTemplatesName.add('Research Strategy');
                
        for(Mandate__c manRec  : mandateList ){
            
            for(String docName : DocTemplatesName){
                Document_Template__c dtRec = new Document_Template__c();
                dtRec.Name = docName;
                dtRec.Job_Requisition__c = manRec.Id;
                TemplatesToBeInserted.add(dtRec);
            }
            
        }
        if(TemplatesToBeInserted.size() > 0){
            insert TemplatesToBeInserted;
        }
    }*/
    
}