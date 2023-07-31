public class BatchToSendEmail implements  Database.Batchable<sObject>{
    public  Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select FirstName,Email,Id From Contact where email != null and email_send__c =false AND Account.Name != \'Salesforce\' And Account.Name =  \'Do Not Delete\'');
    }
    public void execute(Database.BatchableContext BC, List<Contact> conList){
        List<Contact> conListtoUpdate = new List<Contact>();
        /*
        List<Messaging.MassEmailMessage > mails = new List<Messaging.MassEmailMessage >();
        for (Contact myContact : conList) {
            contact conRec = new contact();
            conRec.Id = myContact.Id;
            conRec.email_send__c = true;
            conListtoUpdate.add(conRec);
            
            Messaging.MassEmailMessage  mail = new Messaging.MassEmailMessage ();
            
            sendTo.add(myContact.Email);
            mail.setToAddresses(sendTo);
            
            mail.setSenderDisplayName('Utilitarian Labs');
            mail.setReplyTo('Ajeet.kumar@utilitarianlab.com');
            mail.setSubject('Cheers 2023');
            mail.setHtmlBody('Hello '+myContact.FirstName+',<br/><br/>Greetings. I wish this upcoming year 2023 brings prosperity and joy in your life.<br/><br/>Happy New year....!!!');
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
        if(!conListtoUpdate.isEmpty()){
            update conListtoUpdate;
        }
        
        */
        List<Id> lstids= new List<Id>();
        for(Contact c:conList)
        {
            lstids.add(c.id);
            contact conRec = new contact();
            conRec.Id = c.Id;
            conRec.email_send__c = true;
            conListtoUpdate.add(conRec);
        }
        EmailTemplate et=[Select id from EmailTemplate where name = 'Cheers 2023' limit 1];
        
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        mail.setTargetObjectIds(lstIds);
        mail.setSenderDisplayName('Utilitarian Labs');
        mail.setTemplateId(et.id);
        Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }
    public void finish(Database.BatchableContext BC){}
    
}