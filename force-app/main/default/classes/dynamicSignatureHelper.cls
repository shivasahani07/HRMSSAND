public with sharing class dynamicSignatureHelper {
    public dynamicSignatureHelper() {

    }

    @AuraEnabled
    public static String saveSignature(String ContentVersionData, Id recordId,Boolean isSubmitted){
		system.debug('recordId'+recordId);
        Application__c submitApplication = new Application__c();
        submitApplication.Is_Submitted__c=isSubmitted;
        submitApplication.ID=recordId;
        update submitApplication;

			system.debug('recordId--------'+recordId);
        /*
            Create Content Version Object and then after content document link
        */
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S';
        cVersion.PathOnClient = 'Signature-'+System.now() +'.png';
        cVersion.Origin = 'H';
        cVersion.Title = 'Signature-'+System.now() +'.png';
        cVersion.VersionData = EncodingUtil.base64Decode(ContentVersionData);
        Insert cVersion;

        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;
        cDocLink.LinkedEntityId = recordId;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'AllUsers';
        Insert cDocLink;

        return cVersion.Id;
    }

}