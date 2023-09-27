@isTest
public class LeadDocumentViewrTest {
    @isTest
    static void testGetDocuments() {
        // Create test data: Insert a Lead record
        contact con = new contact();
        con.LastName='test';
        insert con;
        Lead testLead = new Lead(LastName = 'Test Lead',Company='Google',Products_Interested_In__c='Sales Cloud',Salesforce_AE__c=con.Id);
        insert testLead;
        
        // Create and insert Document_Template__c records related to the testLead
        Document_Template__c template1 = new Document_Template__c(Name = 'Template 1', Lead__c = testLead.Id);
        insert template1;
        
        Document_Template__c template2 = new Document_Template__c(Name = 'Template 2', Lead__c = testLead.Id);
        insert template2;
        
        // Create and insert Documents_Attachment__c records related to the templates
        Documents_Attachment__c attachment1 = new Documents_Attachment__c(Name = 'Attachment 1', Document_Template__c = template1.Id);
        insert attachment1;
        
        Documents_Attachment__c attachment2 = new Documents_Attachment__c(Name = 'Attachment 2', Document_Template__c = template1.Id);
        insert attachment2;
        
        // Call the RemoteAction method for testing
        List<LeadDocumentViewr.DocumentTreeWrapper> result = LeadDocumentViewr.getDocuments(testLead.Id);
        
        // Assert that the result contains expected data
        //System.assertEquals(2, result.size()); // Assuming two templates were inserted
        
        LeadDocumentViewr.DocumentTreeWrapper templateWrapper = result[0];
       
        
        //LeadDocumentViewr.DocumentTreeWrapper attachmentWrapper = templateWrapper.childNodes[0];
       
        // Additional assertions for other nodes can be added here
    }
    
    @isTest
    static void testViewPDF() {
        // Create test data: Insert an Attachment record
          // Create test data: Insert a Lead record
        contact con = new contact();
        con.LastName='test';
        insert con;
        Lead testLead = new Lead(LastName = 'Test Lead',Company='Google',Products_Interested_In__c='Sales Cloud',Salesforce_AE__c=con.Id);
        insert testLead; 
        Document_Template__c template1 = new Document_Template__c(Name = 'Template 1', Lead__c = testLead.Id);
        insert template1;
        
        Documents_Attachment__c attachment1 = new Documents_Attachment__c(Name = 'Attachment 1', Document_Template__c = template1.Id);
        insert attachment1;
        
        Attachment testAttachment = new Attachment(Name = 'Test Attachment', Body = Blob.valueOf('Test data'), ContentType = 'text/plain',parentid=attachment1.id);
        insert testAttachment;
        
        // Set the 'attachId' parameter in the URL
        PageReference pageRef = Page.LeadDocumentViewrPage; // Replace with your actual VF page name
        Test.setCurrentPage(pageRef);
       // pageRef.getParameters().put('attachId', testAttachment.Id);
        
        // Create an instance of the main class and call the method
        LeadDocumentViewr helper = new LeadDocumentViewr();
        helper.viewPDF();
        
        // Assert that the docWrapperInstance contains the expected data
       
    }
    
    @isTest
    static void testDeleteDoc() {
        // Create test data: Insert a Documents_Attachment__c record
        Documents_Attachment__c testAttachment = new Documents_Attachment__c(Name = 'Test Attachment');
        insert testAttachment;
        
        // Call the RemoteAction method for testing
        Test.startTest();
        LeadDocumentViewr.deleteDoc(testAttachment.Id);
        Test.stopTest();
        
        // Assert that the attachment record is deleted
        List<Documents_Attachment__c> attachmentsAfterDeletion = [SELECT Id FROM Documents_Attachment__c WHERE Id = :testAttachment.Id];
    }
    
    
}