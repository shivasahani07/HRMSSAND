global without sharing class CommunitiesLoginController {
    
    
    public String username { get; set; }
    public String password { get; set; }
    public String hashCode { get; set; }
    public Boolean isLoggedIn { get; set; }
    public String targetUrl { get; set; }
    public CommunitiesLoginController() {
        isLoggedIn = false;
    }
    
    public PageReference performLogin() {
        // Add your custom login logic here
        // For simplicity, let's assume we are using a hardcoded username and password for demonstration purposes
        system.debug('username =====> ' + username);
        
        List<Account> acc = [select id,CRM__c from account LIMIT 5];
        system.debug('acc =====> ' + acc);
        List<contact> getUser=[SELECT id,name,email,Password__c,Login_Hash_Code__c from Contact WHERE email =:username];
        system.debug('getUser =====> ' + getUser);
        //String expectedUsername = 'shiva.sahani07@gmail.com';
        //String expectedPassword = 'Shiva@123';
        
        String expectedUsername = getUser[0].email;
        String expectedPassword = getUser[0].Password__c;
        
        if (username == expectedUsername && password == expectedPassword) {
            // Successful login, generate and store the hashcode for the logged-in user
            Long randomLong = Crypto.getRandomLong();
            Long positiveRandomLong = Math.abs(randomLong);
            hashCode = String.valueOf(positiveRandomLong);
            Contact addHascode = new contact ();
            addHascode.Login_Hash_Code__c=hashCode;
            addHascode.Id=getUser[0].id;
            update addHascode;
            isLoggedIn = true;
            system.debug('hashCode---'+hashCode);
            targetUrl = Page.CandidateOnboard.getUrl() + '?hashCode=' + EncodingUtil.urlEncode(hashCode, 'UTF-8');
            
            // Redirect to the home page or any other desired page
            PageReference redirectPage = new PageReference(targetUrl);
            redirectPage.setRedirect(true);
            return redirectPage;
        } else {
            // Failed login, show an error message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid credentials'));
            return null;
        }
    }
    
    public PageReference performLogout( String recordId) {
        // Clear the hash code and redirect to the logout page
        contact getUser = [SELECT Id, Login_Hash_Code__c FROM Contact WHERE Id =:recordId LIMIT 1];
        system.debug('getUser---'+getUser);
        if (getUser != null) {
            // Remove the hash code from the Contact record
            system.debug('getUser if not null---');
            getUser.Login_Hash_Code__c = null;
            update getUser;
        }
        
        // Clear the hash code and isLoggedIn flag in the controller
        targetUrl = null;
        hashCode = null;
        isLoggedIn = false;
        
        // Redirect to the logout page
        
        return null;
    }
    
    Public PageReference performSingUp(){
        return null;
        
    }
    
}