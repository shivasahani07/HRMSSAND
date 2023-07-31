public with sharing class PE_Feedback_From_Others_Controller {
	
	
     @AuraEnabled
    public static String getUser(){
        String userId=  UserInfo.getName();
     //   System.debug('aaaa'+userId);
        return userId;
    }
		
		@AuraEnabled
		public static List < PE_Intervals__c > getIntervalDetailsSFDC() {
				//list of interval with status active and inactive
				// List < PE_Intervals__c > intervalList {get;set;}
				List < PE_Intervals__c > intervalList = new List < PE_Intervals__c > ([SELECT ID, Name, Close_Date__c, End_Date__c, No_Of_Reminders__c, Notification_Date__c, Start_Date__c,Active__c FROM PE_Intervals__c ORDER BY Start_Date__c DESC]);
				//intervalList.addAll([SELECT Name, Close_Date__c, End_Date__c, No_Of_Reminders__c, Notification_Date__c, Start_Date__c FROM PE_Intervals__c]);
				return intervalList;
		}
		@AuraEnabled
		public static Summary__c getSummaryDetailsSFDC(String intervalID) {
				Summary__c sumry = [SELECT ID, Name, Active__c, PE_Intervals__c, PE_Intervals__r.Name, Status__c FROM Summary__c WHERE PE_Intervals__c = : intervalID AND User__c = : Userinfo.getUserId() LIMIT 1];
				return sumry;
		}
		@AuraEnabled
		public static Map < String, List < String >> getPEFeedBackfromSF(String intervalID, String SummaryId, String peRecordtypeName) {
              	Cache.Session.remove('PECache');
        String parameters = intervalID+','+SummaryId+','+peRecordtypeName;
        Cache.Session.put('PECache', parameters);
			//	System.debug(intervalID + ' === ' + SummaryId + ' === ' + peRecordtypeName);
				List < PE_Feedback_New__c > listofFeedbackforQuarter = new List < PE_Feedback_New__c > ();
				if (peRecordtypeName == 'None') {
						listofFeedbackforQuarter.addAll([SELECT ID, Name, Peers_ID__c, RecordTypeID, RecordType.Name, PE_Summary__c, PE_Summary__r.Name, Status__c, Users_Role__c FROM PE_Feedback_New__c WHERE Status__c = 'Submitted'
								AND PE_Summary__c = : SummaryId AND PE_Summary__r.PE_Intervals__c = :intervalID
						]);
				} else {
						listofFeedbackforQuarter.addAll([SELECT ID, Name, Peers_ID__c, RecordTypeID, RecordType.Name, PE_Summary__c, PE_Summary__r.Name, Status__c, Users_Role__c FROM PE_Feedback_New__c WHERE Status__c = 'Submitted'
								AND PE_Summary__c = : SummaryId AND Recordtype.Name = : peRecordtypeName AND PE_Summary__r.PE_Intervals__c = :intervalID
						]);
				}
				Set < ID > feedbackIdSet = new Set < ID > ();
				for (PE_Feedback_New__c fb: listofFeedbackforQuarter) {
						feedbackIdSet.add(fb.Id);
				}
		//		System.debug(feedbackIdSet);
				Map < String, String > questType = new Map < String, String > ();
				Map < String, Integer > questTypeCount = new Map < String, Integer > ();
				List < PE_Feedback_Item__c > listFeedbackLineItems = [SELECT ID, Name, Answer__c, PE_Feedback__c, PE_Question_Item__c, PE_Question_Item__r.Name, PE_Question_Item__r.Question__c, PE_Question_Item__r.Field_Type__c, PE_Question_Item__r.Pick_List_Type__c FROM PE_Feedback_Item__c WHERE PE_Feedback__c IN: feedbackIdSet];
				//logic start for formatter
				Map < String, List < Map < String, Integer >>> peQuestMap = new Map < String, List < Map < String, Integer >>> ();
				Map < String, List < Map < String, Integer >>> peQuestMapCopy = new Map < String, List < Map < String, Integer >>> ();
			//	System.debug('&&&listFeedbackLineItems&&'+listFeedbackLineItems);
				for (PE_Feedback_Item__c peItem: listFeedbackLineItems) {
                    if(peItem.Answer__c != null){
                 //       System.debug('----------------------------------------------');
                   //     System.debug(peItem);
                        if (!peQuestMap.containsKey(peItem.PE_Question_Item__r.Question__c)) {
								//map for question and type
								questType.put(peItem.PE_Question_Item__r.Question__c, peItem.PE_Question_Item__r.Field_Type__c+'_'+peItem.PE_Question_Item__r.Pick_List_Type__c);
								//getting each question count for % calculation
								questTypeCount.put(peItem.PE_Question_Item__r.Question__c, 1);
								//System.debug(peItem.PE_Question_Item__r.Field_Type__c +' ==== '+ peItem.PE_Question_Item__r.Pick_List_Type__c +' ==== '+ peItem.Answer__c.contains(','));
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
										//System.debug(peQuestMap.get(peItem.PE_Question_Item__r.Question__c));
								}
						}
                    }else{
                      //  System.debug('%%%%%%%%%%%%%%%%%%%%%');
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
						}else if(questType.get(questKey) == 'Select List_Multi-Select'){
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
							//	System.debug(tempMap);
								Integer count = 0;
								for (Integer num: tempMap.values()) {
										count += num;
								}
								//Map < String, Integer > tempMapFinal = new Map < String, Integer > ();
                            	Map < String, Decimal > tempMapFinal = new Map < String, Decimal > ();
								for (String fnl: tempMap.keySet()) {
										//System.debug(count);
										if(multiListFlag ==  true){
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
								}//tempMapFinal.keySet()
								for (String tmp: tempMapFinal.keySet()) {
										if (nokeyMapFlag == true) {
												answerList.add(tmp);
										} else {
												answerList.add(tmp + ' = ' + tempMapFinal.get(tmp) + '%');
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
			//	System.debug(peQuestMapFinalList);
				return peQuestMapFinalList;
		}
}