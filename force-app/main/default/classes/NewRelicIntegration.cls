public class NewRelicIntegration {
    
    public static void HitRelicLogAPI(){
        map<String,String> userNameById = new map<String,String>();
        Datetime dt = Datetime.now();
        Long l = dt.getTime();
        system.debug(l);
        system.debug(DateTime.newInstance(l));
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://log-api.newrelic.com/log/v1');
        req.setMethod('POST');
        List<User> USerList = [Select id , name from user];
        for(User us : USerList){
            userNameById.put(us.Id,Us.name);
        }
        
        
        List<LoginHistory> LoginHistoryLogs = [SELECT ApiType,ApiVersion,Application,AuthenticationServiceId,AuthMethodReference,Browser,CipherSuite,ClientVersion,CountryIso,Id,LoginGeoId,LoginTime,LoginType,LoginUrl,OptionsIsGet,OptionsIsPost,Platform,SourceIp,Status,TlsProtocol,UserId FROM LoginHistory Limit 5];
        List<NewRelicLogWrapper> NewRelicWrapperList = new List<NewRelicLogWrapper>();
        
        for(LoginHistory lh : LoginHistoryLogs){
            NewRelicLogWrapper nrlw = new NewRelicLogWrapper();
            //User Data
            NewRelicLogWrapper.User us = new NewRelicLogWrapper.User();
            us.id = lh.UserId;
            us.name = userNameById.get(lh.UserId);
            
            //Attributes
            NewRelicLogWrapper.Common com = new NewRelicLogWrapper.Common();
            NewRelicLogWrapper.attributes att = new NewRelicLogWrapper.attributes();
            att.logtype = 'accesslogs';
            att.service = 'login-service';
            att.hostname = lh.LoginUrl;
            att.action = 'Login';
            att.user = us;
            com.attributes = att;
            nrlw.Common = com;
            //Logs
            List<NewRelicLogWrapper.Logs> logList = new List<NewRelicLogWrapper.Logs>();
            NewRelicLogWrapper.Logs log = new NewRelicLogWrapper.Logs();
            NewRelicLogWrapper.Attributes_Z attz = new NewRelicLogWrapper.Attributes_Z();
            attz.logId = lh.Id;
            log.message = userNameById.get(lh.UserId) + ' Logged In Succesfully!!';
            log.timestamp = string.valueOf(l);
            log.attributes = attz;
            logList.add(log);
            nrlw.Logs = logList;
            
            NewRelicWrapperList.add(nrlw);
        }
        system.debug('NewRelicWrapperList'+NewRelicWrapperList);
        
        req.setCompressed(false);
        req.setBody(JSON.serialize(NewRelicWrapperList));
        
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Api-Key', 'ac85d657497ba503de7f060a507cc87e8fdcNRAL');
        
        try {
            res = http.send(req);
            system.debug('res'+res.getBody());
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }
        System.debug(res.getBody());
    }
    
    public static void HitRelicEventAPI(){
        map<String,String> userNameById = new map<String,String>();
        List<Map<String, Object>> JsonList = new List<Map<String, Object>>();
        List<User> USerList = [Select id , name from user];
        for(User us : USerList){
            userNameById.put(us.Id,Us.name);
        }
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://insights-collector.newrelic.com/v1/accounts/3775760/events');
        req.setMethod('POST');
                
        List<Jira_Task__c> jiraTasks = [SELECT Id,Name,Project_Name__c,Module__c,Description__c,Team_Member_Name__c,Assigned_By_Name__c,Module_Name__c,Status__c from Jira_Task__c Limit 5];
        List<NewRelicEventWrapper> NewRelicWrapperList = new List<NewRelicEventWrapper>();
        
        for(Jira_Task__c jt : jiraTasks){
            Map<String, Object> someObj = new Map<String, Object> {'eventType' => 'NrAiIncidentExternal',
                'title' => jt.Name,'description' => jt.Description__c,'state' => 'trigger','source' => jt.Status__c,'entityName' =>  jt.Module_Name__c,'entity.guid' =>  jt.Id,
                'aggregationTag.serviceId' => 5,'aggregationTag.environment' =>  'Production','aggregationTag.errorId' => 11232,'tag.stackTrace' => jt.Assigned_By_Name__c + ' To ' +jt.Team_Member_Name__c,'version' => 1}; 
                    JsonList.add(someObj);
        }
        system.debug('JsonList'+JsonList);
        req.setCompressed(false);
        req.setBody(JSON.serialize(JsonList));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Api-Key', 'ac85d657497ba503de7f060a507cc87e8fdcNRAL');
        
        try {
            res = http.send(req);
            system.debug('res'+res.getBody());
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }
        System.debug(res.getBody());
    }
    
}