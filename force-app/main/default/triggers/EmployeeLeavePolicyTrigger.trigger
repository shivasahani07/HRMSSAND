trigger EmployeeLeavePolicyTrigger on Employee_Leave_Policy__c (before insert,after insert) {
    if(trigger.isAfter && trigger.isInsert){
        
    }
    
}