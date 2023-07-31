trigger JobRequestion_Trigger on Mandate__c (after insert) {
    
    if(trigger.isInsert && trigger.isafter){
        JobRequestion_Trigger_Helper.DocCategoriesMgt(Trigger.New);
    }
    
}