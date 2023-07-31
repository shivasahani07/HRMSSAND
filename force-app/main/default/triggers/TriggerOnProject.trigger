//Created By Shubham Kumar 
//Last Modified By Shiva 
//Test Class Name =
//Code coverage: 
trigger TriggerOnProject on Project__c (after update,after insert,before insert,before update) {
    if(trigger.isAfter && trigger.isInsert){
       // TriggerOnProjectHelper.CrateDefualtModuleUisimgMetaData(Trigger.new);
        TriggerOnProjectHelper.createDefualtMileStoneCS(Trigger.new);
    }

}