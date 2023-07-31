Trigger TriggerOnContact on Contact (After Insert){
    // DMSConfigHelper.createFolder(Trigger.new);
    
    if(trigger.isAfter && trigger.isInsert){
        TriggerOnHolidayHelper.CommonHolidays(trigger.new);
        TriggerOnContactHelper.DocCategoriesMgt(Trigger.New);
    }
    
    
}