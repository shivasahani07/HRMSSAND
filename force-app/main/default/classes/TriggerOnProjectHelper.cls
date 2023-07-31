//Created By Shubham Kumar 
//Last Modified By Shiva 
//Test Class Name =
//Code coverage: 
public class TriggerOnProjectHelper {
    Public Static void CrateDefualtModuleUisimgMetaData(List<Project__c> projList){
       /* map<String, List<module__c>> moduleListByProjectId = new map<String, List<module__c>>();
         List<module__c> ModuleListToBeInsertd = new List<module__c>();
        List<DefaulModuleName__mdt> AutomateMpdules = DefaulModuleName__mdt.getAll().values();
        List<DefaulModuleName__mdt> AutomateMpdulesList = new List<DefaulModuleName__mdt>();
        AutomateMpdulesList=[select id,DeveloperName,MasterLabel,Estimate_Time__c from DefaulModuleName__mdt];
        system.debug('AutomateMpdules'+DefaulModuleName__mdt.getAll().values());
        system.debug('AutomateMpdulesList'+AutomateMpdulesList);
        for(Project__c pj:projList ){
            system.debug('this is project list debug'+projList);
            for(DefaulModuleName__mdt cmdt:AutomateMpdulesList){
                module__c mdRec = new module__c();
                mdRec.Project__c=pj.id;
                mdRec.Name=cmdt.MasterLabel;
                mdRec.Total_Estimated_Efforts__c=cmdt.Estimate_Time__c;
                ModuleListToBeInsertd.add(mdRec);
             }
           
        }
        if(!ModuleListToBeInsertd.isEmpty()){
            insert ModuleListToBeInsertd;
        }*/
        
    }
     Public Static void createDefualtMileStoneCS(List<Project__c> ProjectList){
        List<Default_Milestone_project__c> defaultMilestones =[select id,Name,Description__c from Default_Milestone_project__c];
        system.debug('defaultMilestones::'+defaultMilestones);
        map<String,List<Project__c>>  MileStoneByProjectId = new map<String,List<Project__c>>();
        List<Milestone__c> milestoneList = new List<Milestone__c>();
        List<Project__c> proLIst = new List<Project__c>();
        for(Project__c pj: ProjectList){
            
            for(Default_Milestone_project__c dms :defaultMilestones){
                Milestone__c Mstone = new Milestone__c();
                Mstone.Name__c=dms.Name;
                Mstone.Project__c=pj.id;
                Mstone.Account__c=pj.Account__c;
                milestoneList.add(Mstone);
            }
            
        }
        if(!milestoneList.isEmpty()){
            insert milestoneList;
        }  
    }
}