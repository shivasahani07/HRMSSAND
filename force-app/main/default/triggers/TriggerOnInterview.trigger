trigger TriggerOnInterview on Interview__c (before insert,after insert,after update) {
    
    if(trigger.isupdate && trigger.isAfter){
       TriggerOnInterviewHelper.updateAverageRattingOnContact(trigger.new);
    }
}