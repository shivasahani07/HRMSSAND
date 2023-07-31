public class PE_ModelClass {
    
    public class PEQunWrapper{
        @AuraEnabled
        public string fieldTyp          {get;set;}
        @AuraEnabled
        public string picklistTy        {get;set;}
        @AuraEnabled
        public String[] picklistVal     {get;set;}
        @AuraEnabled
        public string fieldName         {get;set;}
        @AuraEnabled
        public string response          {get;set;}
        @AuraEnabled
        public string qunLineItemId 	{get;set;}
        @AuraEnabled
        public boolean isMandatory 		{get;set;}
        @AuraEnabled
        public string qunType 			{get;set;}
        
        public peQunWrapper(String qunItemId,String fieldType,String picklistType,String[] picklistValues,String fieldLabel,boolean isRequired,string qunSection){
            
            String defaultPickListVal = '';            
            qunLineItemId = qunItemId;
            if(fieldType == 'Descriptive'){
                fieldTyp = 'Desc';
            }else if(fieldType == 'Descriptive(Long)'){
                fieldTyp = 'DescLong';
            }else if(fieldType == 'Select List' && picklistType == 'Single'){
                fieldTyp = 'picklist';
            }else if(fieldType == 'Select List' && picklistType == 'Multi-Select'){
                fieldTyp = 'multipicklist';
            } 
            picklistTy  = picklistType;
            picklistVal = picklistValues;
            fieldName   = fieldLabel;
            isMandatory = isRequired;
            if(qunSection == 'Soft Skills'){
                qunType = 'sSkills';
            }else{
                qunType     = qunSection;
            }
            
            response = '';
        }  
    }
    
    public class PEResponseWrapper{
        @AuraEnabled
        public string fieldTyp          		{get;set;}
        @AuraEnabled
        public string picklistTy        		{get;set;}
        @AuraEnabled
        public String[] picklistVal     		{get;set;}
        @AuraEnabled
        public string fieldName         		{get; set;}
        @AuraEnabled
        public string response          		{get;set;}
        @AuraEnabled
        public string qunLineItemId 			{get;set;}
        @AuraEnabled
        public boolean isMandatory 				{get;set;}
        @AuraEnabled
        public string qunType 					{get;set;}
        @AuraEnabled
        public string peStatus 					{get;set;}
        @AuraEnabled
        public string feedbackLineItemId		{get;set;}
        @AuraEnabled
        public List<String> selectedMulPickVals {get;set;}
           @AuraEnabled
        public Date CloseDateOfPE {get;set;}
        
        
        
        public peResponseWrapper(String feedbacklineItemid,String qunItemId,String fieldType,String picklistType,String[] picklistValues,List<String> selectedmulVal,String fieldLabel,boolean isRequired,string qunSection,string ans,string status,Date CloseDate ){
             System.debug('@@@'+qunSection);
            this.feedbackLineItemId = feedbacklineItemid;
            qunLineItemId = qunItemId;
            if(fieldType == 'Descriptive'){
                fieldTyp = 'Desc';
            }else if(fieldType == 'Descriptive(Long)'){
                fieldTyp = 'DescLong';
            }else if(fieldType == 'Select List' && picklistType == 'Single'){
                fieldTyp = 'picklist';
            }else if(fieldType == 'Select List' && picklistType == 'Multi-Select'){
                fieldTyp = 'multipicklist';
            }
            picklistTy  = picklistType;
            picklistVal = picklistValues;
            fieldName   = fieldLabel;
            isMandatory = isRequired;
           
            if(qunSection == 'Soft Skills'){
                qunType = 'sSkills';
            }else if(qunSection == 'Project Contribution'){
                 qunType = 'projectCon';
            }else if(qunSection =='Competency/ Technical Skills'){
                 qunType = 'techSkill';
            }else if(qunSection == 'General'){
                 qunType = 'General';
            }else{
                qunType = qunSection;
            } 
            response = ans;
            peStatus = status;
            selectedMulPickVals = selectedmulVal;
            CloseDateOfPE =CloseDate;
            
            
        }
    }
    
    public class PELineItemWrapper{
        @AuraEnabled
        public List<PEResponseWrapper> responseWrapper {get;set;}
        @AuraEnabled
        public List<PEQunWrapper> pequnListWrapper{get;set;}
        @AuraEnabled
        public string feedbackStatus { get;set;}
         @AuraEnabled
        public Date CloseDate { get;set;}
        
    }


    public class PEfeedbackLineItemWrapper{
        @AuraEnabled
        public String questionName {get;set;}
        @AuraEnabled
        public string answer       {get;set;}
        @AuraEnabled
        public string lineItemId {get;set;}
    }

    public class FeedbackStatusWrapper{
        @AuraEnabled
        public string feedbackStatus {get;set;}
        @AuraEnabled
        public string backgroundColor {get;set;}
    }
    

    public class PEFeedbackToOthersWrapper{
        @AuraEnabled
        public string userName {get;set;}
        @AuraEnabled
        public string userId {get;set;}
        @AuraEnabled
        public string feedbackId{get;set;}
        @AuraEnabled
        public string feedbackStatus{get;set;}
        @AuraEnabled
        public string redirectUrl{get;set;}
        @AuraEnabled
        public List<PE_Feedback_Item__c> feedbackLineItemList{get;set;}

    }

    public class PEFeedbackLineItemAcccRecTypeWrapper{
        @AuraEnabled
        public string recordTypeName{get;set;}
        @AuraEnabled
        public List<PE_Feedback_Item__c> feedBackItemList{get;set;}

        public PEFeedbackLineItemAcccRecTypeWrapper(String recordTyeName,List<PE_Feedback_Item__c> feedbacks){
            this.recordTypeName     = recordTyeName;
            this.feedBackItemList   = feedbacks.clone();
        }

    }


    public class SectionWiseWrapper{
        @AuraEnabled
        public string sectionType{get;set;}
        @AuraEnabled
        public List<PE_Feedback_Item__c> feedBackItemList{get;set;}

        /*public sectionWiseWrapper(String sectionType,List<PE_Feedback_Item__c> feedBackItemList){
            this.sectionType        = sectionType;
            this.feedBackItemList   = feedBackItemList;
        }*/
    }

    public class StatusWithUserWrapper{
        @AuraEnabled
        public string feedbackStatus {get;set;}
        @AuraEnabled
        public  List<User> userDetails {get;set;}
    }
    
}