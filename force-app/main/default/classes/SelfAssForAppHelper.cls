public without sharing class SelfAssForAppHelper {
    @AuraEnabled(cacheable=true)
    public static List<List<Sobject>> SelfAssesmentValues(String mandateRecId){
        
        List<List<Sobject>> QuestionData = new List<List<Sobject>>();
        List<Self_Assesment__c > selfAssList =  [select English__c,French__c,Assignment_Research__c from Self_Assesment__c  where Assignment_Research__c =: mandateRecId ];
        List<Self_Assessment__c> customSettingData = [select name,French__c from Self_Assessment__c];
        List<Self_Assesment_Response__c> sarList = new List<Self_Assesment_Response__c>();
        
        List<String> SelfAssessmentData = new List<String>();
        SelfAssessmentData.add('What are my greatest strengths and how have they contributed to my success in my current role?');
        SelfAssessmentData.add('What areas of my work do I feel most confident and skilled in? How have I demonstrated expertise in these areas?');
        SelfAssessmentData.add('What accomplishments or achievements am I most proud of in my career? How did I contribute to those successes?');
        SelfAssessmentData.add('What are some challenges or obstacles I have faced in my work? How did I overcome them, and what did I learn from those experiences?');
        SelfAssessmentData.add('How do I handle feedback and criticism? How have I used feedback to improve my skills and performance?');
        
        List<String> TechAssessmentData = new List<String>();
        TechAssessmentData.add('What strategies would you use to integrate technology into your classroom instruction effectively?');
        TechAssessmentData.add('How would you differentiate instruction to meet the diverse learning needs of students in your classroom?');
        TechAssessmentData.add('Describe your approach to assessing student progress and providing feedback.');
        TechAssessmentData.add('How would you promote a positive and inclusive classroom environment that respects diversity?');
        TechAssessmentData.add('How would you handle a challenging or disruptive behavior from a student in your class?');
        
        if(selfAssList.size()>0){
            for(Self_Assesment__c self:selfAssList){
                sarList.add(new Self_Assesment_Response__c(Question_name__c = self.English__c,Response__c = ''));
            }    
        }else{
            for(String sa :SelfAssessmentData){
                sarList.add(new Self_Assesment_Response__c(Question_name__c = sa,Response__c = ''));
            } 
        }
        system.debug('sarList'+sarList);
        system.debug('selfAssList'+selfAssList);
        List<One_Pager__c > onePagerList =  [select English__c,French__c,Mandate__c  from One_Pager__c  where Mandate__c  =: mandateRecId ];
        List<One_Pager_Values__c> customSettingDataOpr = [select name,French__c from One_Pager_Values__c];
        List<One_Pager_Response__c> oprList = new List<One_Pager_Response__c>();
        
        if(onePagerList.size()>0){
            for(One_Pager__c self:onePagerList){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = self.English__c,Response__c = ''));
            }    
        }else{
            for(String sa :TechAssessmentData){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = sa,Response__c = ''));
            } 
        }
        system.debug('oprList'+oprList);
        system.debug('onePagerList'+onePagerList);
        
        
        QuestionData.add(sarList);
        QuestionData.add(oprList);
        
        return  QuestionData;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static list<One_Pager_Response__c> OnePagerValues(String mandateRecId){
        
        List<One_Pager__c > onePagerList =  [select English__c,French__c,Mandate__c  from One_Pager__c  where Mandate__c  =: mandateRecId ];
        List<One_Pager_Values__c> customSettingData = [select name,French__c from One_Pager_Values__c];
        List<One_Pager_Response__c> oprList = new List<One_Pager_Response__c>();
        
        if(onePagerList.size()>0){
            for(One_Pager__c self:onePagerList){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = self.English__c,Response__c = ''));
            }    
        }else{
            for(One_Pager_Values__c sa :customSettingData){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = sa.Name,Response__c = ''));
            } 
        }
        system.debug('oprList'+oprList);
        system.debug('onePagerList'+onePagerList);
        return  oprList;
        
    }
    
    @AuraEnabled
    public static String SelfAssesmentResCreation(list<Self_Assesment_Response__c> selfAssRes){
        system.debug('selfAssRes'+selfAssRes);
        List<Self_Assesment_Response__c> sarList = new List<Self_Assesment_Response__c>();
        system.debug(limits.getDmlRows());
        if(selfAssRes.size() > 0){
            try{
                insert selfAssRes;   
                system.debug('error-recID'+selfAssRes[0].Id); 
            }catch(exception e){
                system.debug('error'+e.getMessage());    
            }
        }
        return 'Success';
    }
    @AuraEnabled
    public static String OnePagerResCreation(list<One_Pager_Response__c> onePagerRes){
        system.debug('onePagerRes'+onePagerRes.size());
        List<One_Pager_Response__c> sarList = new List<One_Pager_Response__c>();
        system.debug(limits.getDmlRows());
        if(onePagerRes.size() > 0){
            try{
                insert onePagerRes;   
                system.debug('OPR-recID'+onePagerRes[0].Id); 
            }catch(exception e){
                system.debug('error'+e.getMessage());    
            }
        }
        return 'Success';
    }
    
    @AuraEnabled
    public static String insertWorkExperienceData(list<Work_Experience__c> WorkExperienceData,String conid){
        
        system.debug('WorkExperienceData'+WorkExperienceData+'Contact Id'+conid);
        List<Work_Experience__c> WorkExperienceListToBeUpdated = new List<Work_Experience__c>();
        system.debug(limits.getDmlRows());
        if(WorkExperienceData.size() > 0){
            try{
                for(Work_Experience__c we: WorkExperienceData){
                    Work_Experience__c work = new Work_Experience__c();
                    work.Company__c = we.Company__c;
                    work.Contact__c = conid;
                    work.Title__c = we.Title__c;
                    work.Start_Year__c = we.Start_Year__c;
                    work.End_Year__c = we.End_Year__c;
                    WorkExperienceListToBeUpdated.add(work);
                }
                system.debug('WorkExperienceListToBeUpdated'+WorkExperienceListToBeUpdated); 
                upsert WorkExperienceListToBeUpdated;
                system.debug('WorkExperienceListToBeUpdated'+WorkExperienceListToBeUpdated[0].Id); 
            }catch(exception e){
                system.debug('error'+e.getMessage());    
            }
        }
        return 'Success';
    }
}