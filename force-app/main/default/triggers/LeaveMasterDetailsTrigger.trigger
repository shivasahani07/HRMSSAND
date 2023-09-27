trigger LeaveMasterDetailsTrigger on Leave_Master_Details__c (before insert,after insert) {

      if(trigger.isAfter && trigger.isInsert){
       // LeaveManagementHelper.createLeaveCreditRecord(trigger.new);
    }
}