public without sharing class PE_SelfAssessmentHelper {
    
    @AuraEnabled
    public static PE_Feedback_New__c getSelfAssessmentFeedbackRecord(){
        PE_Feedback_New__c peFeedBackList = [SELECT Id, Status__c FROM PE_Feedback_New__c WHERE Peers_ID__c =: UserInfo.getUserId() LIMIT 1];
        return peFeedBackList;
    }
    
    @AuraEnabled
    public static string returnURL(){
        PE_Feedback_New__c peFeedBackList = [SELECT Id, Status__c, UrlForResponsePage__c FROM PE_Feedback_New__c WHERE Peers_ID__c =: UserInfo.getUserId() AND Status__c = 'In Draft' LIMIT 1];
        return peFeedBackList.UrlForResponsePage__c;
    }
    
    @AuraEnabled
    public static string createSelfFeedbackRecord(){
        Id PERecordTypeId = Schema.SObjectType.PE_Feedback_New__c.getRecordTypeInfosByName().get('PE Form').getRecordTypeId();
        String usersRoleId = UserInfo.getUserRoleId();
        System.debug('usersRoleId'+usersRoleId);
        List < userrole > usrsRole = [SELECT Id, Name, DeveloperName FROM UserRole where id = : usersRoleId];
        Summary__c summObj = [select Id, Active__c, User__c from Summary__c where Active__c = true AND User__c = : UserInfo.getUserId() limit 1];
        
        PE_Feedback_New__c peFeedback = new PE_Feedback_New__c();
        peFeedback.User__c = UserInfo.getUserId();
        peFeedback.Peers_ID__c = UserInfo.getUserId();
        peFeedback.Status__c = 'Open';
        peFeedback.RecordTypeId = PERecordTypeId;
        peFeedback.PE_Summary__c = summObj.Id;
        if (usrsRole.size() > 0) {
            peFeedback.Users_Role__c = usrsRole[0].Name;
            peFeedback.Users_Role_Id__c = usrsRole[0].Id;
        }
        
        insert peFeedback;
        
        String key = System.Label.FeedbackKey;
        integer mid = key.length() / 2;
        List < String > SplitedString = new List < String > ();
        SplitedString.add(key.substring(0, mid));
        SplitedString.add(key.substring(mid));
        String reversedkey = SplitedString[0].reverse() + '1996' + SplitedString[1].reverse();
        Blob dataFid = Blob.valueOf(String.valueOf(peFeedback.id));
        Blob dataRid = Blob.valueOf(String.valueOf(peFeedback.Users_Role_Id__c));
        Blob cryptoKey = Blob.valueOf(reversedkey);
        Blob encryptedDataFid = Crypto.encryptWithManagedIV('AES128', cryptoKey, dataFid);
        String feedbackID = EncodingUtil.base64Encode(encryptedDataFid);
        Blob encryptedDataRid = Crypto.encryptWithManagedIV('AES128', cryptoKey, dataRid);
        String RoleID = EncodingUtil.base64Encode(encryptedDataRid);
        System.debug('System.Label.SiteLinkForPE :::: '+System.Label.SiteLinkForPE);
        String body = System.Label.SiteLinkForPE + feedbackID + '&&rid-' + RoleID; //sandbox link
        peFeedback.UrlForResponsePage__c = body;
        update peFeedback;
        return body;
    }
    
}