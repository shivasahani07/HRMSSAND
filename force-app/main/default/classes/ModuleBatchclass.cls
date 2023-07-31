//Created By Shubham Kumar 
//Last Modified By Shiva 
//Test Class Name =
//Code coverage: 
public class ModuleBatchclass implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,Module_End_Time__c,Module_Locked__c,Module_Start_Date__c,Total_Estimated_Efforts__c,Total_Utilised_Time__c FROM Module__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<Module__c> ModuleList)
    {
        for(Module__c MD : ModuleList)
        {
            if(MD.Module_End_Time__c == SYSTEM.today()){
                MD.Module_Locked__c = TRUE;
            }
        }
        update ModuleList;
    }
    public void finish(Database.BatchableContext BC) {
    }
}