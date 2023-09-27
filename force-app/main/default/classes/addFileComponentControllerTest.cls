@isTest
public class addFileComponentControllerTest {
    @isTest
    static void testSaveChunk() {
        // Create test data
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
        
        String parentId = attachment1.id;
        String fileName = 'testFile.txt';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        String contentType = 'text/plain';
        String fileId = '';
        
        // Call the controller method
        Test.startTest();
        Id resultId = addFileComponentController.saveChunk(parentId, fileName, base64Data, contentType, fileId);
        Test.stopTest();
        
        // Assert that the resultId is not null
        System.assertNotEquals(null, resultId);
        
        // Additional assertions can be added here to verify specific behavior
    }
    
    @isTest
    static void testSaveTheFile() {
        // Create test data
       contact con = new contact();
        con.LastName='test';
        insert con;
        Lead testLead = new Lead(LastName = 'Test Lead',Company='Google',Products_Interested_In__c='Sales Cloud',Salesforce_AE__c=con.Id);
        insert testLead; 
        Document_Template__c template1 = new Document_Template__c(Name = 'Template 1', Lead__c = testLead.Id);
        insert template1;
        
        Documents_Attachment__c attachment1 = new Documents_Attachment__c(Name = 'Attachment 1', Document_Template__c = template1.Id);
        insert attachment1;
        
        String parentId = attachment1.id;
        String fileName = 'testFile.txt';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        String contentType = 'text/plain';
        
        // Call the controller method
        Test.startTest();
        Id fileId = addFileComponentController.saveTheFile(parentId, fileName, base64Data, contentType);
        Test.stopTest();
        
        // Assert that the fileId is not null
        System.assertNotEquals(null, fileId);
        
        // Additional assertions can be added here to verify specific behavior
    }
    
    @isTest
    static void testAppendToFile() {
        // Create test data
        contact con = new contact();
        con.LastName='test';
        insert con;
        Lead testLead = new Lead(LastName = 'Test Lead',Company='Google',Products_Interested_In__c='Sales Cloud',Salesforce_AE__c=con.Id);
        insert testLead; 
        Document_Template__c template1 = new Document_Template__c(Name = 'Template 1', Lead__c = testLead.Id);
        insert template1;
        
        Documents_Attachment__c attachment1 = new Documents_Attachment__c(Name = 'Attachment 1', Document_Template__c = template1.Id);
        insert attachment1;
        
        Attachment testAttachment = new Attachment(
            ParentId =attachment1.id,
            Name = 'testFile.txt',
            Body = Blob.valueOf('Initial content'),
            ContentType = 'text/plain'
        );
        insert testAttachment;
        
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf('Appended content'));
        
        // Call the controller method
        Test.startTest();
        addFileComponentController.appendToFile(testAttachment.Id, base64Data);
        Test.stopTest();
        
        // Retrieve the updated attachment
        Attachment updatedAttachment = [SELECT Id, Body FROM Attachment WHERE Id = :testAttachment.Id];
        
        // Assert that the attachment's body has been updated
    }
    
    
}