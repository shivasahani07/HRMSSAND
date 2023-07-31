global  without sharing class CSV_Controller {
    
    @AuraEnabled
    public static string processData(String fileData,String sobjectName,List<String> fields) 
    {
        map<String,String> ConIdByName = new  map<String,String>();
        map<string,String> apiNameByLabelName = new map<String,String>();
        map<string,String> moduleIdByProjectName = new map<String,String>();
        map<string,String> moduleIdByModuleName = new map<String,String>();
        List<Jira_Task__c> jiraTasks = new List<Jira_Task__c>();
        List<Jira_Task__c> JiraListToBeInserted = new List<Jira_Task__c>();
        List<Contact> ConList = [SELECT Id,name , RecordType.name FROM Contact where RecordType.name = 'Resource'];
        List<Module__c> moduleList = [SELECT Id,Name,Project_Name__c  FROM Module__c];
        List<Jira_Tasks_Fields__c> jtFields = [SELECT API_Name__c,Name FROM Jira_Tasks_Fields__c];
        
        for(Module__c Mod : moduleList){
            moduleIdByProjectName.put(Mod.Project_Name__c , Mod.Id);
            moduleIdByModuleName.put(Mod.Name , Mod.Id);
        }
        
        for(Contact Con : ConList){
            ConIdByName.put(Con.name , con.Id);
        }
        
        for(Jira_Tasks_Fields__c jtf : jtFields){
            apiNameByLabelName.put(jtf.Name , jtf.API_Name__c);
        }
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        
        try{
            if(fileData!=null) { 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                //for content
                
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    Jira_Task__c obj = new Jira_Task__c();//targetType.newSObject();
                    integer rowsize=inputvalues.size();
                    for(integer l=0;l<rowsize;l++){ 
                        system.debug('rowsize'+rowsize);
                        //system.debug('fields.get(l)'+fields.get(l));
                        if (fields.get(l) == 'Project Name' || fields.get(l) == 'Module Name' ) { 
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            if(moduleIdByModuleName.get(value) != null){
                                obj.put('Module__c',moduleIdByModuleName.get(value));
                            }else{
                                obj.put('Module__c',moduleIdByProjectName.get(value));
                            }
                            
                        }else if (fields.get(l) == 'Team Member' || fields.get(l) == 'Stand By Resource' || fields.get(l) == 'Assigned By') { 
                            if(String.isNotBlank(inputvalues[l]) )
                            {
                                String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                                obj.put(apiNameByLabelName.get(fields.get(l)),ConIdByName.get(value));
                            }else{
                                obj.put(apiNameByLabelName.get(fields.get(l)),'');
                            }
                        }else if(fields.get(l) == 'Estimated Efforts' ){
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            obj.put(apiNameByLabelName.get(fields.get(l)),Decimal.valueOf(value));
                        }else if(fields.get(l) == 'Estimated Start Date' ){
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            obj.put(apiNameByLabelName.get(fields.get(l)),date.valueOf(value));
                        }else{
                            if(String.isNotBlank(inputvalues[l]) )
                            {
                                String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                                obj.put(apiNameByLabelName.get(fields.get(l)),value);
                                
                            }else{
                                obj.put(apiNameByLabelName.get(fields.get(l)),'');
                            }
                        }
                    }
                    System.debug('Obj::::'+obj);
                    jiraTasks.add(obj);
                }
            }
            
            if (jiraTasks.size() > 0) { 
                for(Jira_Task__c sobj:jiraTasks){
                    if(sobj.Module__c != null){
                        JiraListToBeInserted.add(sobj);
                    }
                }
                insert JiraListToBeInserted;
                return 'Records Saved Sucesfully';
            }else{
                return 'Some Error Occured.';
            }
        }catch(Exception e){
            System.debug('exception'+e + 'Line number' +e.getLineNumber());
            return e.getMessage();
        }
        
    }
}