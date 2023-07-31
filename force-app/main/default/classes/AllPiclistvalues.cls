public class AllPiclistvalues {
    Public static List<string> getAllPicklistsValues( String objectApiName){
        
        // Assuming you are querying the picklist fields for the "Opportunity" object
        
        // Describe the object to retrieve its metadata
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        
        // Get all fields for the object
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        
        // Create a list to store picklist fields and their values
        List<String> picklistFieldsWithValues = new List<String>();
        
        // Iterate through the fields to identify picklist fields and retrieve their values
        for (String fieldName : fieldMap.keySet()) {
            Schema.SObjectField field = fieldMap.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            // Check if the field is a picklist field
            if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                // Get the picklist field values
                List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
                
                // Add the picklist field and its values to the list
                picklistFieldsWithValues.add(fieldName + ': ' + picklistValues);
                System.debug(picklistFieldsWithValues);
            }
        }
        
        // Now you have a list of picklist fields and their corresponding values for the object
        // You can use this list as needed, such as displaying it on a Visualforce page or logging it
       // System.debug(picklistFieldsWithValues);
        return picklistFieldsWithValues;
        
    }
    
}