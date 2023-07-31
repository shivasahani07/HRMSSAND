@RESTResource(urlMapping='/create_call_history/*')
global without sharing class CallHistoryService {
	@HttpPost
    global static void createCallHistory(){
		RestRequest req = RestContext.request;
        
        String responseBody;
        String body = req.requestBody.toString();
        CallLog log = (CallLog) JSON.deserialize(body,CallLog.class);
        
        List<Contact> conList = [Select Id,Phone From Contact Where Phone=:log.toNumber];
        
        if(conList.isEmpty()){
            responseBody = JSON.serialize(new APIResponseWrapper('Failure', 'Not exist'));
        	RestContext.response.responseBody = Blob.valueOf(responseBody);
            RestContext.response.statusCode = 200;    
        }else{
            String response;
            if((response=insertLog(log,conList[0].Id))=='Success'){
                responseBody = JSON.serialize(new APIResponseWrapper('Success', 'Call logs saved'));
                RestContext.response.statusCode = 200;   
            }else{
                responseBody = JSON.serialize(new APIResponseWrapper('Error', response));
                RestContext.response.statusCode = 400;   
            }
            RestContext.response.responseBody = Blob.valueOf(responseBody);
        }
    }
    
    global static String insertLog(CallLog log,String conId){
        try{
            long duration = Long.valueOf(log.duration);
            
            long seconds = (duration / 1000);
                        
            CallHistory__c history = new CallHistory__c();
            
            history.From__c = log.fromNumber;
            history.To__c = log.toNumber;
            history.Contact__c = conId;
            history.Duration__c = String.valueOf(seconds);
            
            Time startTime = Time.newInstance(Integer.valueOf(log.startedTime.split(':')[0]), Integer.valueOf(log.startedTime.split(':')[1]), Integer.valueOf(log.startedTime.split(':')[2]),0);
            Time endTime   = Time.newInstance(Integer.valueOf(log.endTime.split(':')[0]), Integer.valueOf(log.endTime.split(':')[1]), Integer.valueOf(log.endTime.split(':')[2]),0);
                
            history.Starting_time__c = startTime;
            history.End_Time__c = endTime;
            
            insert history;
            return 'Success';
        }catch(DMLException e){
            return 'Error:- '+e.getMessage();
        }
    }
    
    global class CallLog{
        global String fromNumber;
        global String toNumber;
        global String startDate;
        global String endDate;
        global String startedTime;
        global String endTime;
        global String duration;
    }
    
     global class APIResponseWrapper {
        public String message;
        public String status;

        public APIResponseWrapper(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }
}