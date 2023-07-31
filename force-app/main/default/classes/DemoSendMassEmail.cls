public class DemoSendMassEmail
{
     public static void SendEmail()
     {
        String subject = 'Testing Mass email demo';
        String body = 'This is testing for Send mass emails from your apex class in Salesforce';       
        // Create a master list to store the emails that we will send
        List<Messaging.SingleEmailMessage> masterListMails =  
        new List<Messaging.SingleEmailMessage>();
        for (Contact myContact : [select FirstName,Email,Id From Contact where email != null and email_send__c =false AND Account.Name != 'Salesforce' And Account.Name = 'Do Not Delete'])
        {
           // Define the email
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            // Set list of peoples who should recieve an email
            List<String> sendTo = new List<String>();
            sendTo.add(myContact.Email);
            email.setToAddresses(sendTo);
            
            email.setSenderDisplayName('Official Nitish Account');
            
            
            email.setSenderDisplayName('Utilitarian Labs');
            email.setReplyTo('Ajeet.kumar@utilitarianlab.com');
            email.setSubject('Cheers 2023');
            email.setHtmlBody('Hello '+myContact.FirstName+',<br/><br/>Greetings. I wish this upcoming year 2023 brings prosperity and joy in your life.<br/><br/>Happy New year....!!!');
            
 
             // Add your email address into the master list
             masterListMails.add(email);
         }
       // Sends mass emails
       Messaging.sendEmail(masterListMails);
      }
}