public class JobapplicationHelper {

    @AuraEnabled(cacheable=true)
    public static  List<Application__c> getJobApplications(String recordId){
        System.debug('recordId--'+recordId);
        List<Application__c> Applications =[SELECT ID,Origin__c,Contact__c,mandate_company_name__c,Last_Working_Day__c,Mandate_Start_Date__c,Name,Mandate__c,Status_Summary_Line__c,Contact__r.Name,Contact__r.Phone,
                                            Contact__r.Email,Contact__r.LinkedIn_URL__c,Contact__r.Contact_Role__c FROM Application__c  where Last_Working_Day__c != null Limit 5];

        System.debug('Applications--'+Applications);
        return Applications;
    }

    @AuraEnabled(cacheable=true)
    public static  List<Application__c> getJobApplicationsFinsl(String recordId){
        System.debug('recordId--'+recordId);
        List<Application__c> Applications =[SELECT ID,Origin__c,Contact__c,mandate_company_name__c,Last_Working_Day__c,Mandate_Start_Date__c,Name,Mandate__c,Status_Summary_Line__c,Contact__r.Name,Contact__r.Phone,
                                            Contact__r.Email,Contact__r.LinkedIn_URL__c,Contact__r.Contact_Role__c FROM Application__c where Last_Working_Day__c != null Limit 5];

        System.debug('Applications--'+Applications);
        return Applications;
    } 
    
    @AuraEnabled(cacheable=true)
    public static  List<Application__c> getJobApplicationsInterViewing(String recordId){
        System.debug('recordId--'+recordId);
        List<Application__c> Applications =[SELECT ID,Origin__c,Contact__c,mandate_company_name__c,Last_Working_Day__c,Mandate_Start_Date__c,Name,Mandate__c,Status_Summary_Line__c,Contact__r.Name,Contact__r.Phone,
                                            Contact__r.Email,Contact__r.LinkedIn_URL__c,Contact__r.Contact_Role__c FROM Application__c where Last_Working_Day__c != null Limit 5] ;

        System.debug('Applications--'+Applications);
        return Applications;
    }
     @AuraEnabled(cacheable=true)
      public static  List<Partner__c> getAllpartners(string JobReqId){
          List<Partner__c> allPartners=[SELECT Id,Name,Email__c,Number__c,Ratings__c,Website__c,Type__c FROM Partner__c];
           List<Job_Post__c> jobPosted =[SELECT Id,Name,Partner__c,Job_Requisition__c from Job_Post__c WHERE Job_Requisition__c=:JobReqId ];
        return allPartners;
      }


    @AuraEnabled
    Public static void createPostJobRecords(List<string> PartnersId,string JobReqId){
        System.debug('PartnersId'+ PartnersId);
        System.debug('JobReqId'+ JobReqId);
        List<Job_Post__c> jobPostTobeInserted = new List<Job_Post__c>();
        for(string partnerId :PartnersId){
            Job_Post__c createPostJob = new Job_Post__c();
            createPostJob.Partner__c=partnerId;
            createPostJob.Job_Requisition__c=JobReqId;
            jobPostTobeInserted.add(createPostJob);
        }
        if(jobPostTobeInserted !=null){
            insert jobPostTobeInserted;
        
        }




    }

    @AuraEnabled(cacheable=true)
    Public static jobdetailsWrapper addCandidateToJobReq(){
        List<Mandate__c> alljobsList =[SELECT Amount_spent__c,Annual_CTC__c,Total_Application_Recevied__c,Approval_Status__c,Assignment_Status__c,Campus__c,Company__c,CreatedById,CreatedDate,Department__c,Designation_Master__c,Designation__c,Employment_Type__c,Experiance__c,Id,Industry_Types__c,Industry__c,IsDeleted,Job_Desccription_Template__c,Job_Desccription_Template__r.Description__c,Job_Function__c,Job_Status__c,Job_Title__c,Job_Type__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Location_Master__c,Location__c,Manager__c,Mandate_Company_Name__c,Mandate_End_Date__c,Mandate_Start_Date__c,Module__c,Name,Opening_Date__c,OwnerId,Qualification__c,Salary__c,Skill_Set__c,State__c,Status__c,Summary_Description__c,SystemModstamp,Target_Date__c,Time_Taken_for_job__c,Total_Candidates_Required__c,Work_Mode__c,Designation_Master__r.Name FROM Mandate__c];
        System.debug('alljobsList'+ alljobsList);
        List<Job_Desccription_Template__c> allJobsDesTempList=[SELECT Id,Name,Child_Master__c,Description__c,Child_Master__r.Name FROM Job_Desccription_Template__c];
        List<Application__c> submitedApplicatonsList=[SELECT Id,Name,Status_Summary_Line__c,Mandate__c,Is_Submitted__c,Job_Post__c,Last_Working_Day__c,Mandate_Start_Date__c,mandate_company_name__c,Contact__c,Origin__c,OwnerId FROM Application__c WHERE Job_Post__c !=null];
        List<Contact> tageCandidate =[SELECT AccountId,Anniversary_Date__c,AssistantName,AssistantPhone,Birthdate,Child_Master__c,Contact_Role__c,Course__c,Department,Description,Email,email_send__c,Father_Name__c,Fax,FirstName,Gender__c,hasCV__c,Higereducation__c,HomePhone,Id,IsEmailBounced,Is_Resource_Available__c,job_Area__c,Language__c,LastName,LinkedIn_URL__c,Login_Hash_Code__c,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MobilePhone,Name,Office_Country__c,Office_State__c,OtherAddress,OtherCity,OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,OwnerId,Password__c,Payment_Captured__c,Phone,PhotoUrl,RecordTypeId,ReportsToId,Role__c,Salutation,Status_Summary_Line__c,Status__c,Title,Total_Fee__c,Total_Leaves_Taken__c,Type__c,Aadhar__c FROM Contact LIMIT 100];
        List<Job_Post__c> allPostedJobsList=[SELECT Id,Name,Job_Requisition__c,Job_Title__c,Partner__c,Partner_Name__c FROM Job_Post__c];
        jobdetailsWrapper  fillWrapper = new jobdetailsWrapper();
        fillWrapper.alljobs=alljobsList;
        fillWrapper.allJobsDesTemp=allJobsDesTempList;
        fillWrapper.submitedApplicatons=submitedApplicatonsList;
        fillWrapper.tageCandidate=tageCandidate;
        fillWrapper.allPostedJobs=allPostedJobsList;
        System.debug('fillWrapper'+ fillWrapper);
        return fillWrapper;
    }

    
        Public class jobdetailsWrapper{
            @AuraEnabled
            Public List<Mandate__c> alljobs {get;set;}
            @AuraEnabled
            Public List<Job_Desccription_Template__c> allJobsDesTemp {get;set;}
            @AuraEnabled
            Public  List<Application__c> submitedApplicatons  {get;set;}
            @AuraEnabled
            Public List<Contact> tageCandidate  {get;set;}
            @AuraEnabled
            Public List<Job_Post__c> allPostedJobs  {get;set;}

        }

     @AuraEnabled
    Public static List<contact>  showTaggedCandidate(string jobReqId){
        system.debug('jobReqId---------'+jobReqId);
        List<Application__c>  RelatedApplicationsList=[SELECT Id,Name,Status_Summary_Line__c,Mandate__c,Is_Submitted__c,Job_Post__c,Last_Working_Day__c,Mandate_Start_Date__c,mandate_company_name__c,Contact__c,Origin__c,OwnerId,Status__c FROM Application__c WHERE Job_Post__c !=null and Job_Post__r.Job_Requisition__c=:jobReqId];
        List<String> ApplyiedCandidateId = new List<String>();
        for(Application__c App: RelatedApplicationsList){
            ApplyiedCandidateId.add(App.Contact__c);
        }

        List<contact> AppliedCandidateList=[SELECT AccountId,Anniversary_Date__c,AssistantName,AssistantPhone,Birthdate,Child_Master__c,Contact_Role__c,Course__c,Department,Description,Email,email_send__c,Father_Name__c,Fax,FirstName,Gender__c,hasCV__c,Higereducation__c,HomePhone,Id,IsEmailBounced,Is_Resource_Available__c,job_Area__c,Language__c,LastName,LinkedIn_URL__c,Login_Hash_Code__c,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MobilePhone,Name,Office_Country__c,Office_State__c,OtherAddress,OtherCity,OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,OwnerId,Password__c,Payment_Captured__c,Phone,PhotoUrl,RecordTypeId,ReportsToId,Role__c,Salutation,Status_Summary_Line__c,Status__c,Title,Total_Fee__c,Total_Leaves_Taken__c,Type__c,Aadhar__c FROM Contact WHERE Id In: ApplyiedCandidateId];
         system.debug('AppliedCandidateList---------'+AppliedCandidateList);
        return AppliedCandidateList;
    }

    @AuraEnabled
    public static void deleteSelectedContact(String contactId){
        System.debug('contactId----'+contactId);
        Contact deleteContact = new Contact();
        deleteContact.Id=contactId;
        System.debug('deleteContact----'+deleteContact);
        delete deleteContact;
    }

    @AuraEnabled
    public static void createApplicatiosForSelectedJobAndCandidate(List<String> selectedCandidatesId, string JobReqId){
        System.debug('selectedCandidatesId----'+selectedCandidatesId);
        System.debug('JobReqId----'+JobReqId);
        Job_Post__c relatedJobPost =[SELECT Id,Name,Job_Requisition__c,Job_Title__c,Partner__c,Partner_Name__c FROM Job_Post__c WHERE Job_Requisition__c=:JobReqId limit 1];

        List<Application__c> AppToBeInserted = new  List<Application__c>();
        for(string candidateId  :selectedCandidatesId){
            Application__c createApp = new Application__c();
            createApp.Contact__c=candidateId;
            createApp.Job_Post__c=relatedJobPost.Id;
            AppToBeInserted.add(createApp);
        }
        if(AppToBeInserted !=null){
            insert AppToBeInserted;
        }
       
    }

    @AuraEnabled
    Public static void updateCandidatesList(List<Contact> Contacts){
        System.debug('Contacts---'+Contacts);
        upsert Contacts;
    }

    @AuraEnabled
    Public static  List<Application__c>   viewSibmittedApplicsations(String JobReqId){
        System.debug('JobReqId---'+JobReqId);
        List<Application__c>  RelatedApplicationsList=[SELECT Id,Name,Status_Summary_Line__c,Mandate__c,Is_Submitted__c,Job_Post__c,Last_Working_Day__c,Mandate_Start_Date__c,mandate_company_name__c,Contact__c,Origin__c,OwnerId,Status__c,Job_Post__r.Name FROM Application__c WHERE Job_Post__c !=null and Job_Post__r.Job_Requisition__c=:jobReqId];
        System.debug('RelatedApplicationsList---'+RelatedApplicationsList);
        return RelatedApplicationsList;
    }
    @AuraEnabled
    Public static void updateApplications(List<Application__c> AppTobeUpdates){
        System.debug('AppTobeUpdates---'+AppTobeUpdates);  
        update AppTobeUpdates;

    }

    @AuraEnabled
    Public static List<contact>  showCandidate(string appId){
    List<Contact> AppliedCandidateList = [SELECT AccountId, Anniversary_Date__c, AssistantName, AssistantPhone, Birthdate, Child_Master__c, Contact_Role__c, Course__c, Department, Description, Email, email_send__c, Father_Name__c, Fax, FirstName, Gender__c, hasCV__c, Higereducation__c, HomePhone, Id, IsEmailBounced, Is_Resource_Available__c, job_Area__c, Language__c, LastName, LinkedIn_URL__c, Login_Hash_Code__c, MailingAddress, MailingCity, MailingCountry, MailingCountryCode, MailingGeocodeAccuracy, MailingLatitude, MailingLongitude, MailingPostalCode, MailingState, MailingStateCode, MailingStreet, MasterRecordId, MobilePhone, Name, Office_Country__c, Office_State__c, OtherAddress, OtherCity, OtherCountry, OtherCountryCode, OtherGeocodeAccuracy, OtherLatitude, OtherLongitude, OtherPhone, OtherPostalCode, OtherState, OtherStateCode, OtherStreet, OwnerId, Password__c, Payment_Captured__c, Phone, PhotoUrl, RecordTypeId, ReportsToId, Role__c, Salutation, Status_Summary_Line__c, Status__c, Title, Total_Fee__c, Total_Leaves_Taken__c, Type__c, Aadhar__c,(SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLinks LIMIT 1) 
                                       FROM Contact 
                                       WHERE Id IN (SELECT Contact__c FROM Application__c WHERE Id =: appId)];

    return AppliedCandidateList;
    }

    
    Public static void updateNumberOfApplicationOnJobReq(List<Application__c> newAppli){
        set<id> jobreqIds= new set<id> ();
        for(Application__c ap :newAppli){
            if(ap.Job_Post__r.Job_Requisition__c !=null){
                jobreqIds.add(ap.Job_Post__r.Job_Requisition__c );
            }
        }

        List<Mandate__c> alljobsList =[SELECT Amount_spent__c,Annual_CTC__c,Total_Application_Recevied__c,Approval_Status__c,Assignment_Status__c,Campus__c,Company__c,CreatedById,CreatedDate,Department__c,Designation_Master__c,Designation__c,Employment_Type__c,Experiance__c,Id,Industry_Types__c,Industry__c,IsDeleted,Job_Desccription_Template__c,Job_Desccription_Template__r.Description__c,Job_Function__c,Job_Status__c,Job_Title__c,Job_Type__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Location_Master__c,Location__c,Manager__c,Mandate_Company_Name__c,Mandate_End_Date__c,Mandate_Start_Date__c,Module__c,Name,Opening_Date__c,OwnerId,Qualification__c,Salary__c,Skill_Set__c,State__c,Status__c,Summary_Description__c,SystemModstamp,Target_Date__c,Time_Taken_for_job__c,Total_Candidates_Required__c,Work_Mode__c,Designation_Master__r.Name FROM Mandate__c WHERE Id In:jobreqIds];
        for(Mandate__c job :alljobsList){
            Decimal totalApp;
            
            List<Application__c> appList = [SELECT id,Name from Application__c where Job_Post__r.Job_Requisition__c =:job.Id];
            if(appList.size()>0){
                totalApp=appList.size();
            }
            job.Total_Application_Recevied__c=totalApp;
        }

    }

    Public static void TestUpdate(List<Application__c> newAppli){
        // Create a map to store the job ID and the total application count
        Map<Id, Decimal> jobToTotalAppMap = new Map<Id, Decimal>();

        for (Application__c ap : newAppli) {
            if (ap.Job_Post__r.Job_Requisition__c != null) {
                jobToTotalAppMap.put(ap.Job_Post__r.Job_Requisition__c, 0); // Initialize to 0
            }
        }

        // Query for the application count for each job
        for (AggregateResult result : [
            SELECT Job_Post__r.Job_Requisition__c jobId, COUNT(Id) totalAppCount
            FROM Application__c
            WHERE Job_Post__r.Job_Requisition__c IN :jobToTotalAppMap.keySet()
            GROUP BY Job_Post__r.Job_Requisition__c
        ]) {
            Id jobId = (Id)result.get('jobId');
            Decimal totalAppCount = (Decimal)result.get('totalAppCount');
            jobToTotalAppMap.put(jobId, totalAppCount);
        }

        // Update the Total_Application_Recevied__c field for each job
        List<Mandate__c> alljobsList =[SELECT Amount_spent__c,Annual_CTC__c,Total_Application_Recevied__c,Approval_Status__c,Assignment_Status__c,Campus__c,Company__c,CreatedById,CreatedDate,Department__c,Designation_Master__c,Designation__c,Employment_Type__c,Experiance__c,Id,Industry_Types__c,Industry__c,IsDeleted,Job_Desccription_Template__c,Job_Desccription_Template__r.Description__c,Job_Function__c,Job_Status__c,Job_Title__c,Job_Type__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Location_Master__c,Location__c,Manager__c,Mandate_Company_Name__c,Mandate_End_Date__c,Mandate_Start_Date__c,Module__c,Name,Opening_Date__c,OwnerId,Qualification__c,Salary__c,Skill_Set__c,State__c,Status__c,Summary_Description__c,SystemModstamp,Target_Date__c,Time_Taken_for_job__c,Total_Candidates_Required__c,Work_Mode__c,Designation_Master__r.Name FROM Mandate__c WHERE Id In:jobToTotalAppMap.keySet()];

        List<Mandate__c> jobsToUpdate = new List<Mandate__c>();
        for (Mandate__c job : alljobsList) {
            if (jobToTotalAppMap.containsKey(job.Id)) {
                job.Total_Application_Recevied__c = jobToTotalAppMap.get(job.Id);
                jobsToUpdate.add(job);
            }
        }

        if (!jobsToUpdate.isEmpty()) {
            update jobsToUpdate;
        }



    }

    
    @AuraEnabled
    Public static List<contact>  showRelCandidate(string jobReqId){
        set<id> candidtesId = new set<id> ();

        List<Job_Post__c> jobPosted =[SELECT Id,Name,Partner__c,Job_Requisition__c,(select id,Name,Contact__c FROM Job_Applications__r) from Job_Post__c WHERE Job_Requisition__c=:jobReqId ];
        for(Job_Post__c jb :jobPosted){
            for(Application__c app: jb.Job_Applications__r){
                if(app.contact__c !=Null){
                   candidtesId.add(app.contact__c); 
                }
            }
        }

        List<contact> AppliedCandidateList=[SELECT AccountId,Anniversary_Date__c,AssistantName,AssistantPhone,Birthdate,Child_Master__c,Contact_Role__c,Course__c,Department,Description,Email,email_send__c,Father_Name__c,Fax,FirstName,Gender__c,hasCV__c,Higereducation__c,HomePhone,Id,IsEmailBounced,Is_Resource_Available__c,job_Area__c,Language__c,LastName,LinkedIn_URL__c,Login_Hash_Code__c,MailingAddress,MailingCity,MailingCountry,MailingCountryCode,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStateCode,MailingStreet,MasterRecordId,MobilePhone,Name,Office_Country__c,Office_State__c,OtherAddress,OtherCity,OtherCountry,OtherCountryCode,OtherGeocodeAccuracy,OtherLatitude,OtherLongitude,OtherPhone,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,OwnerId,Password__c,Payment_Captured__c,Phone,PhotoUrl,RecordTypeId,ReportsToId,Role__c,Salutation,Status_Summary_Line__c,Status__c,Title,Total_Fee__c,Total_Leaves_Taken__c,Type__c,Aadhar__c FROM Contact WHERE Id In: candidtesId];
        system.debug('AppliedCandidateList---'+AppliedCandidateList);
        return AppliedCandidateList;

    }



    @AuraEnabled
    public static List<Contact> searchContacts(String searchTerm) {
        string likename= '%'+ searchTerm + '%';
        // Define the SOQL query to search for Contacts matching the searchTerm
        String query = 'SELECT Id, Name FROM Contact WHERE Name LIKE :likename LIMIT 10';
        // Perform the SOQL query
        return Database.query(query);
    }

    @AuraEnabled
    Public static void acceptRejectCandidate(string conId,String status){
        System.debug('conId---'+conId);
        System.debug('status---'+status);
        contact updatecon = new contact();
        updatecon.Id=conId;
        if(status=='accept'){
             updatecon.Status_Summary_Line__c='Under Interview';
        }else if(status=='reject'){
            updatecon.Status_Summary_Line__c='Rejected';
        }

        update updatecon;
       


    }

    @AuraEnabled(cacheable=true)
    public static  List<Interview__c>  showPreviousInt(string conId){
        System.debug('conId---'+conId);
        List<Interview__c> previousIntd =[SELECT id,Name,Start_Date_Time__c,End_Date_Time__c,Type__c,Round__c,Candidate__c FROM Interview__C WHERE Candidate__c =:conId];
        System.debug('previousIntd---'+previousIntd);
        return previousIntd;

    }


    

}