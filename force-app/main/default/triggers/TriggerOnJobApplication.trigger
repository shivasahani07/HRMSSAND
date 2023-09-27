trigger TriggerOnJobApplication on Application__c (before insert,after insert) {
    if(trigger.isInsert && trigger.isAfter){
        JobapplicationHelper.updateNumberOfApplicationOnJobReq(Trigger.new);
        JobapplicationHelper.TestUpdate(Trigger.new);
    }
}