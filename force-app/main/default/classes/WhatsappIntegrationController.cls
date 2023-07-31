public class WhatsappIntegrationController {
	 @AuraEnabled
    public static void sendWAMessage( String message){
        //String contactNumber='917310012248';
        requestController(message);
        
    }
    public static void requestController(String messageBody){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://graph.facebook.com/v14.0/104847169069956/messages');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        
        String apiKey='EAAVK8gNNbLcBACfOFAiKIg9n0NVfyfHvld6gpz2zqSrEZAhRKEtgHsbQp3vr4YHnolKyNA2hG2gaZCHSOKolqOAuZCW5FSObnJXrdp2wqGe7R6PuUf4lNqCvr2Y2ENEHUsZCXFiCUdXDdq3dVYw9yiW2DtUgTBfE67MN9O0yLdJDVEw9R6Wvs8BBqJTZBLw674x6sgX5gkgZDZD';
        String body='{"messaging_product":"whatsapp","to":"918700095333","text":{"body":"'+messageBody+'"}}';
        
        req.setHeader('Authorization', 'Bearer '+apiKey);
        //req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        req.setBody(body);
        HttpResponse response= new HttpResponse();
        response=h.send(req);
        system.debug('response>>'+response);
        system.debug('response>>'+response.getBody());
    }
}