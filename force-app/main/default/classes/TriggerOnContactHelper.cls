public class TriggerOnContactHelper {
    public static void DocCategoriesMgt(List<Contact> conList){
        
        List<Document_Template__c> TemplatesToBeInserted = new List<Document_Template__c>();
        List<String> DocTemplatesName = new List<String>();
        //now its coming from custom metadata
        DocTemplatesName.add('Resume');
        DocTemplatesName.add('Cover Letter');
        DocTemplatesName.add('References');
        DocTemplatesName.add('Identification and Personal Documents');
        DocTemplatesName.add('Educational Documents');
        DocTemplatesName.add('Employment Documents');
        DocTemplatesName.add('Work Authorization');
        DocTemplatesName.add('Tax and Payroll Forms');
        DocTemplatesName.add('Health and Benefits Forms');
        DocTemplatesName.add('Background Check and Screening Documents');
        DocTemplatesName.add('Company Policies and Handbook Acknowledgment');
        DocTemplatesName.add('Training and Orientation Materials');
        DocTemplatesName.add('Uniform or Dress Code Information');
        DocTemplatesName.add('Other Role-Specific Documents');
        
        List<ContactDocsCategory__mdt> DocCategoryForCandidate=[SELECT id,Document_Lable__c	FROM ContactDocsCategory__mdt];
        
        for(Contact con  : conList){
            //if(con.recordType.Name=='Candidate'){
                for(ContactDocsCategory__mdt docName: DocCategoryForCandidate){
                    Document_Template__c dtRec = new Document_Template__c();
                    dtRec.Name = docName.Document_Lable__c;
                    dtRec.Candidate__c = con.Id;
                    TemplatesToBeInserted.add(dtRec);
                } 
            //}
            
        }
        if(TemplatesToBeInserted.size() > 0){
            insert TemplatesToBeInserted;
        }
    }
}