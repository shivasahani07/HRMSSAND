public class Attachement_Trigger_Helper {
    
    public static void HandleAttachements(List<Attachment> AttList){
        Id parentID = AttList[0].parentId;
        map<String,String> docTempIdByJobReqId = new map<String,String>();
        List<Documents_Attachment__c> DocAttList = new List<Documents_Attachment__c>();
        
        system.debug('Sobject NAme ==> '+parentID.getSObjectType().getDescribe().getName());
        
        if(parentID.getSObjectType().getDescribe().getName() == 'Mandate__c'){
            List<Document_Template__c> AttLists =  [Select id,Name from Document_Template__c where Job_Requisition__c =:parentID];
            system.debug('AttLists'+AttLists);
            for(Document_Template__c dt : AttLists){
                if(dt.Name == 'Executive Summary'){
                    docTempIdByJobReqId.put('Executive Summary',dt.Id);
                }else if(dt.Name == 'Job Description'){
                    docTempIdByJobReqId.put('Job Description',dt.Id);                    
                }else if(dt.Name == 'Research Strategy'){
                    docTempIdByJobReqId.put('Research Strategy',dt.Id);
                }else if(dt.Name == 'Employee Profile'){
                    docTempIdByJobReqId.put('Employee Profile',dt.Id);
                }
            }
            
            system.debug('docTempIdByJobReqId'+docTempIdByJobReqId);         
            for(Attachment att:AttList){
                Documents_Attachment__c da = new Documents_Attachment__c();
                da.Attachement_Id__c  = att.Id;
                da.name = att.Name;
                system.debug('da.name'+da.name);
                if(att.Name.contains('Employee')){
                    da.Document_Template__c =  docTempIdByJobReqId.get('Executive Summary');
                }else if(att.Name.contains('Job')){
                    da.Document_Template__c =  docTempIdByJobReqId.get('Job Description');
                } else if(att.Name.contains('Research')){
                    da.Document_Template__c =  docTempIdByJobReqId.get('Research Strategy');
                }else if(att.Name.contains('Executive')){
                    da.Document_Template__c =  docTempIdByJobReqId.get('Employee Profile');
                }else{
                    da.Document_Template__c =  docTempIdByJobReqId.get('Executive Summary');
                }
                DocAttList.add(da);
            }
            system.debug('DocAttList'+DocAttList);
            
        }
        
        if(parentID.getSObjectType().getDescribe().getName() == 'Document_Template__c'){
            List<id> parentIds = new List<Id>();
            for(Attachment att:AttList){
                parentIds.add(att.parentId);
            }
            
            List<Document_Template__c> AttLists =  [Select id,Name from Document_Template__c where ID IN:parentIds];
            
            for(Attachment att:AttList){
                Documents_Attachment__c da = new Documents_Attachment__c();
                da.Attachement_Id__c  = att.Id;
                da.name = att.Name;
                da.Document_Template__c =  att.ParentId;
                DocAttList.add(da);
            }
            system.debug(DocAttList);
        }
        if(DocAttList.size() > 0){
            insert DocAttList;    
        }
    }
}