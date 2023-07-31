/*****
        Author : Anjali Singh
        Description : This class will create JIRA TASK in FSL Production Org  
*****/
@RestResource(urlMapping='/createCase')
global with sharing class CreateCaseInTargetOrg{
    
    @HttpPost
    global static void doPost() {
        DateTime processingStartTime = System.now();
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        System.debug('--- rquestString'+ requestString);
        CaseWrapper cWrapper = (CaseWrapper)JSON.deserialize(requestString, CaseWrapper.class);
        String responseBody;
        if(cWrapper != null){
            String getResponse = createJiraTask(cWrapper);
            if(getResponse.contains('a1V')) {
                CaseCreateHttpUtility.getInstance().createServiceLogger(requestString, responseBody, '/createCase', 'POST', 200, processingStartTime, System.now()); //Log this request
                RestContext.response.responseBody = Blob.valueOf(getResponse);
            }
            else{
                responseBody = JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Error', getResponse));
                CaseCreateHttpUtility.getInstance().createServiceLogger(requestString, responseBody, '/createCase', 'POST', 400, processingStartTime, System.now()); //Log this request
                RestContext.response.responseBody = Blob.valueOf(responseBody);
            }
        }
    }
    
    public static String createJiraTask(CaseWrapper csWrap){
        try{
            CaseWrapper.cls_case cWrap = csWrap.caseCls;
            system.debug('csWrap.orgName -- ' + csWrap.orgName);
            String clientOrgName = '%' + csWrap.orgName + '%';
            List<Module__c> moduleList = [SELECT Id FROM Module__c WHERE Name LIKE: clientOrgName AND Name LIKE '%Support%' LIMIT 1];
            List<Project_Resource_Mapping__c> prmList = [SELECT Id, Type__c, Contact__c FROM Project_Resource_Mapping__c WHERE Project__r.Name LIKE: clientOrgName AND Project__r.Name LIKE '%Support%' AND Type__c = 'Lead' LIMIT 1];
            system.debug('moduleList -- ' + moduleList);
            system.debug('prmList -- ' + prmList);
            
            Jira_Task__c jira = new Jira_Task__c();
            jira.Description__c = cWrap.description;
            jira.Priority__c = cWrap.priority;
            jira.Status__c = 'New';
            //jira.Solution_Details_if_any__c = cWrap.reproducingSteps;
            jira.Module__c = moduleList[0].Id != null ? moduleList[0].Id : '';
            jira.Project_Resource_Mapping__c = prmList[0].Id != null ? prmList[0].Id : '';
            jira.Assigned_By__c = prmList[0].Contact__c != null ? prmList[0].Contact__c : '';
            insert jira;                         
            return jira.Id;
        }
        catch(Exception ex){
            system.debug('ERROR --> ' + ex.getMessage() + 'AT LINE NO --- > ' + ex.getLineNumber()) ;
            return ex.getMessage();            
        }
    }
    
}