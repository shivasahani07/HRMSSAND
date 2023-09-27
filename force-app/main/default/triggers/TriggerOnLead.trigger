trigger TriggerOnLead on Lead (before insert,after insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        LeadDocumentViewr.createDocscategoryforLlead(trigger.new);
    }
}