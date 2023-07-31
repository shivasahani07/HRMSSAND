public class OutlookIntegration_New {

    public Static String GenerateEventLink(String name, String Email, String Subject, String emailBody, String sDate, String eDate){
        try{
            OutlookeventCreatingWrapper newWapper = new OutlookeventCreatingWrapper();
        
            newWapper.subject = Subject;
            
            OutlookeventCreatingWrapper.body bd =new OutlookeventCreatingWrapper.body();
            bd.content = emailBody;
            bd.contentType = 'HTML';
            
            OutlookeventCreatingWrapper.start st =new OutlookeventCreatingWrapper.start();
            st.timeZone = 'Asia/Kolkata';
            st.dateTimes = sDate;//'2019-03-15T14:00:00';
            
            OutlookeventCreatingWrapper.location nt = new OutlookeventCreatingWrapper.location();
            nt.displayName = 'Utilitarianlab Office';
            
            OutlookeventCreatingWrapper.ends ed =new OutlookeventCreatingWrapper.ends();
            ed.timeZone = 'Asia/Kolkata';
            ed.dateTimes = eDate;//'2019-03-15T15:00:00';
            
            List<OutlookeventCreatingWrapper.attendees> attList = new List<OutlookeventCreatingWrapper.attendees>();
            
            Sales_Process_Configurations__c	config = Sales_Process_Configurations__c.getall().values();
            List<User> muList = [SELECT Id, Email, Name FROM User WHERE UserName =: config.Manager_Username__c LIMIT 1];
            List<User> suList = [SELECT Id, Email, Name FROM User WHERE UserName =: config.Sales_Person_Username__c LIMIT 1];
            List<String> EmailList = new List<String>{muList[0].Email, suList[0].Email, Email};
            Map<String, String> mUMap = new Map<String, String>();
            for(User u : muList){
                mUMap.put(u.Email, u.Name);
            }
            for(User u : suList){
                mUMap.put(u.Email, u.Name);
            }
            mUMap.put(name, Email);
            
            map<string,String> Emailbyname = new map<string,String>();
            integer i = 0;
            for(String m : EmailList){                
                Emailbyname.put(mUMap.get(m), m);
            }          
            system.debug('Emailbyname'+Emailbyname);
            
            for(String abc: Emailbyname.keyset()){
                OutlookeventCreatingWrapper.emailAddress ea = new OutlookeventCreatingWrapper.emailAddress();
                ea.address = Emailbyname.get(abc);
                ea.name = abc;
                OutlookeventCreatingWrapper.attendees att  = new OutlookeventCreatingWrapper.attendees();
                att.emailAddress = ea;
                att.type = 'required';
                attList.add(att);
            }            
            newWapper.body = bd;
            newWapper.start = st;
            newWapper.ends = ed;
            newWapper.location = nt;
            newWapper.attendees = attList;
            
            newWapper.allowNewTimeProposals = true;
            newWapper.isOnlineMeeting = true;
            newWapper.onlineMeetingProvider = 'teamsForBusiness';
            Integer randomNumber = Integer.valueof((Math.random() * 10));
            Integer randomNumber1 = Integer.valueof((Math.random() * 1000));
            newWapper.transactionId = '7E'+randomNumber+'3156-'+randomNumber1+'-4BEB-A1C6-729EA807'+randomNumber+'A7';
            
            string jsonString = JSON.serialize(newWapper);
            
            jsonString = jsonString.replace('ends','end');
            jsonString = jsonString.replace('dateTimes','dateTime');
            
            System.debug('jsonString >>'+jsonString); 
            
            String eventLink = createevent(jsonString);
            System.debug('eventLink >>'+eventLink);
            return eventLink;
        }catch(Exception e){
            system.debug('Error GenerateEventLink --  ' + e.getMessage() + 'At Line Number :: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static String createevent(String jasonString) {
        System.debug('jason>>'+jasonString);
        
        String endPoint = 'https://graph.microsoft.com/v1.0/me/events';
        String accToken = generateAcessToken();
        system.debug('acctoken -- ' + accToken);
        HttpRequest req = new HttpRequest();
        req.setBody(jasonString);
        req.setHeader('Accept', 'application/json');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'Bearer '+accToken);
        req.setEndpoint(endPoint); 
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 201 || res.getStatusCode() == 200){
            outlookEventResponse respWrapObj = outlookEventResponse.parse(res.getBody());
            System.debug('Meeting Link >>>' +respWrapObj.webLink);
            return respWrapObj.webLink; 
            
        }else{
            System.debug('res fail >>>'+res.getStatusCode()+'body'+res.getBody());
            return 'Fail';
        }
    }
    
    public static String generateAcessToken(){
        String endPoint ;
        String endpointURL = 'https://login.microsoftonline.com/common/oauth2/token';
        String username = 'shubham.kumar@utilitarianlab.com';
        String password = '2910@Shubh';
        String cliendId = 'f8de9f6c-0412-4fa6-8476-8458d3202e97';
        String clientSecret = 'lSh7Q~CcNcVyJ_ztNxrdPF8Az2NIDb.K1Cdud';
        String resource = 'https://graph.microsoft.com';
        String authorization_code ;
        endPoint = endpointURL ;
        String Body = 'username='+username+'&password='+password+'&grant_type=password'+'&client_id='+cliendId+'&client_secret='+clientSecret+'&resource='+resource;
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setBody(Body);
        Http http = new Http();
        HTTPResponse res;
        
        try{
            res = http.send(request);   
            JsonParser respWrapObj = JsonParser.parse(res.getBody());
            system.debug('access----token'+respWrapObj.access_token);
            return respWrapObj.access_token;
        }catch(Exception e){
            system.debug('exception::'+e.getMessage()+e.getLineNumber());
            return 'Success';
        }
    }     
}