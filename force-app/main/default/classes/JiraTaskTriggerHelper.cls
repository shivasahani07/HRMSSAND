//Created By Shubham Kumar 
//Last Modified By Shiva 
//Test Class Name =
//Code coverage: 
public class JiraTaskTriggerHelper {
    
    Public static void updateDailyTasks(List<Jira_Task__c> newList){
        for(Jira_Task__c jt : newList){
            if(jt.Task_Start_Date_Time__c != null && jt.Task_End_Date_Time__c != null){
                jt.Task_Start_Date_Time__c = roundToNextHour(jt.Task_Start_Date_Time__c).addMinutes(-330);
                jt.Task_End_Date_Time__c = roundToNextHour(jt.Task_End_Date_Time__c).addMinutes(-330);
                
                Long hours = updateRelateTime(jt.Task_End_Date_Time__c,jt.Task_Start_Date_Time__c);
                if(hours > 10 ){
                    if( hours/24 > 1){
                        Integer numberOfTasks = integer.valueOf(hours/24);
                        hours = hours - 24*(14);
                    }
                }
                jt.Estimated_Efforts__c =  hours ; 
            }
        }
    }
    
    public Static DateTime roundToNextHour(DateTime dt) {
        system.debug('dt'+dt.minute());
        if(dt.minute() == 15){
            return dt.addHours(1).addMinutes(-15);
        }else if(dt.minute() == 30){
            return dt.addHours(1).addMinutes(-30);
        }else if(dt.minute() == 45){
            return dt.addHours(1).addMinutes(+15);
        }else{
            return dt;
        }
    }
    
    Public static void updateDailyLineItems(map<Id,Jira_Task__c> newMap , map<Id,Jira_Task__c> oldMap){
        
        List<Time_Entry_Line_Items__c> TimeEntryList = [SELECT Allocated_Hours__c,Consumed_Hours__c,Date_Of_Work__c,End_Time_Date__c,Id,Is_Completed__c,Is_Over_Due__c,Jira_Task__c,Name,Project_Resource_Mapping__c,Project__c,Status__c,Stat_Time_date__c,Task_Description__c,Time_Entry_Daily_Card__c FROM Time_Entry_Line_Items__c where Jira_Task__c IN :newMap.Keyset()];
        List<Time_Entry_Line_Items__c> TimeEntryListToBeUpdated = new  List<Time_Entry_Line_Items__c>();
        List<Jira_Task__c> newJiraTaskList = new  List<Jira_Task__c>();
        map<String ,List<Time_Entry_Line_Items__c>> jiraTaskListByTELI = new map<String,List<Time_Entry_Line_Items__c>>();
        
        for(Time_Entry_Line_Items__c TELI : TimeEntryList){
            
            if(jiraTaskListByTELI.containskey(TELI.Jira_Task__c)){
                jiraTaskListByTELI.get(TELI.Jira_Task__c).add(TELI);
            }else{
                List<Time_Entry_Line_Items__c> newLineItems =  new List<Time_Entry_Line_Items__c>();
                newLineItems.add(TELI);
                jiraTaskListByTELI.put(TELI.Jira_Task__c , newLineItems);
            }
            
        }
        system.debug('jiraTaskListByTELI'+jiraTaskListByTELI);
        if(jiraTaskListByTELI.size() > 0){
            for(Jira_Task__c jt : newMap.values()){
                if( ( jt.Task_Start_Date_Time__c != oldMap.get(jt.id).Task_Start_Date_Time__c ) || (jt.Actual_Hours_Utilised__c != oldMap.get(jt.id).Actual_Hours_Utilised__c) ||   (jt.Task_End_Date_Time__c != oldMap.get(jt.id).Task_End_Date_Time__c) ||  (jt.Is_Overdue__c != oldMap.get(jt.id).Is_Overdue__c	) || (jt.Status__c != oldMap.get(jt.id).Status__c) || (jt.Estimated_Efforts__c != oldMap.get(jt.id).Estimated_Efforts__c) ){
                    
                    for(Time_Entry_Line_Items__c teli : jiraTaskListByTELI.get(jt.Id)){
                        teli.Is_Over_Due__c = String.valueOf(jt.Is_Overdue__c);
                        if(jt.Status__c == 'Dev Completed'){
                            teli.Is_Completed__c = true;    
                        }
                        teli.Stat_Time_date__c = jt.Task_Start_Date_Time__c;
                        teli.End_Time_Date__c = jt.Task_End_Date_Time__c;
                        teli.Consumed_Hours__c = jt.Total_Utilised_Time__c;
                        teli.Allocated_Hours__c = jt.Estimated_Efforts__c;
                        TimeEntryListToBeUpdated.add(teli);
                    }
                }
            }
            if(TimeEntryListToBeUpdated.size() > 0){
                update TimeEntryListToBeUpdated; 
            }
            
        }
        
    }
    
    Public static void updatePRM(map<Id,Jira_Task__c> newMap , map<Id,Jira_Task__c> oldMap){
        map<String,List<Project_Resource_Mapping__c>> PRMIdsByProjectIDs = new map<String,List<Project_Resource_Mapping__c>>();
        List<String> ModuleIds = new List<String>();
        List<String> ProjectIds = new List<String>();
        map<String,String> projectIDsBymoduleIds = new map<String,String>();
        map<String,map<String,String>> PrmIdByConIDByProjectID = new map<String,map<String,String>>();
        map<Id, Id> PRMIdByModuleId = new map<Id, ID>();
        for (Jira_Task__c jt : newMap.values()){
            ModuleIds.add(jt.Module__c);
        }
        system.debug('ModuleIds'+ModuleIds);
        List<Module__c> ModuleList = [Select id, Name, Project_Resource_Mapping__c,Project__c from Module__c where Id IN:ModuleIds];
        for(Module__c md : ModuleList){
            ProjectIds.add(md.Project__c);
            projectIDsBymoduleIds.put(md.Id,md.Project__c);
        }
        system.debug('projectIDsBymoduleIds'+projectIDsBymoduleIds);
        
        List<Project__c> ProjectData = [SELECT Id,(SELECT Contact__c,Id,Name,Project__c,Type__c FROM Project_Resource_Mapping__r) FROM Project__c where Id IN :ProjectIds]; 
        for(Project__c prj:ProjectData){
            for(Project_Resource_Mapping__c prm :prj.Project_Resource_Mapping__r){
                
                if(PrmIdByConIDByProjectID.containskey(prj.Id)){
                    PrmIdByConIDByProjectID.get(prj.Id).put(prm.Contact__c , prm.Id);
                }else{
                    map<String,String> newmapData = new map<String,String>();
                    newmapData.put(prm.Contact__c , prm.Id);
                    PrmIdByConIDByProjectID.put(prj.Id,newmapData);
                }
            }
        }
        
        system.debug('PrmIdByConIDByProjectID'+PrmIdByConIDByProjectID);
        List<Jira_Task__c> JiraTasksToBeUpdated = [Select Id , Module__c ,Team_Member__c,Project_Resource_Mapping__c from Jira_Task__c where id IN:newMap.values()];
        for (Jira_Task__c jt : JiraTasksToBeUpdated){
            if(jt.Team_Member__c != null && String.isNotBlank(jt.Team_Member__c)){
                if(PrmIdByConIDByProjectID.get(projectIDsBymoduleIds.get(jt.Module__c)).get(jt.Team_Member__c) != null){
                    jt.Project_Resource_Mapping__c = PrmIdByConIDByProjectID.get(projectIDsBymoduleIds.get(jt.Module__c)).get(jt.Team_Member__c);
                }
            }
        }
        update JiraTasksToBeUpdated;
    }
    
    Public static void updateRelateTime(map<Id,Jira_Task__c> newMap , map<Id,Jira_Task__c> oldMap){
        
        List<Jira_Task__c> JiraTasksToBeUpdated = [Select Id , Module__c ,Team_Member__c,Project_Resource_Mapping__c from Jira_Task__c where id IN:newMap.values()];
        
        for (Jira_Task__c jt : JiraTasksToBeUpdated){
            if(jt.Task_Start_Date_Time__c != null && jt.Task_End_Date_Time__c != null && jt.Task_Start_Date_Time__c != oldmap.get(jt.Id).Task_Start_Date_Time__c ){
                if(jt.summed_up_time__c != null){
                    jt.summed_up_time__c = jt.summed_up_time__c + jt.Actual_Hours_Utilised__c; 
                }else{
                    jt.summed_up_time__c = jt.Actual_Hours_Utilised__c;   
                }
            }
        }
        update JiraTasksToBeUpdated;
    }
    
    Public static Long updateRelateTime(dateTime dt1 , datetime dt2){
        
        Long dt1Long = dt1.getTime();
        Long dt2Long = dt2.getTime();
        Long milliseconds =  dt1Long - dt2Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        Long hours = minutes / 60;
        system.debug('hours'+hours);
        return hours;
        //Long days = hours / 24;
        
    }
    
    //-----------------------------------------------------------------
    //Method Added By Shiva
    //Functionality: Sum up all the JiraTask Utlised Time on the related  Module
    Public Static void sumUpTotalUtilisedHours(List<Jira_Task__c> newList){
        List<Module__c> ModuleListToBeUpdated = new List<Module__c> ();
        map<String,Module__c> moduleByJiraTask = new map<String,Module__c>();
        List<String> ModuleIds  = new List<String>();
        
        for(Jira_Task__c jt :newList){
            if(jt.Module__c != null){
                ModuleIds.add(jt.Module__c);
            }
        }
        Map<ID, Module__c> moduleByModuleID = new Map<ID, Module__c>([Select Id,Name,Total_Utilised_Time__c from Module__c Where ID IN :ModuleIds]);
        
        for(Jira_Task__c jt :newList){
            if(jt.Module__c != null && jt.Total_Utilised_Time__c != null){
                moduleByModuleID.get(jt.Module__c).Total_Utilised_Time__c = moduleByModuleID.get(jt.Module__c).Total_Utilised_Time__c + jt.Total_Utilised_Time__c;
            }
        }
        if(!moduleByModuleID.isEmpty()){
            update moduleByModuleID.values();
        }
        
    }
    

}