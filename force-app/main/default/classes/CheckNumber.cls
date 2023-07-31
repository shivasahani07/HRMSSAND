@RestResource(urlMapping='/CheckNumber/')
global class CheckNumber {
	@HTTPPost
    global static String CheckContact(){
        String phoneNumber;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String arr = req.requestBody.toString();
        System.debug('Body'+ arr);
        return 'hello';
        
    }
}