public class CaseCreateHttpUtility {
 static Target_Org_Configuration__c orgObj;
    static CaseCreateHttpUtility httpUtilityInstance;
    
    private CaseCreateHttpUtility() {}
    
    public static CaseCreateHttpUtility getInstance() {
        if(httpUtilityInstance == null) {
            httpUtilityInstance = new CaseCreateHttpUtility();
            orgObj = Target_Org_Configuration__c.getInstance();
        }
        return httpUtilityInstance;
    }
    
    public void createServiceLogger(String reqBody, String resBody, String endPoint, String method, Integer statusCode, DateTime startDatetime, DateTime endDateTime) {
        try {
            if(orgObj != null && orgObj.Enable_Apex_Service_Logger__c) {
                Integration_Log__c logger = new Integration_Log__c();
                logger.HTTP_Method__c = method;
                logger.Integration_Type__c = 'SERVICE';
                logger.Request_Body__c = reqBody;
                logger.Response_Body__c = resBody;
                logger.EndPoint__c = endPoint;
                logger.Response_Status_Code__c = statusCode;
                logger.Start_Date_And_Time__c = startDatetime;
                logger.End_Date_And_Time__c = endDatetime;
                insert logger;
            }
        }catch(DMLException e){
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());
           // HandleBusinessException.captureError('HttpUtility', 'httpReqHelper', e);
        }
    }
    
}