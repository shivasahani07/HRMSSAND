public without sharing class EmailToAEsForUpdateBatch implements Database.Batchable<Sobject> {
    
    public Database.QueryLocator Start(Database.BatchableContext bc){
        return Database.getQueryLocator ('SELECT Id, Name, Company, Status, Proposal_Submission_Date__c, Salesforce_AE__c, Salesforce_AE__r.FirstName, Salesforce_AE__r.Email,(SELECT Id, CreatedDate, OldValue, NewValue FROM Histories WHERE Field = \'Status\' Order By CreatedDate desc LIMIT 1) FROM Lead WHERE (Status = \'Proposal Submitted\' OR Status = \'Follow Up\' ) AND Salesforce_AE__c != null AND Proposal_Submission_Date__c != null ');
    }
    
    public void execute (Database.BatchableContext bc, List<Lead> leadList){
        try{
            system.debug('leadList.size() :: ' + leadList.size());
            List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
            
            for(Lead ld : leadList){
                if(!ld.Histories.isEmpty()){
                    system.debug('history not null:: ');
                    LeadHistory history = ld.Histories[0];
                    if( history.NewValue == 'Follow Up' && history.CreatedDate.date() == system.today() ){
                        
                        system.debug('date entered:: ');
                        Messaging.SingleEmailMessage oppEmail = new Messaging.SingleEmailMessage();
                        List <String> emailRecipients = new List <String>{ld.Salesforce_AE__r.Email};
                            
                        oppEmail.setToAddresses(emailRecipients);
                        String subj = 'Followup on Submitted Proposal with ' + ld.Name;
                        oppEmail.setSubject(subj);
                        oppEmail.setReplyTo(emailRecipients[0]);
                        
                        String emailBody = 'Dear ' + ld.Salesforce_AE__r.FirstName + ',';
                        emailBody += '<br> <br> Greetings. Hope you would be doing great. ';
                        emailBody += 'We had submitted implementation proposal to ' + ld.Name + ' on ' +  ld.Proposal_Submission_Date__c + '. If you find appropriate, consider nudging the customer on further proceedings. <br> <br>';
                        emailBody += '<b> Note: This is system generated email. if you don’t wish to receive this email, please advise us on next date of follow up by clicking on following link.</b> <br><br>';
                        emailBody += 'Thanks and Regards, <br>';
                        emailBody += 'Utilitarian Labs Pvt. Ltd.';
                        oppEmail.setHtmlBody(emailBody);
                        emailsList.add(oppEmail);
                    }
                }
            }
            
            if(!emailsList.isEmpty()) {
                update leadList;
                Messaging.sendEmail(emailsList);     
            }
        }
        catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NO :: ' + e.getLineNumber());
        }
    }
    
    public void finish(Database.BatchableContext bc){
        system.debug('The batch ran successfully!');
    }
}