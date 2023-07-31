public without sharing class SendEmailController {
    
    
    @AuraEnabled
    public static Lead_ContentDocWrapper getLead_ContentDocWrapper(string leadId){
        
        List<ContentDocumentLink> docLink = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: leadId];
        List<ContentDocument> doc = [SELECT Id, FileExtension, Title FROM ContentDocument Order by LastModifiedDate desc LIMIT 1];
        List<Lead> ldList = [SELECT Id, Email, Name, Company FROM Lead WHERE Id=: leadId LIMIT 1];
        
        Sales_Process_Configurations__c	config = Sales_Process_Configurations__c.getall().values();
        
        String msg = 'Hi ' + ldList[0].Name + ',';
        msg += '<br><br>It was a wonderful discussion yesterday with both of you, followed by our discussion - I am putting a proposal containing the scope, timeline, and cost estimates for the Sales process implementation (Implementation cost of XX Lacs).';
        msg += '<br><br>Before we go ahead and write about the attached proposal, allow me to Thank you for expressing faith in our implementation capabilities. Technically, we claim ourselves to be leaders in industries like E-commerce, Fintech, Edtech, Healthcare, Tourism & Hospitality, Recruitment & Staffing, Non-profits, manufacturing etc & have done numerous implementations for these industries.';
        msg += '<br><br>Being "' + ldList[0].Company + '" specific – we have put scope, timelines, commercials etc from best of our understanding in the attached doc. However, we are open for any further discussion, if required.';
        msg += '<br><br>Thanks a lot again for trusting Utilitarian Labs for this implementation. We will ensure the best in class and timely implementation!!!';
        
        Lead_ContentDocWrapper wrp = new Lead_ContentDocWrapper();
        wrp.contentDoc = doc[0];
        wrp.leadEmailId = ldList[0].Email;
        wrp.ccMailIds = config.cC_Email_Ids__c;
        wrp.emailMsg = msg;
        return wrp;
    }
    
    public class Lead_ContentDocWrapper{
        @AuraEnabled
        Public ContentDocument contentDoc;
        @AuraEnabled
        Public String leadEmailId;
        @AuraEnabled
        Public String ccMailIds;
        @AuraEnabled
        Public String emailMsg;
    }
    
    @AuraEnabled
    public static string processEmail(String email, String Subject, String Message, String CC, String cdId, String fileName, String leadId){
        String sMessage='';
        try{
            Lead ld = [SELECT Id, Proposal_Submitted_Date__c, Proposal_Submitted__c FROM Lead WHERE Id =: leadId];
            ld.Proposal_Submitted_Date__c = system.today();
            ld.Proposal_Submitted__c = true;
            update ld;
            
            List<String> ccList = CC.split(';');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> mailIds = email.split(';');
            String[] toAddresses = mailIds; 
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccList);
            mail.setSubject(Subject);
            mail.setHtmlBody(Message);
            
            List<ContentVersion> cvList = [SELECT VersionData, FileExtension FROM ContentVersion WHERE ContentDocumentId = :cdId AND IsLatest = true];
            Blob fileData = cvList[0].VersionData; 
            Messaging.EmailFileAttachment emlAtt = new Messaging.EmailFileAttachment();
            emlAtt.setFilename(fileName + '.' + cvList[0].FileExtension);
            emlAtt.setBody(fileData); 
            emlAtt.setContentType('application/pdf');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { emlAtt });
            
            Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            sMessage='Success';
        }
        catch(Exception ex){
            sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString();
            system.debug('sMessage -- ' + sMessage);
        }
        return sMessage;
    }
    
}