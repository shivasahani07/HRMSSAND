global without sharing class CommunitiesLoginControllerLwc {
    
    @AuraEnabled
    public static String performLogout(String hashCode) {
        CommunitiesLoginController controller = new CommunitiesLoginController();
        controller.performLogout(hashCode);
        return 'SUCCESS';
    }
    
    
    @AuraEnabled(cacheable=true)
    public static ResponseBody getUserdata(String recordId){
        contact getCondata=[SELECT AccountId,AssistantName,AssistantPhone,Birthdate,Contact_Role__c,Course__c,Father_Name__c,Department,Description,DoNotCall,Email,EmailBouncedDate,EmailBouncedReason,email_send__c,Fax,FirstName,hasCV__c,HasOptedOutOfEmail,HasOptedOutOfFax,Higereducation__c,HomePhone,Id,IndividualId,IsDeleted,IsEmailBounced,Is_Resource_Available__c,Jigsaw,JigsawContactId,job_Area__c,Language__c,LastActivityDate,LastCURequestDate,LastCUUpdateDate,LastModifiedById,LastModifiedDate,LastName,LastReferencedDate,LastViewedDate,LeadSource,LinkedIn_URL__c,Login_Hash_Code__c,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MobilePhone,Name,Office_Country__c,Office_State__c,OtherAddress,OtherCity,OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,OwnerId,Password__c,Payment_Captured__c,Phone,PhotoUrl,pi__campaign__c,pi__comments__c,pi__conversion_date__c,pi__conversion_object_name__c,pi__conversion_object_type__c,pi__created_date__c,pi__first_activity__c,pi__first_search_term__c,pi__first_search_type__c,pi__first_touch_url__c,pi__grade__c,pi__last_activity__c,pi__Needs_Score_Synced__c,pi__notes__c,pi__pardot_hard_bounced__c,pi__Pardot_Last_Scored_At__c,pi__score__c,pi__url__c,pi__utm_campaign__c,pi__utm_content__c,pi__utm_medium__c,pi__utm_source__c,pi__utm_term__c,RecordTypeId,ReportsToId,Role__c,Salutation,Status_Summary_Line__c,Status__c,SystemModstamp,Title,Total_Fee__c,Total_Leaves_Taken__c,Type__c FROM Contact WHERE Login_Hash_Code__c =:recordId];
        ResponseBody collectdata = new ResponseBody();
        collectdata.conrecord=getCondata;
        collectdata.piclistValues= AllPiclistvalues.getAllPicklistsValues('Mandate__c');
        system.debug('collectdata----------------->'+collectdata);
        return collectdata;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static contact getUserdatachild(String recordId){
        contact getCondata=[SELECT AccountId,AssistantName,AssistantPhone,Birthdate,Contact_Role__c,Course__c,Father_Name__c,Department,Description,DoNotCall,Email,EmailBouncedDate,EmailBouncedReason,email_send__c,Fax,FirstName,hasCV__c,HasOptedOutOfEmail,HasOptedOutOfFax,Higereducation__c,HomePhone,Id,IndividualId,IsDeleted,IsEmailBounced,Is_Resource_Available__c,Jigsaw,JigsawContactId,job_Area__c,Language__c,LastActivityDate,LastCURequestDate,LastCUUpdateDate,LastModifiedById,LastModifiedDate,LastName,LastReferencedDate,LastViewedDate,LeadSource,LinkedIn_URL__c,Login_Hash_Code__c,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MobilePhone,Name,Office_Country__c,Office_State__c,OtherAddress,OtherCity,OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,OwnerId,Password__c,Payment_Captured__c,Phone,PhotoUrl,pi__campaign__c,pi__comments__c,pi__conversion_date__c,pi__conversion_object_name__c,pi__conversion_object_type__c,pi__created_date__c,pi__first_activity__c,pi__first_search_term__c,pi__first_search_type__c,pi__first_touch_url__c,pi__grade__c,pi__last_activity__c,pi__Needs_Score_Synced__c,pi__notes__c,pi__pardot_hard_bounced__c,pi__Pardot_Last_Scored_At__c,pi__score__c,pi__url__c,pi__utm_campaign__c,pi__utm_content__c,pi__utm_medium__c,pi__utm_source__c,pi__utm_term__c,RecordTypeId,ReportsToId,Role__c,Salutation,Status_Summary_Line__c,Status__c,SystemModstamp,Title,Total_Fee__c,Total_Leaves_Taken__c,Type__c FROM Contact WHERE id =:recordId];
        system.debug('getCondata----------------->'+getCondata);
        return getCondata;
        
    }
    @AuraEnabled
    Public Static void updaateEducation(List<Education_Details__c> updateEducationdetailslist, String conId){
        system.debug('updateEducationdetailslist------>'+updateEducationdetailslist);
        system.debug('conId------>'+conId);
        list<Education_Details__c> listTobeUpdated =new  list<Education_Details__c>();
        for(Education_Details__c ed:updateEducationdetailslist){
            ed.Candidate__c=conId;
            listTobeUpdated.add(ed);
        }
        
        if(!listTobeUpdated.isEmpty()){
            upsert listTobeUpdated;
        }
        
    }
    
    @AuraEnabled
    Public static string updateContact(contact updatConact){
        system.debug('updatConact----------------->'+updatConact);
        update updatConact;
        return updatConact.id;
        
    }
    @AuraEnabled
    Public Static Void updateStatutoeyDetails(List<Statutory_Details__c> statutories,String conId ){
        system.debug('statutories------->'+statutories);
        system.debug('conId------>'+conId);
        list<Statutory_Details__c> listTobeUpdated =new  list<Statutory_Details__c>();
        for(Statutory_Details__c ed:statutories){
            ed.Candidate__c=conId;
            listTobeUpdated.add(ed);
        }
        
        if(!listTobeUpdated.isEmpty()){
            upsert listTobeUpdated;
        }
    }
    
    //this method willuplode file with education details
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null) { return null; }
        return cdl.Id;
    }
    
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    // this class will return data on lwc wire
    public class ResponseBody {
        @AuraEnabled 
        public contact conrecord {get; set;}
        @AuraEnabled 
        public List<string> piclistValues {get; set;}
        
    }
}