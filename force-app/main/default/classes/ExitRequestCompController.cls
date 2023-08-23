public without sharing class ExitRequestCompController {

@AuraEnabled(cacheable=true)
public static Contact getEmployeeDetails(String employeeId){
    try{
        system.debug('employeeId ==> '+employeeId);
        Contact employeeDetails = [Select Id,Name,MobilePhone,Email From Contact WHERE Id =: employeeId];
        return employeeDetails;
    }catch(Exception e){
        return null;
    }
}

@AuraEnabled
public static string saveExitRequestDetails(Exit_Request__c exitReq, Contact contactRecord){
    try{
        system.debug('exitReq ==> '+exitReq);
        if(exitReq != null){
          insert exitReq;
        }
        if(contactRecord != null){
          update contactRecord;
        }
        return 'SUCCESS';
    }catch(Exception e){
        return e.getMessage()+e.getLineNumber();
    }
}
}