public without sharing class GMeetAuthHandler {
    private static final String GOOGLECALENDARENDPOINT = 'https://www.googleapis.com/calendar/v3';
    private static final String GOOGLESERVICEACCOUNT = 'gmeet-307@aerobic-mile-365201.iam.gserviceaccount.com';
    private static final String AUDIENCE_CLAIM = 'https://www.googleapis.com/oauth2/v4/token';
    private static final String CERTIFICATE = 'googlecalendarcertificate'; // this is the name/label of the jks certificate we uplodaded in salesforce
    private static final String SCOPE = 'https://www.googleapis.com/auth/calendar';
    
    public static void call() {
        String requestUri = '/users/me/calendarList';
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(GOOGLECALENDARENDPOINT + requestUri);
        request.setMethod('GET');
    
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + getAccessToken());
    
        HttpResponse response = http.send(request);
        String jsonResponse = response.getBody();
        system.debug(jsonResponse);
    }
    
    public static String getAccessToken() {
        Auth.JWT jwt = new Auth.JWT();
        jwt.setAud(AUDIENCE_CLAIM);
        jwt.setIss(GOOGLESERVICEACCOUNT);
       // jwt.setSub('baskijha514@gmail.com');
        jwt.setAdditionalClaims(new Map<String, Object>{ 'scope' => SCOPE });
    
        Auth.JWS jws = new Auth.JWS(jwt, CERTIFICATE);
    
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(
        jwt.getAud(),
        jws
        );
    
        return bearer.getAccessToken();
    }
}