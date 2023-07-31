@RESTResource(urlMapping='/verifyphone/*')
global without sharing class PhoneVerifyService {
	@HttpPost
    global static void verifyPhone(){
        RestRequest req = RestContext.request;
       	String phone = req.params.get('phone');
        
        List<Contact> conList = [Select Id,Phone From Contact Where Phone=:phone];
        
        String responseBody;
        
        if(conList.isEmpty()){
            responseBody = JSON.serialize(new APIResponseWrapper('Failure', 'Not exist'));
        	RestContext.response.responseBody = Blob.valueOf(responseBody);
            RestContext.response.statusCode = 200;    
        }else{
            responseBody = JSON.serialize(new APIResponseWrapper('Success', 'Exist'));
            RestContext.response.responseBody = Blob.valueOf(responseBody);
            RestContext.response.statusCode = 200;   
        }
    }
    
     class APIResponseWrapper {
        public String message;
        public String status;

        public APIResponseWrapper(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }
    
}