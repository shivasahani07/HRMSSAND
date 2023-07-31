public class OutlookSetupMeetingIntegration {
    
    @AuraEnabled @future(callout=true) 
    public  Static void GenerateEventLink(String Email,String Subject,String Timings,String meetDate,String timezone){
        System.debug('Email----->'+Email);
        System.debug('Email----->'+Subject);
        
        System.debug(' GenerateEventLink timezone == >'+timezone);
        try{
            system.debug('Timings == > '+Timings+' &&  meetDate ==> '+meetDate);
            string startTime = Timings.substring(0,2) ;
            String EndeTime = Timings.substring(6,8);
            
            OutlookeventCreatingWrapper newWapper = new OutlookeventCreatingWrapper();
            
            newWapper.subject = Subject;
            
            OutlookeventCreatingWrapper.body bd =new OutlookeventCreatingWrapper.body();
            bd.content = Subject;
            bd.contentType = 'HTML';
            
            OutlookeventCreatingWrapper.start st =new OutlookeventCreatingWrapper.start();
            st.timeZone = timezone; //pass meter ===>old vlaue : Pacific Standard Time
            st.dateTimes = meetDate+'T'+startTime+':00:00';//'2019-03-15T14:00:00';
            
            OutlookeventCreatingWrapper.location nt = new OutlookeventCreatingWrapper.location();
            nt.displayName = 'Utilitarianlab Office';
            
            OutlookeventCreatingWrapper.ends ed =new OutlookeventCreatingWrapper.ends();
            ed.timeZone = timezone;// pass meter
            ed.dateTimes = meetDate+'T'+EndeTime+':00:00';//'2019-03-15T15:00:00';
            
            List<OutlookeventCreatingWrapper.attendees> attList = new List<OutlookeventCreatingWrapper.attendees>();
            
            List<String> EmailList = new List<String>();
            
            if (Email!='' && Email!=null){
                EmailList = Email.split(',', 0);
            }
            system.debug('EmailList--'+EmailList);
            map<string,String> Emailbyname = new map<string,String>();
            
            List<Lead> LeadList= [select id,name,Email from Lead where email in:EmailList];
            
            for(Lead led : LeadList){
                Emailbyname.put(led.name,led.Email);
            }
            
            system.debug('EmailbynameMap == > '+Emailbyname);
            System.debug('Email Value ==== >'+Emailbyname.values());
            for(String abc: EmailList){
                OutlookeventCreatingWrapper.emailAddress ea = new OutlookeventCreatingWrapper.emailAddress();
                ea.address = abc;
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
            
            System.debug('jsonString >> '+jsonString); 
            
            String eventLink = OutlookIntegration.createevent(jsonString);
            
            System.debug('eventLink >> '+eventLink);
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    //===========================================================================================================================================================
    @AuraEnabled
    public static String createevent(String jasonString) {
        try{
            System.debug('jason String Generate Event >> '+jasonString);
            String endPoint = 'https://graph.microsoft.com/v1.0/me/events';
            String accToken = OutlookIntegration.generateAcessToken();
            System.debug('accToken === >'+accToken);
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
                System.debug('respWrapObj createevent == >'+respWrapObj);
                System.debug('Meeting Link ====> ' +respWrapObj.webLink);
                return respWrapObj.webLink; 
            }else{
                System.debug('res fail >>> '+res.getStatusCode()+' && body >> '+res.getBody());
                return 'Fail';
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
    }
    
    //===========================================================================================================================================================
    @AuraEnabled
    public static String generateAcessToken(){
        String endPoint ;
        String endpointURL = 'https://login.microsoftonline.com/common/oauth2/token';
        String username = 'shubham.kumar@utilitarianlab.com';
        String password = '2910@Shubh';
        String cliendId = 'eb2065a2-6760-4788-aa14-c537f30e122b';
        String clientSecret = 'unu8Q~Oslh0sOo3NGeDwPH-hrJQ6uJgiunGyib9B';
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
            System.debug('respWrapObj === >'+respWrapObj);
            system.debug('access ===> '+respWrapObj.access_token); 
            return respWrapObj.access_token;
        }catch(Exception e){
            system.debug('exception::'+e.getMessage()+e.getLineNumber());
            return 'ERROR';
        }
    } 
    
}