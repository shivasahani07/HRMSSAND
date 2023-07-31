public class DataDisplayController {
    
    public  static String IntervalName{get;set;}
    public  static String userName{get;set;}
    public String recId =  System.currentPageReference().getParameters().get('id');
    public Map <String, List<String>> values{get;set;}
    public Set<String> keys {get ; set;}
    
    public  DataDisplayController() {
        
        //recId=  '0052v00000jEDHOAA4';
        userName = UserInfo.getName();
        /*  if (Cache.Session.contains('PECache')) {

String  wraplist = ( String  ) Cache.Session.get('PECache');
system.debug('wraplist -- ' + wraplist);

List<String> parameterlist = wraplist.split(',');
IntervalName = [Select id,name from PE_Intervals__c where id=:parameterlist[0]].Name;
values =  getPEFeedBackfromSF(parameterlist[0], parameterlist[1], parameterlist[2]);
keys = values.keySet();
if(!keys.isEmpty() && !values.isEmpty()){
Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=PE_Feedback_'+UserInfo.getName()+'_for_cycle_'+IntervalName+'_.pdf');
}

}*/
        PE_Intervals__c peInterval = [SELECT Id, Name FROM PE_Intervals__c WHERE CALENDAR_YEAR(Start_Date__c) = : Date.Today().year() LIMIT 1];
        IntervalName = peInterval.Name;
        Summary__c sum = [SELECT Id FROM Summary__c WHERE User__c =: recId AND Active__c = true LIMIT 1];
        values =  getPEFeedBackfromSF(peInterval.Id, sum.Id, 'PE Form');
        keys = values.keySet();
        /*if(!keys.isEmpty() && !values.isEmpty()){
Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=PE_Feedback_'+UserInfo.getName()+'_for_cycle_'+IntervalName+'_.pdf');
}*/
    }
    
    
    /* @RemoteAction
public static Map < String, List < String >> getTypeCast(String interval_id,String summary_Id,String recordType){
System.debug(interval_id+' ---'+ summary_Id+'-----'+ recordType);
Cache.Session.remove('PECache');
String parameters = interval_id+','+summary_Id+','+recordType;
Cache.Session.put('PECache', parameters);


return null; 
}*/
    
    
    public static Map < String, List < String >> getPEFeedBackfromSF(String intervalID, String SummaryId, String peRecordtypeName) {
        System.debug(intervalID + ' === ' + SummaryId + ' === ' + peRecordtypeName);
        List < PE_Feedback_New__c > listofFeedbackforQuarter = new List < PE_Feedback_New__c > ();
        if (peRecordtypeName == 'None') {
            listofFeedbackforQuarter.addAll([SELECT ID, Name, Peers_ID__c, RecordTypeID, RecordType.Name, PE_Summary__c, PE_Summary__r.Name, Status__c, Users_Role__c FROM PE_Feedback_New__c WHERE Status__c = 'Submitted'
                                             AND PE_Summary__c =: SummaryId AND PE_Summary__r.PE_Intervals__c =: intervalID
                                            ]);
        } else {
            listofFeedbackforQuarter.addAll([SELECT ID, Name, Peers_ID__c, RecordTypeID, RecordType.Name, PE_Summary__c, PE_Summary__r.Name, Status__c, Users_Role__c FROM PE_Feedback_New__c WHERE Status__c = 'Submitted'
                                             AND PE_Summary__c =: SummaryId AND Recordtype.Name =: peRecordtypeName AND PE_Summary__r.PE_Intervals__c =: intervalID
                                            ]);
        }
        System.debug('listofFeedbackforQuarter -- ' + listofFeedbackforQuarter);
        Set < ID > feedbackIdSet = new Set < ID > ();
        for (PE_Feedback_New__c fb: listofFeedbackforQuarter) {
            feedbackIdSet.add(fb.Id);
        }
        
        Map < String, String > questType = new Map < String, String > ();
        Map < String, Integer > questTypeCount = new Map < String, Integer > ();
        List < PE_Feedback_Item__c > listFeedbackLineItems = [SELECT ID, Name, Answer__c, PE_Feedback__c, PE_Question_Item__c, PE_Question_Item__r.Name, PE_Question_Item__r.Question__c, PE_Question_Item__r.Field_Type__c, PE_Question_Item__r.Pick_List_Type__c FROM PE_Feedback_Item__c WHERE PE_Feedback__c IN: feedbackIdSet];
        //logic start for formatter
        Map < String, List < Map < String, Integer >>> peQuestMap = new Map < String, List < Map < String, Integer >>> ();
        Map < String, List < Map < String, Integer >>> peQuestMapCopy = new Map < String, List < Map < String, Integer >>> ();
        // System.debug('&&&listFeedbackLineItems&&' + listFeedbackLineItems);
        for (PE_Feedback_Item__c peItem: listFeedbackLineItems) {
            if (peItem.Answer__c != null) {
                if (!peQuestMap.containsKey(peItem.PE_Question_Item__r.Question__c)) {
                    //map for question and type
                    questType.put(peItem.PE_Question_Item__r.Question__c, peItem.PE_Question_Item__r.Field_Type__c + '_' + peItem.PE_Question_Item__r.Pick_List_Type__c);
                    //getting each question count for % calculation
                    questTypeCount.put(peItem.PE_Question_Item__r.Question__c, 1);
                    
                    if (peItem.PE_Question_Item__r.Field_Type__c == 'Select List' && peItem.PE_Question_Item__r.Pick_List_Type__c == 'Multi-Select' && peItem.Answer__c.contains(',')) {
                        String[] techAnswer = peItem.Answer__c.split(',');
                        //System.debug(techAnswer);
                        for (String tech: techAnswer) {
                            if (!peQuestMap.containsKey(peItem.PE_Question_Item__r.Question__c)) {
                                peQuestMap.put(peItem.PE_Question_Item__r.Question__c, new List < Map < String, Integer >> {
                                    new Map < String,
                                        Integer > {
                                            tech => 1
                                                }
                                });
                            } else {
                                peQuestMap.get(peItem.PE_Question_Item__r.Question__c).add(new Map < String, Integer > {
                                    tech => 1
                                        });
                            }
                        }
                    } else if (peItem.PE_Question_Item__r.Field_Type__c == 'Select List' && peItem.PE_Question_Item__r.Pick_List_Type__c == 'Single') {
                        peQuestMap.put(peItem.PE_Question_Item__r.Question__c, new List < Map < String, Integer >> {
                            new Map < String,
                                Integer > {
                                    peItem.Answer__c => 1
                                        }
                        });
                    } else if (peItem.PE_Question_Item__r.Field_Type__c == 'Descriptive' && peItem.PE_Question_Item__r.Pick_List_Type__c == null) {
                        peQuestMap.put(peItem.PE_Question_Item__r.Question__c, new List < Map < String, Integer >> {
                            new Map < String,
                                Integer > {
                                    peItem.Answer__c => 1
                                        }
                        });
                    } else if (peItem.PE_Question_Item__r.Field_Type__c == 'Descriptive(Long)' && peItem.PE_Question_Item__r.Pick_List_Type__c == null) {
                        peQuestMap.put(peItem.PE_Question_Item__r.Question__c, new List < Map < String, Integer >> {
                            new Map < String,
                                Integer > {
                                    peItem.Answer__c => 1
                                        }
                        });
                    }
                    //System.debug('tempList1 :::: '+tempList1);
                    //peQuestMapCopy  = new Map<String, List<Map<String,Integer>>>(peQuestMap);
                } else {
                    Integer cnty = questTypeCount.get(peItem.PE_Question_Item__r.Question__c);
                    cnty += 1;
                    questTypeCount.put(peItem.PE_Question_Item__r.Question__c, cnty);
                    if (peItem.PE_Question_Item__r.Field_Type__c == 'Select List' && peItem.PE_Question_Item__r.Pick_List_Type__c == 'Multi-Select' && peItem.Answer__c.contains(',')) {
                        String[] techAnswer = peItem.Answer__c.split(',');
                        //System.debug(techAnswer);
                        for (String tech: techAnswer) {
                            //System.debug(tech);
                            if (peQuestMap.containsKey(peItem.PE_Question_Item__r.Question__c)) {
                                List < Map < String, Integer >> tempList1 = new List < Map < String, Integer >> ();
                                for (Map < String, Integer > sObj: peQuestMap.get(peItem.PE_Question_Item__r.Question__c)) {
                                    //System.debug(peItem);
                                    //System.debug(sObj);
                                    if (sObj.containsKey(tech)) {
                                        //System.debug(tech+  ' --if ::: '+sObj.get(tech));
                                        tempList1.add(new Map < String, Integer > {
                                            tech => sObj.get(tech) + 1
                                                });
                                    } else {
                                        //System.debug('Else ::: '+sObj);
                                        tempList1.add(sObj);
                                    }
                                    //System.debug(tempList1);
                                }
                                peQuestMapCopy.put(peItem.PE_Question_Item__r.Question__c, tempList1);
                                peQuestMap.get(peItem.PE_Question_Item__r.Question__c).add(new Map < String, Integer > {
                                    tech => 1
                                        });
                            }
                        }
                    } else {
                        Map < String, Integer > tempMap = new Map < String, Integer > {
                            peItem.Answer__c => 1
                                };
                                    peQuestMap.get(peItem.PE_Question_Item__r.Question__c).add(tempMap);
                    }
                }
            }
        }
        //System.debug(questTypeCount);
        //System.debug(questType);
        //System.debug(peQuestMap);
        Map < String, Map < String, Integer >> peQuestMapFinal = new Map < String, Map < String, Integer >> ();
        Map < String, List < String >> peQuestMapFinalList = new Map < String, List < String >> ();
        for (String questKey: peQuestMap.keySet()) {
            
            //System.debug(questKey);
            //System.debug(peQuestMap.get(questKey));
            
            List < Map < String, Integer >> tempList = new List < Map < String, Integer >> ();
            Map < String, Integer > tempMap = new Map < String, Integer > ();
            Boolean nokeyMapFlag = false;
            Boolean multiListFlag = false;
            if (questType.get(questKey) == 'Descriptive_null' || questType.get(questKey) == 'Descriptive(Long)_null') {
                nokeyMapFlag = true;
            } else if (questType.get(questKey) == 'Select List_Multi-Select') {
                multiListFlag = true;
            }
            for (Map < String, Integer > tempVar: peQuestMap.get(questKey)) {
                //System.debug(tempVar);
                List < String > answerList = new List < String > ();
                for (String tmp: tempVar.keySet()) {
                    if (!tempMap.containsKey(tmp)) {
                        tempMap.put(tmp, tempVar.get(tmp));
                    } else {
                        tempMap.put(tmp, tempMap.get(tmp) + 1);
                    }
                }
                //  System.debug(tempMap);
                Integer count = 0;
                for (Integer num: tempMap.values()) {
                    count += num;
                }
                //Map < String, Integer > tempMapFinal = new Map < String, Integer > ();
                Map < String, Decimal > tempMapFinal = new Map < String, Decimal > ();
                for (String fnl: tempMap.keySet()) {
                    //System.debug(count);
                    if (multiListFlag == true) {
                        count = questTypeCount.get(questKey);
                        //System.debug('********');
                    }
                    //System.debug(count);
                    Decimal dec = tempMap.get(fnl);
                    dec = dec.divide(count, 4) * 100;
                    //Integer tep = Math.round(dec);
                    Decimal tep = dec.setScale(2);
                    //System.debug(tep);
                    if (!tempMapFinal.containsKey(fnl)) {
                        tempMapFinal.put(fnl, tep);
                    } else {
                        tempMapFinal.put(fnl, tep);
                    }
                } //tempMapFinal.keySet()
                for (String tmp: tempMapFinal.keySet()) {
                    if (nokeyMapFlag == true) {
                        answerList.add(tmp + '\n');
                    } else {
                        answerList.add(tmp + ' = ' + tempMapFinal.get(tmp) + '%\n');
                    }
                    //answerList.add(tmp +' = '+tempMap.get(tmp));
                }
                peQuestMapFinal.put(questKey, tempMap);
                peQuestMapFinalList.put(questKey, answerList);
            }
            //System.debug('\n');
            //peQuestMapFinal.put(questKey,tempList);
        }
        //System.debug(peQuestMapFinal);
        //   System.debug(peQuestMapFinalList);
        
        return peQuestMapFinalList;
    }
    
    
    
    /*public PageReference downloadPDF( ) {
// System.debug('interval_id');
System.PageReference pageRef = new System.PageReference('/apex/PE_Download_PDF');
//  PageReference pageRef = new PageReference('http://www.google.com');

//ensure pdf downloads and is assigned with defined name
pageRef.getHeaders().put('content-disposition', 'attachment; filename=TestPDF.pdf');

return pageRef;
}*/
}