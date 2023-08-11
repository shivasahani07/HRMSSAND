public class TriggerOnContactHelper {
    public static void DocCategoriesMgt(List<Contact> conList){
        
        List<Document_Template__c> TemplatesToBeInserted = new List<Document_Template__c>();
        List<String> DocTemplatesName = new List<String>();
        //DocTemplatesName.add('Resume');
        //DocTemplatesName.add('Cover Letter');
        //DocTemplatesName.add('References');
        DocTemplatesName.add('Academic');
        DocTemplatesName.add('Certifications and Licenses');
        DocTemplatesName.add('Identification Documents');
        
        for(Contact con  : conList){
            for(String docName : DocTemplatesName){
                Document_Template__c dtRec = new Document_Template__c();
                dtRec.Name = docName;
                dtRec.Candidate__c = con.Id;
                TemplatesToBeInserted.add(dtRec);
            }
        }
        if(TemplatesToBeInserted.size() > 0){
            insert TemplatesToBeInserted;
        }
    }
}