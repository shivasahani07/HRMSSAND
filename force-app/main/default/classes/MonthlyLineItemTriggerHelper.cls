public class MonthlyLineItemTriggerHelper {
    
    Public static void sumUpEstimatedEfforts(List<Time_Entry_Monthly_Card__c> NewLineItems){
        map<Id,list<Time_Entry_Monthly_Card__c>> MonthlyCardsByPRM = new map<Id,list<Time_Entry_Monthly_Card__c>>();
        
        for(Time_Entry_Monthly_Card__c tem : NewLineItems){
            if(!MonthlyCardsByPRM.containsKey(tem.Project_Resource_Mapping__c)){
                List<Time_Entry_Monthly_Card__c> temList = new List<Time_Entry_Monthly_Card__c>();
                temList.add(tem);
                MonthlyCardsByPRM.put(tem.Project_Resource_Mapping__c , temList);
            }else{
                MonthlyCardsByPRM.get(tem.Id).add(tem);
            }
        }
        system.debug('MonthlyCardsByPRM'+MonthlyCardsByPRM);
        List<Project_Resource_Mapping__c> PRMList = new List<Project_Resource_Mapping__c>();
        
        
        
    }
}