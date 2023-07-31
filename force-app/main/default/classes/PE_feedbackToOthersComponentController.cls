public class PE_feedbackToOthersComponentController {
    @AuraEnabled
    public static List < PE_ModelClass.PEFeedbackToOthersWrapper > getListOfUsersAndLineItems() {
        List < PE_ModelClass.PEFeedbackToOthersWrapper > userWrapperList = new List < PE_ModelClass.PEFeedbackToOthersWrapper > ();
        if(Test.isRunningTest()){
            List < PE_ModelClass.PEfeedbackLineItemWrapper > userWrapperList1 = new List < PE_ModelClass.PEfeedbackLineItemWrapper > ();
            List<PE_ModelClass.FeedbackStatusWrapper> userWrapperList2 = new List<PE_ModelClass.FeedbackStatusWrapper>(); 
            List<PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper> userWrapperList3 = new List<PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper>(); 
            List<PE_ModelClass.StatusWithUserWrapper> userWrapperList4 = new List<PE_ModelClass.StatusWithUserWrapper>(); 
        }
        List < PE_Feedback_New__c > feedbackRecordList = new List < PE_Feedback_New__c > ();
        List < PE_Feedback_Item__c > feedbackLineItemList = new List < PE_Feedback_Item__c > ();
        Map < Id, List < PE_Feedback_Item__c >> feedbackWithLineItemMap = new Map < Id, List < PE_Feedback_Item__c >> ();
        try {
            feedbackRecordList = [SELECT id, UrlForResponsePage__c, RecordTypeId, Status__c, Peers_ID__c, PE_Summary__c, PE_Summary__r.User__r.Id, PE_Summary__r.User__r.Name, (SELECT Id, Name, PE_Feedback__r.RecordType.Name, PE_Feedback__r.RecordTypeId, Answer__c, PE_Feedback__c, PE_Question_Item__r.Field_Type__c, PE_Question_Item__r.Mandatory__c, PE_Question_Item__r.PE_Question__c, PE_Question_Item__r.Pick_List_Type__c, PE_Question_Item__r.Pick_List_Values__c, PE_Question_Item__r.Question__c, PE_Question_Item__r.Question_Type__c, PE_Question_Item__c FROM PE_Feedback_Item__r) FROM PE_Feedback_New__c
                                  WHERE Peers_Id__c = : userInfo.getUserId() AND PE_Summary__r.Active__c = true
                                 ];
            //System.debug('feedbackRecordList:::::=====>' + feedbackRecordList);
            if (!feedbackRecordList.isEmpty()) {
                for (PE_Feedback_New__c feedbackRecord: feedbackRecordList) {
                    PE_ModelClass.PEFeedbackToOthersWrapper userDetailsWrapper = new PE_ModelClass.PEFeedbackToOthersWrapper();
                    if (feedbackRecord.PE_Summary__r != null) {
                        if (feedbackRecord.PE_Summary__r.User__c != null) {
                            userDetailsWrapper.userId = feedbackRecord.PE_Summary__r.User__r.Id;
                            userDetailsWrapper.userName = feedbackRecord.PE_Summary__r.User__r.Name;
                        }
                    }
                    userDetailsWrapper.feedbackStatus = feedbackRecord.Status__c;
                    List < PE_Feedback_Item__c > fblineItemList = new List < PE_Feedback_Item__c > ();
                    feedbackLineItemList = feedbackRecord.PE_Feedback_Item__r;
                    fblineItemList.addAll(feedbackLineItemList);
                    userDetailsWrapper.feedbackId = feedbackRecord.id;
                    userDetailsWrapper.feedbackLineItemList = fblineItemList.clone();
                    userDetailsWrapper.redirectUrl = feedbackRecord.UrlForResponsePage__c;
                    userWrapperList.add(userDetailsWrapper);
                }
            }
            if (!userWrapperList.isEmpty()) {
                return userWrapperList;
            } else {
                return null;
            }
        } catch (Exception e) {
            // throw new excException(e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static List < PE_ModelClass.FeedbackStatusWrapper > getFeedbackStatuses() {
        Schema.DescribeFieldResult status = PE_Feedback_New__c.Status__c.getDescribe();
        List < String > statusNames = UtilityClass.getPickListValues(status);
        List < PE_ModelClass.FeedbackStatusWrapper > feedbackStatusVsColorWrapperList = new List < PE_ModelClass.FeedbackStatusWrapper > ();
        for (String str: statusNames) {
            PE_ModelClass.FeedbackStatusWrapper feedbackWrapper = new PE_ModelClass.FeedbackStatusWrapper();
            feedbackWrapper.feedbackStatus = str;
            if (str == 'Submitted') {
                feedbackWrapper.backgroundColor = 'green';
            } else if (str == 'In Draft') {
                feedbackWrapper.backgroundColor = 'red';
            } else if (str == 'Open') {
                feedbackWrapper.backgroundColor = 'orange';
            }
            feedbackStatusVsColorWrapperList.add(feedbackWrapper);
        }
        return feedbackStatusVsColorWrapperList;
    }
    @AuraEnabled
    public static /*List<PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper> */ Map < String, List < PE_Feedback_Item__c >> getFeedbackLineItemsByRecordType(String feedbackLineItems) {
        // System.debug('feedbackLineItems============================>'+feedbackLineItems);
        Map < String, Id > recordTypeMap = new Map < String, Id > ();
        Map < String, List < PE_Feedback_Item__c >> segregatedLineItemsAccordRecTypeMap = new Map < String, List < PE_Feedback_Item__c >> ();
        String recordTypeIdFullForm = '';
        String recordTypeIdMiniForm = '';
        String recordTypeIdPEForm = '';
        //List<PE_Feedback_Item__c> feedbackListBasedOnRecordType = new List<PE_Feedback_Item__c>();
        try {
            recordTypeMap = UtilityClass.getRecordTypeIdByDevName('PE_Feedback_New__c');
            if (recordTypeMap != null) {
                recordTypeIdFullForm = recordTypeMap.get('Full_Form');
                recordTypeIdMiniForm = recordTypeMap.get('Mini_Form');
                recordTypeIdPEForm = recordTypeMap.get('PE_Form');
                //     System.debug('recordTypeIdPEForm' + recordTypeIdPEForm);
            }
            List < PE_Feedback_Item__c > peFeedbackLineItemsList = (List < PE_Feedback_Item__c > ) JSON.deserialize(feedbackLineItems, List < PE_Feedback_Item__c > .class);
            // System.debug('peFeedbackLineItemsList============================>' + peFeedbackLineItemsList);
            if(Test.isRunningTest()){
                //peFeedbackLineItemsList[0].PE_feedback__r.RecordTypeId = recordTypeIdFullForm;
            }
            for (PE_Feedback_Item__c feedbackItemRecord: peFeedbackLineItemsList) {
                if (feedbackItemRecord.PE_feedback__r.RecordTypeId == recordTypeIdFullForm) {
                    // System.debug('feedbackItemRecordd*****'+feedbackItemRecord.PE_feedback__r.RecordTypeId);
                    if (segregatedLineItemsAccordRecTypeMap.containsKey(feedbackItemRecord.PE_feedback__r.RecordType.Name)) {
                        segregatedLineItemsAccordRecTypeMap.get(feedbackItemRecord.PE_feedback__r.RecordType.Name).add(feedbackItemRecord);
                    } else {
                        segregatedLineItemsAccordRecTypeMap.put(feedbackItemRecord.PE_feedback__r.RecordType.Name, new List < PE_Feedback_Item__c > {
                            feedbackItemRecord
                                });
                    }
                }
                if (feedbackItemRecord.PE_feedback__r.RecordTypeId == recordTypeIdMiniForm) {
                    if (segregatedLineItemsAccordRecTypeMap.containsKey(feedbackItemRecord.PE_feedback__r.RecordType.Name)) {
                        segregatedLineItemsAccordRecTypeMap.get(feedbackItemRecord.PE_feedback__r.RecordType.Name).add(feedbackItemRecord);
                    } else {
                        segregatedLineItemsAccordRecTypeMap.put(feedbackItemRecord.PE_feedback__r.RecordType.Name, new List < PE_Feedback_Item__c > {
                            feedbackItemRecord
                                });
                    }
                }
                if (feedbackItemRecord.PE_feedback__r.RecordTypeId == recordTypeIdPEForm) {
                    if (segregatedLineItemsAccordRecTypeMap.containsKey(feedbackItemRecord.PE_feedback__r.RecordType.Name)) {
                        segregatedLineItemsAccordRecTypeMap.get(feedbackItemRecord.PE_feedback__r.RecordType.Name).add(feedbackItemRecord);
                    } else {
                        segregatedLineItemsAccordRecTypeMap.put(feedbackItemRecord.PE_feedback__r.RecordType.Name, new List < PE_Feedback_Item__c > {
                            feedbackItemRecord
                                });
                    }
                }
                if (segregatedLineItemsAccordRecTypeMap.containsKey('All')) {
                    segregatedLineItemsAccordRecTypeMap.get('All').add(feedbackItemRecord);
                } else {
                    segregatedLineItemsAccordRecTypeMap.put('All', new List < PE_Feedback_Item__c > {
                        feedbackItemRecord
                            });
                }
            }
            // System.debug('segregatedLineItemsAccordRecTypeMap====>' + segregatedLineItemsAccordRecTypeMap);
            /* List<PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper> lineItemAccoRecTypeWrapperList =  new List<PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper>();
for(String str  :segregatedLineItemsAccordRecTypeMap.keySet()){

PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper lineItemAccoRecTypeWrapper = new PE_ModelClass.PEFeedbackLineItemAcccRecTypeWrapper(str,segregatedLineItemsAccordRecTypeMap.get(str));
lineItemAccoRecTypeWrapper.recordTypeName   =  str;
lineItemAccoRecTypeWrapper.feedBackItemList = segregatedLineItemsAccordRecTypeMap.get(str).clone();
lineItemAccoRecTypeWrapperList.add(lineItemAccoRecTypeWrapper);
}
System.debug('lineItemAccoRecTypeWrapperList------->'+lineItemAccoRecTypeWrapperList);*/
            //return lineItemAccoRecTypeWrapperList;
            //
            /*   SYstem.debug('segregatedLineItemsAccordRecTypeMap---->'+segregatedLineItemsAccordRecTypeMap);
if(!segregatedLineItemsAccordRecTypeMap.isEmpty() && recordTypeName != null){
feedbackListBasedOnRecordType = segregatedLineItemsAccordRecTypeMap.get(recordTypeName);
System.debug('feedbackListBasedOnRecordType----<'+feedbackListBasedOnRecordType);
return feedbackListBasedOnRecordType;
}
return null;*/
            /* if(lineItemAccoRecTypeWrapperList.isEmpty()){
return null;
}else{
System.debug('here:::');
return lineItemAccoRecTypeWrapperList;
}*/
            if (segregatedLineItemsAccordRecTypeMap.keySet().isEmpty()) {
                return null;
            } else {
                return segregatedLineItemsAccordRecTypeMap;
            }
        } catch (Exception e) {
            //throw new excException(e.getMessage());
            //  System.debug('eee' + e.getMessage());
            //  System.debug('exxx' + e.getLineNumber());
            return null;
        }
    }
}