public with sharing class CustomLookupCmpController {

    @AuraEnabled(cacheable=true)
    public static List<sObject> getLookupValues(  String searchKeyWord, String objectAPIName, String whereCondition, String fieldNames, Integer customLimit ) {
        String searchKey = '%'+ searchKeyWord + '%';        
        List<sObject> returnList = new List<sObject>();
        String sQuery = 'SELECT Id, Name';
        if(String.isNotBlank(fieldNames) && !fieldNames.equalsIgnoreCase('Name')) {
            sQuery += ','+fieldNames;
        }
        if(String.isNotBlank(whereCondition) && whereCondition != null){
            sQuery +=  ' FROM ' +objectAPIName + ' WHERE ' + fieldNames + ' LIKE \''+searchKey+'\' AND ' + whereCondition + ' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        } else {
            sQuery +=  ' FROM ' +objectAPIName + ' WHERE ' + fieldNames + ' LIKE \''+searchKey+'\' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        }
        system.debug('sQuery === >'+sQuery);
        List<sObject> lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) { returnList.add(obj); }
         system.debug('lstOfRecords === >'+lstOfRecords) ;
        return returnList;
    }
    
    @AuraEnabled(cacheable=true)
    public static sObject getinitRecord(String recordId, String objectAPIName, String fieldNames) {
        String sRecId = recordId;    
        String sQuery = 'SELECT id, Name';
        if(String.isNotBlank(fieldNames)) {
            sQuery += ','+fieldNames;
        }
        sQuery +=  ' FROM ' + objectAPIName + ' WHERE Id = : sRecId LIMIT 1 ';
        for (sObject obj: Database.query(sQuery)) {
            return obj;
        }
        return null;
    }

 

    @AuraEnabled(cacheable=true)
    public static List<sObject> gerRecentlyCreatedRecords( String objectAPIName, String fieldNames, String whereCondition, Integer customLimit){
       List<sObject> returnList = new List<sObject>();
        String sQuery = 'SELECT Id, Name';
        if(String.isNotBlank(fieldNames) && !fieldNames.equalsIgnoreCase('Name')) {
            sQuery += ','+fieldNames;
        }
        if(String.isNotBlank(whereCondition) && whereCondition != null){
            sQuery +=  ' FROM ' +objectAPIName + ' WHERE ' + whereCondition + ' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        } else {
            sQuery +=  ' FROM ' +objectAPIName + ' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        }
         system.debug('sQuery 1 === >'+sQuery) ;
        List<sObject> lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) { returnList.add(obj); }
        return returnList;
    }

}