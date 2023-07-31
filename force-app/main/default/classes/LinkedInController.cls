public class LinkedInController {
    
    public static string accessToken = 'AQXKlwD85-te3z77Pc4tCpxrEKif80pP_4JxcsYPtNLmrmnPUwnY3cEPyQe11eRBdljbUFr_2nVY7lTMgU3awuLck2QZD5d1uEGcPUAGRPPWOm-WtLshXiW3o8z6Kk3LPhRKbsMvnLSgcPaozwt-onSCffa9X3nFRKiKmpp-yqulOjrQwiGcIQ0vbNidnhNtxcC67EJvP2xXjxe92J8sQFKYrtnXlXWVyDl6VcMUxThvAZTo6Lre9tMzP3cOXVtFbNE9GavlCrncLg2klCYjjxXaIH8Y6ckwVEpYgsyAJV0M7qfmuALkLBPpJA4t7qPPNyAycApbUNYjGbfI80HTyTFh8D6BLQ';
    public static string endpoint = 'https://api.linkedin.com/v2/ugcPosts';
    
    
    
    public static void sharePost(String content) {
    
        String postUrl = 'https://api.linkedin.com/v2/ugcPosts';
        String author = 'urn:li:person:6_cBTt0pkt';
        String lifecycleState = 'PUBLISHED';
        String specificContent = '';
        // Set the request headers
        Map<String, String> headers = new Map<String, String>();
        headers.put('Authorization', 'Bearer ' + accessToken);
        headers.put('Content-Type', 'application/json');
        
        // Set the request body
        Map<String, Object> shareBody = new Map<String, Object>();
        shareBody.put('author', 'urn:li:person:' + author);
        shareBody.put('lifecycleState', lifecycleState);
        shareBody.put('visibility', new Map<String, Object>{'com.linkedin.ugc.MemberNetworkVisibility' => 'PUBLIC'});
        
        
        Map<String, Object> specificContentMap = new Map<String, Object>();
        specificContentMap.put('com.linkedin.ugc.ShareContent', new Map<String, Object>{
            'shareCommentary' => new Map<String, Object>{'text' => 'Sample post commentary'},'shareMediaCategory' => 'NONE','media' => new List<Map<String, Object>>{
                new Map<String, Object>{'status' => 'READY','originalUrl' => 'https://example.com/image.jpg','description' => new Map<String, Object>{'text' => 'Image description'}}}});
        
        
        Map<String, Object> payload = new Map<String, Object>{
    'author' => 'urn:li:person:6_cBTt0pkt',
    'lifecycleState' => 'PUBLISHED',
    'specificContent' => new Map<String, Object>{
        'com.linkedin.ugc.ShareContent' => new Map<String, Object>{
            'shareCommentary' => new Map<String, Object>{
                'attributes' => new List<Object>(),
                'text' => content
            },
            'shareMediaCategory' => 'NONE'
        }
    },
    'visibility' => new Map<String, Object>{
        'com.linkedin.ugc.MemberNetworkVisibility' => 'PUBLIC'
    }
};
        
        shareBody.put('specificContent', specificContentMap);
        system.debug('shareBody'+shareBody);
        // Create the request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(postUrl);
        request.setMethod('POST');
      
        
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+accessToken);
        request.setBody(JSON.serialize(payload));
        
        // Send the request
        HttpResponse response = new Http().send(request);
        
        // Check the response status
        if (response.getStatusCode() == 201) {
            System.debug('Post shared successfully.');
        } else {
            System.debug('Error sharing post. Status code: ' + response.getStatusCode() + ', Body: ' + response.getBody());
        }
    }
}