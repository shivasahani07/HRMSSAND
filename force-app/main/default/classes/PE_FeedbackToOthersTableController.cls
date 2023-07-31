public class PE_FeedbackToOthersTableController {
   @AuraEnabled
   public static List<PE_ModelClass.SectionWiseWrapper> getfbLineItemSectionWiseWrapperList(String flItems){
   List<PE_ModelClass.SectionWiseWrapper> sectionWiseWrapperList = new List<PE_ModelClass.SectionWiseWrapper>();

   try{
       // System.debug('flItems=====>'+flItems);
        List<PE_Feedback_Item__c> peFeedbackLineItemsList = (List<PE_Feedback_Item__c>)JSON.deserialize(flItems, List<PE_Feedback_Item__c>.class);
        Map<String,List<PE_Feedback_Item__c>> sectionWiseFeeddbackItemMap = new Map<String,List<PE_Feedback_Item__c>>();

        for(PE_Feedback_Item__c feedbackItem : peFeedbackLineItemsList ){
                if(sectionWiseFeeddbackItemMap.containsKey(feedbackItem.PE_Question_Item__r.Question_Type__c)){
                    sectionWiseFeeddbackItemMap.get(feedbackItem.PE_Question_Item__r.Question_Type__c).add(feedbackItem);
                }else{
                     sectionWiseFeeddbackItemMap.put(feedbackItem.PE_Question_Item__r.Question_Type__c,new List<PE_Feedback_Item__c> {feedbackItem});
                }
        }

        if(!sectionWiseFeeddbackItemMap.isEmpty()){
            for(String str : sectionWiseFeeddbackItemMap.keySet() ){
                PE_ModelClass.SectionWiseWrapper sectionWrapper =  new PE_ModelClass.SectionWiseWrapper();
                sectionWrapper.sectionType          = str;
                sectionWrapper.feedBackItemList     = sectionWiseFeeddbackItemMap.get(str).clone();
                sectionWiseWrapperList.add(sectionWrapper);
            }
            return sectionWiseWrapperList;
            }else{
                return null;
            }




    }catch(Exception e){
    //    throw new excException();
    return null;
    }

    
   }
       
}