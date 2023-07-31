global class DMSConfigHelper {
    public static List<AggregateResult> getAllObjects(){
        List<AggregateResult> objects = [select SObjectType FROM ObjectPermissions GROUP BY SObjectType ORDER BY SObjectType ASC];
        objects.sort();
        return objects;
    }
    
    
    @future(callout=true)
    public static void createTrigger(String name, String sourceCode, String sType) {
        String message = callTriggerAPI(name,sourceCode,sType);
        System.debug('Message---'+message);
    }
    
    public static String callTriggerAPI(String name, String sourceCode, String sType){
        Map<String, String> body = new Map<String, String>{
            'Name' => name,
                'TableEnumOrId' => sType,
                'Body' => sourceCode
                };
                    
                    System.debug('MAPBODY---'+body);
        
        String url = ''
            + Url.getSalesforceBaseUrl().toExternalForm()
            + '/services/data/'
            + 'v48.0'
            + '/sobjects/'
            + 'ApexTrigger';
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(JSON.serialize(body));
        req.setEndpoint(url);
        
        HttpResponse res = new Http().send(req);
        
        return String.format(
            'Result of {0} POST is statusCode={1} body={2}',
            new Object[] {url, res.getStatusCode(), res.getBody().abbreviate(1000)}
        );
    }
    
    public static String saveDMSConfig(DMS_Configuration__c dms){
        try{
            if(dms!=null){
                insert dms;
                String body = 'Trigger '+dms.Trigger_Name__c +' on '+ dms.Object__c + ' ('+dms.Trigger_Point__c+'){DMSConfigHelper.createFolder(Trigger.new);}';
                createTrigger(dms.Trigger_Name__c,body,dms.Object__c);
                DMSMetadata.createLookupField(dms.Object__c);
                return 'Success';
            }
            return 'Invalid record';
        }catch(Exception e){
            System.debug('SAVEDMSCONFIG ERROR---'+e.getMessage());
            return e.getMessage();
        }
    }
    
    
    public static void createFolder(List<SObject> sObjectList){
        List<SObject> folders = new List<SObject>();
        
        for(SObject sObj : sObjectList){
            String objName = sObj.Id.getSObjectType().getDescribe().getName();
            
            DMS_Configuration__c dms = [Select Id,Name,Folders__c,Object__c,Trigger_Point__c From DMS_Configuration__c Where Object__c=:objName limit 1];
            
            List<String> folderNames = dms.Folders__c.split(';');
            for(String fName : folderNames){
                Folder__c folder = new Folder__c();
                SObject delegate = folder;
                Schema.SObjectField lookupFName ;
                Schema.SObjectField Name ;
                
                Schema.DescribeSObjectResult objDescribe = delegate.getSObjectType().getDescribe();
                String lookupFieldName = objName.contains('__c')?objName:objName+'__c';
                lookupFName =  objDescribe.fields.getMap().get(lookupFieldName);
                Name =  objDescribe.fields.getMap().get('Name');
                if(lookupFName != null && lookupFName != null)
                    delegate.put(lookupFName,sObj.Id);
                delegate.put(Name,fName);
                folders.add(delegate);
            }
        }
        Database.upsert(folders); 
    }
    
    
}