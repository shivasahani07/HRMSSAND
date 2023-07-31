public class PE_Email_Trigger_Handler {
    private static PE_Email_Trigger_Handler instance;
    public static PE_Email_Trigger_Handler getInstance() {
        if (instance == null) { //for singleton object
            instance = new PE_Email_Trigger_Handler();
        }
        return instance;
    }
    // List < Messaging.SingleEmailMessage > emails = new List < Messaging.SingleEmailMessage > ();
    public void onAfterInsert(list < PE_Feedback_New__c > newlist) {
     //   System.debug(newlist);
        try {
            //List<Messaging.SingleEmailMessage>﻿ emails = new List<Messaging.SingleEmailMessage>﻿();
            //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage ();
            Set < Id > idslist = new Set < Id > ();
            List < String > emailIds = new List < String > ();
            map < String, String > Emailmap = new map < String, String > ();
            for (PE_Feedback_New__c feedbackObj: newlist) {
                idslist.add(feedbackObj.Peers_ID__c); // feedbackObj.Peers_ID__c.split(',');
              //  System.debug(idslist);
            }
            for (user peerId: [select id, Email from user where id in : idslist]) {
                //emailIds.add(peerId.Email);
                Emailmap.put(peerId.id, peerId.Email);
            }
       //     System.debug('Emailmap'+Emailmap);
            // Blob cryptoKey = Crypto.generateAesKey(128);
            //Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
            Blob dataFid;
            Blob dataRid;
            String key = System.Label.FeedbackKey;
            integer mid = key.length() / 2;
            List < String > SplitedString = new List < String > ();
            SplitedString.add(key.substring(0, mid));
            SplitedString.add(key.substring(mid));
            //   System.debug('@@@@'+SplitedString);
            String reversedkey = SplitedString[0].reverse() + '1996' + SplitedString[1].reverse();
            // System.debug('reversedkey'+reversedkey);
             
            List<Messaging.SingleEmailMessage> emailList =new List<Messaging.SingleEmailMessage>();
            
            for (PE_Feedback_New__c feedbackObj: newlist) {
                List < String > emailIdValue = new List < String > ();
                String userName = UserInfo.getName();
                // String keytempw = EncodingUtil.base64Encode(cryptoKey);
                //encryption for Feedback ID
                dataFid = Blob.valueOf(String.valueOf(feedbackObj.id));
                //encryption for Role ID            
                dataRid = Blob.valueOf(String.valueOf(feedbackObj.Users_Role_Id__c));
                Messaging.SingleEmailMessage mailid = new Messaging.SingleEmailMessage();
                /*   OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'tamanna.shukla082@gmail.com'];
if ( owea.size() > 0 ) {
mailId.setOrgWideEmailAddressId(owea.get(0).Id);
}*/
                String UserEmail = [select Id, Email, Name from user where id = : UserInfo.getUserId()].Name;
                mailId.setSenderDisplayName(UserEmail);
                Blob cryptoKey = Blob.valueOf(reversedkey);
                //  String key = feedbackObj.id + feedbackObj.Users_Role_Id__c  ;
                //  System.debug(key);
                // Blob cryptoKey = Blob.valueOf(key);
                Blob encryptedDataFid = Crypto.encryptWithManagedIV('AES128', cryptoKey, dataFid);
                String feedbackID = EncodingUtil.base64Encode(encryptedDataFid);
                Blob encryptedDataRid = Crypto.encryptWithManagedIV('AES128', cryptoKey, dataRid);
                String RoleID = EncodingUtil.base64Encode(encryptedDataRid);
                //  System.debug('feedbackID:::'+feedbackID);
                //  System.debug('RoleID::::'+RoleID);
                if (Emailmap.containsKey(feedbackObj.Peers_ID__c)) {
                    emailIdValue.add(Emailmap.get(feedbackObj.Peers_ID__c));
                }
                string body = 'Hi, <br/>';
                body = body + 'Below is the feedback link. <br/><br/>';
                // body = body + '<a href="\'https://eleavemod-extentortquila.cs72.force.com/feedbacklink?fid-' + feedbackID + '&&rid-' + RoleID+'"> Link </a><br/>';
                
                body = body + System.Label.SiteLinkForPE + feedbackID + '&&rid-' + RoleID+ '<br/><br/>';
                body = body + '<b>Note: If above link is not working please copy and paste it in your browser for feedback.<b>';
                //  system.debug('body:::' + body);
                mailid.setSubject('Feedback Request from ' + userName);
                //mailid.setTargetObjectId(idslist);
             //   System.debug('emailIdValue'+emailIdValue);
                mailid.setToAddresses(emailIdValue);
                mailid.setSaveAsActivity(false);
                mailid.setHtmlBody(body);
           //     Messaging.SingleEmailMessage[] emails = new List < Messaging.SingleEmailMessage > {mailid  }; //Commented here
              //      System.debug('mailid'+mailid);
                  //  Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                  emailList.add(mailid);
            }
            if(emailList.size()>0){
               // system.debug('emailList'+emailList);
           //     system.debug('entered**');
                Messaging.SendEmailResult [] result = Messaging.sendEmail(emailList);
          //      system.debug('Email is sent'+result);
            }
        } catch (Exception e) {
        //    system.debug('exception '+e);
       //     system.debug('exception mess '+e.getMessage());
          //  system.debug('exception line'+e.getLineNumber());
            Messaging.SingleEmailMessage mailidforException = new Messaging.SingleEmailMessage();
            mailidforException.setSubject('Exception in trigger ');
            mailidforException.toAddresses = new String[] { 'tamanna.shukla@etmarlabs.com', 'sumit.kumar@etmarlabs.com' };
                mailidforException.setSaveAsActivity(false);
            String     body = 'line number is'+ e.getLineNumber() +'message is '+e.getMessage();
            mailidforException.setHtmlBody(body);
            Messaging.SingleEmailMessage[] emails = new List < Messaging.SingleEmailMessage > {
                mailidforException
                    };
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        }
        
    }
}