global class AuthenticationUriRequest {
    //This Var Will Return Authentication URI Once Constructoir Being Called
    global String authenticationUri='';
    //Constructor
    global AuthenticationUriRequest(String clientKey,String redirectUri){
      	//Encoding Strings
        String key=EncodingUtil.urlEncode(clientKey,'UTF-8');
        String uri=EncodingUtil.urlEncode(redirectUri,'UTF-8');
        String statevalue=EncodingUtil.urlEncode('DineshHome','UTF-8');
        //Authentication URI With Required Parameters To Authenticate
        String authUri='https://accounts.google.com/o/oauth2/v2/auth?'+
 						'client_id='+key+
                         '&response_type=code'+
                         '&scope=https://www.googleapis.com/auth/drive'+
                         '&redirect_uri='+uri+
                         '&login_hint=ajeet.kumar6171@gmail.com'+
                         'access_type=offline';
        authenticationUri=authUri;
    }
}