public with sharing class DocumentTemplateController {
    @AuraEnabled(cacheable=true)
    public static List<Document_Template__c> getDocumentTemplatesWithAttachments() {
        List<Document_Template__c> documentTemplates = [
            SELECT Id, Name, (SELECT Id,Name,ParentId FROM Attachments) 
            FROM Document_Template__c
        ];
        return documentTemplates;
    }
}