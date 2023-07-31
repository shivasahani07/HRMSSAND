public class LinkedInAccessTokenGenerator {
    
    public static String clientId = '8616g88zw0z5c2';
    public static String clientSecret = 'rM9IkCZcF5fnuqgN';
    //public static String grantType = 'authorization_code';
    public static String redirectUri = 'https://sales-production--hrmsdemo.sandbox.my.salesforce.com';
    public static String authorizationCode = 'AQR6wKepYw1lOhLL6M6PUEZh06ZceesEXd4wXPe__o-ZWI3VtZ1LjwPHOTs12posN5Bm2G8BGpHgljPJ4mqVIgKInJFQ-QDCWAHsAvr68S8ZLMnWC8MLi2qQI-ekXdRtY4JsbbLQBel32aQQnkTv4Z8zsyGgW-Z3VqeQDmlb9Fmj6hfrJMRt1dS65PGJlahEwF9TLupkjW-iqAiqwjU';
    
    public static String getAccessToken() {
        String tokenUrl = 'https://www.linkedin.com/oauth/v2/accessToken';
        String grantType = 'authorization_code';
        
        // Set the request parameters
        Map<String, String> params = new Map<String, String>();
        params.put('grant_type', grantType);
        params.put('client_id', clientId);
        params.put('client_secret', clientSecret);
        params.put('redirect_uri', redirectUri);
        params.put('code', authorizationCode);
        
        // Create the request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(tokenUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(getUrlEncodedString(params));
        
        // Send the request
        HttpResponse response = new Http().send(request);
        system.debug('response.getBody()'+response.getBody());
        // Parse the response
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
        // Retrieve the access token
        String accessToken = (String) responseMap.get('access_token');
        system.debug('accessToken'+accessToken);
        return accessToken;
    }
    
    private static String getUrlEncodedString(Map<String, String> params) {
        List<String> keyValuePairs = new List<String>();
        for (String key : params.keySet()) {
            String value = EncodingUtil.urlEncode(params.get(key), 'UTF-8');
            keyValuePairs.add(key + '=' + value);
        }
        return String.join(keyValuePairs, '&');
    }
}