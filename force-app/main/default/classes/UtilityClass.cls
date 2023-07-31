public class UtilityClass {
    
    public static RecordType getRecordTypeDetails(String sobjectName, String devName){
        return [select id,Name,developerName,sobjectType 
                FROM RecordType  
                WHERE sobjectType =:sobjectName
                AND developerName =:devName];
    }
    
    public static Map<String,Id> getRecordTypeIdByDevName(String sobjectAPIName){
        Map<String,Id> recordTypeMap 	= new Map<String,Id>();//Key -> RecordType DeveloperName && Id -> recordTypeId
        List<RecordType> recordTypeList = [select Id,Name,developerName,sobjectType  
                                           FROM RecordType 
                                           WHERE sObjectType=:sobjectAPIName];
        for(RecordType recType : recordTypeList){
            if(!recordTypeMap.containsKey(recType.developerName)){
                recordTypeMap.put(recType.developerName,recType.Id);
            }
        } 
        return recordTypeMap;  
    }


     /*
    *@Purpose :To get picklist values for a given picklist field
    *@param : Schema.DescribeFieldResult fieldResult
    *@returnType : List of picklist values
    */
    public static List<String> getPickListValues(Schema.DescribeFieldResult fieldResult){

        List<String> pickListValues     = new List<String>();        
        List<Schema.PicklistEntry> pickListEntry = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry pick : pickListEntry)
        {
            pickListValues.add(pick.getValue());
        }       
        return pickListValues;
    }

    
}