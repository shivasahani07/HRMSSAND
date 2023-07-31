public class PE_UserDashboardController {
    
    @AuraEnabled
    public static List < PE_Intervals__c > getIntervalDetailsSFDC() {
        List < PE_Intervals__c > intervalList = new List < PE_Intervals__c > ([SELECT ID, Name, Close_Date__c, End_Date__c, No_Of_Reminders__c, Notification_Date__c, Start_Date__c,Active__c FROM PE_Intervals__c ORDER BY Start_Date__c DESC]);
        return intervalList;
    }
    
    @AuraEnabled
    Public static Summary__c getCurrentUserSummary(String intervalId){
        Summary__c sumRec = [SELECT Id, Active__c, PE_Intervals__c, Status__c, User__c, ApprovalStatus__c FROM Summary__c WHERE PE_Intervals__c =: intervalId AND Active__c = TRUE LIMIT 1];
        system.debug('sumRec -- ' + sumRec);
        return sumRec;
    }
    
    @AuraEnabled
    Public static string initiateSummary(String intervalId){
        List<PE_Intervals__c> peIntervalList = [SELECT Id, Name, Start_Date__c, End_Date__c FROM PE_Intervals__c WHERE Id =: intervalId LIMIT 1];
        system.debug('peIntervalList -- ' + peIntervalList);
        Summary__c newSum = new Summary__c();
        newSum.Active__c = true;
        newSum.Name = UserInfo.getFirstName() + ' ' + peIntervalList[0].Name;
        newSum.PE_Intervals__c = intervalId;
        newSum.User__c = UserInfo.getUserId();
        newSum.Status__c = 'Requested';
        insert newSum;
        return newSum.Id;
    }
    
    @AuraEnabled
    public static Summary__c getUserSummaryStatus(String intervalId) {
        try {
            return [SELECT ID, PE_Intervals__c, Status__c FROM Summary__c where Active__c = : true AND PE_Intervals__c = : intervalId AND Active__c = TRUE limit 1];
        } 
        catch (Exception e) {
            return null;
        }
    }
        
    @AuraEnabled
    public static void updateSummaryStatus() {
        try {
            List < Summary__c > userSummary = [SELECT ID, Status__c FROM Summary__c where Active__c = : true AND User__c = : UserInfo.getUserId() limit 1];
            if (userSummary.size() > 0) {
                userSummary[0].Status__c = 'Submitted for Approval';
                update userSummary;
            }
        } 
        catch (Exception e) {}
    }
    
    @AuraEnabled
    public static List < user > selecteduserList() {
        Summary__c summObj = new Summary__c();
        summObj = [select Id, Active__c, User__c from Summary__c where Active__c = true AND User__c = : UserInfo.getUserId() limit 1];
        Set < Id > alreadyCreatedFeedbackpeerId = new Set < Id > ();
        List < PE_Feedback_New__c > feedbackList = [SELECT id, User__c, Peers_ID__c from PE_Feedback_New__c where PE_Summary__c = : summObj.id AND User__c = : UserInfo.getUserId() Order By Name ASC];
        for (PE_Feedback_New__c feedbackObj: feedbackList) {
            alreadyCreatedFeedbackpeerId.add(feedbackObj.Peers_ID__c);
        }
        List < user > usernamelist = [select Id, Name from user where id = : alreadyCreatedFeedbackpeerId Order By Name ASC];
        return usernamelist;
    }
    
    @AuraEnabled
    public static UserRoleWrapper fetchUserRoleDetails() {
        Summary__c summObj = new Summary__c();
        Set < String > nonActiveUserSet = new Set < String > ();
        UserRoleWrapper userRoleWrap = new UserRoleWrapper();
        List < RoleUSerWrapper > roleUserWrap = new List < RoleUSerWrapper > ();
        Set < id > alreadyCreatedFeedbackpeerId = new Set < id > ();
        String nonActiveUsers = System.Label.NonActiveUsers;
        nonActiveUserSet.addAll(nonActiveUsers.split(','));
        try {
            Map < String, List < User >> roleUserMAp = new Map < String, List < User >> ();
            summObj = [select Id, Active__c, User__c from Summary__c where Active__c = true AND User__c = : UserInfo.getUserId() limit 1];
            List < PE_Feedback_New__c > feedbackList = [SELECT id, User__c, Peers_ID__c from PE_Feedback_New__c where PE_Summary__c = : summObj.id AND User__c = : UserInfo.getUserId()];
            System.debug('feedbackListttttt'+feedbackList);
            for (PE_Feedback_New__c feedbackObj: feedbackList) {
                alreadyCreatedFeedbackpeerId.add(feedbackObj.Peers_ID__c);
            }
            System.debug('lreadyCreatedFeedbackpeerId******'+alreadyCreatedFeedbackpeerId);
            List < User > usersList = [SELECT Id, Name, userrole.name from User where IsActive = : true AND Id NOT IN: alreadyCreatedFeedbackpeerId AND Id != : UserInfo.getUserId() AND Name NOT IN: nonActiveUserSet Order By Name ASC];
            for (User usr: usersList) {
                if (usr.userrole.name <> null && roleUserMAp.containsKey(usr.userrole.name)) {
                    List < User > users = roleUserMAp.get(usr.userrole.name);
                    users.add(usr);
                    roleUserMAp.put(usr.userrole.name, users);
                } else {
                    roleUserMAp.put(usr.userrole.name, new List < User > {
                        usr
                            });
                }
            }
            for (String roleName: roleUserMAp.keySet()) {
                roleUserWrap.add(new RoleUSerWrapper(roleName, roleUserMAp.get(roleName)));
            }
            if (roleUserWrap.size() > 0) {
                userRoleWrap.allUsers = usersList.clone();
                List < String > listStrings = new List < String > (roleUserMAp.keySet());
                userRoleWrap.roleNames = listStrings;
                userRoleWrap.roleUserWrapList = roleUserWrap.clone();
                userRoleWrap.loggedInUSerId = UserInfo.getUserId();
                userRoleWrap.loggedInUSerName = UserInfo.getUserName();
            }
            system.debug('*****'+userRoleWrap);
            return userRoleWrap;
        }
        Catch(Exception e) {
            system.debug('*****'+e.getMessage());
            system.debug('*****'+e.getLineNumber());
            return null;
        }
        
    }
    
    
    @AuraEnabled
    public static void createPEFeedbackRecord(List < String > userIds) {
        Summary__c summObj = new Summary__c();
        List < PE_Feedback_New__c > peFeebackList = new List < PE_Feedback_New__c > ();
        map < String, String > feedbackUsermap = new map < String, String > ();
        try {
            if (userIds.size() > 0) {
                summObj = [select Id, Active__c, User__c from Summary__c where Active__c = true AND User__c = : UserInfo.getUserId() limit 1];
                
                List < User > usersList = [SELECT ID, Name, Email FROM User where Id In: userIds];
                String usersRoleId = UserInfo.getUserRoleId();
                System.debug('usersRoleId'+usersRoleId);
                Id PERecordTypeId = Schema.SObjectType.PE_Feedback_New__c.getRecordTypeInfosByName().get('PE Form').getRecordTypeId();
                List < userrole > usrsRole = [SELECT Id, Name, DeveloperName FROM UserRole where id = : usersRoleId];
                List < PE_Feedback_New__c > feedbackList = [SELECT id, User__c, Peers_ID__c from PE_Feedback_New__c where PE_Summary__c = : summObj.id];
                System.debug(feedbackList);
                
                for (PE_Feedback_New__c feedbackObj: feedbackList) {
                    feedbackUsermap.put(feedbackObj.Peers_ID__c, feedbackObj.User__c);
                }
                Messaging.SingleEmailMessage mailid = new Messaging.SingleEmailMessage();
                List <Messaging.SingleEmailMessage> emailList = new List <Messaging.SingleEmailMessage>();
                
                for (User usr: usersList) {
                    if (!feedbackUsermap.containsKey(usr.Id)) {
                        //   System.debug('@@@@@@@@@22');
                        PE_Feedback_New__c peFeedback = new PE_Feedback_New__c();
                        peFeedback.User__c = UserInfo.getUserId();
                        peFeedback.Peers_ID__c = usr.Id;
                        peFeedback.Status__c = 'Open';
                        peFeedback.RecordTypeId = PERecordTypeId;
                        peFeedback.PE_Summary__c = summObj.Id;
                        if (usrsRole.size() > 0) {
                            peFeedback.Users_Role__c = usrsRole[0].Name;
                            peFeedback.Users_Role_Id__c = usrsRole[0].Id;
                        }
                        peFeebackList.add(peFeedback);
                    }
                    //todo
                    string body = 'Dear ' + usr.Name + ',<br/><br/>';
                    body = body + 'We have shared a great connect in the last few months. <br/>';
                    body = body + 'It\'s time for you to provide me some feedback, which will help me become better as a professional. <br/>';
                    body = body + '<b><i>Note:Login and Navigate to \'Performance Evaluation\'18\'. Click on \'To Others\' and my name  to fill my feedback.</i></b>';
                    body = body + '<br/><br/>';
                    body = body + 'Thanks & Regards<br/>';
                    body = body + UserInfo.getName();
                    mailid.setSubject('Feedback for ' + UserInfo.getName());
                    mailid.setToAddresses(new List<String> {usr.Email});
                    mailid.setSaveAsActivity(false);
                    mailid.setHtmlBody(body);
                    emailList.add(mailid);
                }
                system.debug('emailList -- ' + emailList);
                if (emailList.size() > 0) {
                    Messaging.SendEmailResult[] result = Messaging.sendEmail(emailList);
                }                
                if (peFeebackList.size() > 0) {
                    insert peFeebackList;
                }
                String key = System.Label.FeedbackKey;
                integer mid = key.length() / 2;
                List < String > SplitedString = new List < String > ();
                SplitedString.add(key.substring(0, mid));
                SplitedString.add(key.substring(mid));
                String reversedkey = SplitedString[0].reverse() + '1996' + SplitedString[1].reverse();
                for (PE_Feedback_New__c feed: peFeebackList) {
                    Blob dataFid = Blob.valueOf(String.valueOf(feed.id));
                    Blob dataRid = Blob.valueOf(String.valueOf(feed.Users_Role_Id__c));
                    Blob cryptoKey = Blob.valueOf(reversedkey);
                    Blob encryptedDataFid = Crypto.encryptWithManagedIV('AES128', cryptoKey, dataFid);
                    String feedbackID = EncodingUtil.base64Encode(encryptedDataFid);
                    Blob encryptedDataRid = Crypto.encryptWithManagedIV('AES128', cryptoKey, dataRid);
                    String RoleID = EncodingUtil.base64Encode(encryptedDataRid);
                    System.debug('System.Label.SiteLinkForPE :::: '+System.Label.SiteLinkForPE);
                    String body = System.Label.SiteLinkForPE + feedbackID + '&&rid-' + RoleID; //sandbox link
                    feed.UrlForResponsePage__c = body;
                }
                update peFeebackList;
            }
        } 
        catch (Exception e) {
            system.debug('*****!!!'+e.getMessage());
            system.debug('*****1111'+e.getLineNumber());
        }
    }
    
    public class UserRoleWrapper {
        @AuraEnabled
        public List < USer > allUsers;
        @AuraEnabled
        public List < String > roleNames;
        @AuraEnabled
        public String loggedInUSerId;
        @AuraEnabled
        public String loggedInUSerName;
        @AuraEnabled
        public List < RoleUSerWrapper > roleUserWrapList;
    }
    
    public class RoleUSerWrapper {
        @AuraEnabled
        public string roleNAme;
        @AuraEnabled
        public List < User > userList;
        public RoleUSerWrapper(String rleName, List < User > usrLst) {
            roleNAme = rleName;
            userList = usrLst.clone();
        }
    }
    
    @AuraEnabled
    public static String getUser() {
        String userId = UserInfo.getName();
        return userId;
    }
    
    @AuraEnabled
    public static Integer reminderEmail() {
        String currentUser = UserInfo.getUserId();
        String userName = UserInfo.getName();
        Set < Id > idslist = new Set < Id > ();
        List < String > emailIdValue = new List < String > ();
        Messaging.SingleEmailMessage mailid = new Messaging.SingleEmailMessage();
        List < Messaging.SingleEmailMessage > emailList = new List < Messaging.SingleEmailMessage > ();
        List < PE_Feedback_New__c > pendingfeedback = [select id, Peers_ID__c, Status__c, User__c from PE_Feedback_New__c where Status__c <> 'Submitted'
                                                       AND User__c = : currentUser
                                                      ];
        if (pendingfeedback.size() > 0) {
            for (PE_Feedback_New__c feedbackObj: pendingfeedback) {
                idslist.add(feedbackObj.Peers_ID__c); 
            }
        }
        if (idslist.size() > 0) {
            for (user peerId: [select id, Email from user where id in : idslist]) {
                emailIdValue.add(peerId.Email);
            }
        }
        if(emailIdValue.size() > 0){
            string body = 'Dear All, <br/><br/>';
            body = body + 'We have shared a great connect in the last few months. <br/>';
            body = body + 'It\'s time for you to provide me some feedback, which will help me become better as a professional. <br/>';
            body = body + '<b><i>Note:Login and Navigate to \'Performance Evaluation\'18\'. Click on \'To Others\' and my name  to fill my feedback.</i></b>';
            body = body + '<br/><br/>';
            body = body + 'Thanks & Regards,<br/>';
            body = body + userName;
            mailid.setSubject('Feedback Reminder from ' + userName);
            mailid.setBccAddresses(emailIdValue);
            mailid.setSaveAsActivity(false);
            mailid.setHtmlBody(body);
            emailList.add(mailid);
            if (emailList.size() > 0) {
                Messaging.SendEmailResult[] result = Messaging.sendEmail(emailList);
            }
        }
        return pendingfeedback.size();
    }
}