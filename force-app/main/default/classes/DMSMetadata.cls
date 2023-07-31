public class DMSMetadata {
    @future(callout=true)
	public static void createLookupField(String objName){
        try{
            String fieldName = (objName.contains('__c')?objName:objName+'__c');
            String fullName = 'Folder__c.'+fieldName;//Account__c apiname
         	MetadataService.MetadataPort service = createService();
            MetadataService.CustomField customField = new MetadataService.CustomField();
            customField.fullName = fullName;
            customField.label = fieldName; //Account
            customField.type_x = 'Lookup';
            customField.relationshipLabel = 'Folders';
            customField.relationshipName = 'Folders';
            customField.referenceTo = objName;
            List<MetadataService.SaveResult> results =
                service.createMetadata(
                    new MetadataService.Metadata[] { customField });
            handleSaveResults(results[0]); 
            
            updateFieldLevelSecurity(fieldName);
          }catch(Exception e){
              System.debug('Error---'+e.getMessage());
          }
    }
    
    public static void updateFieldLevelSecurity(String objName)
    {
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile admin = new MetadataService.Profile();
        admin.fullName = 'Admin';
        admin.custom = false;
        MetadataService.ProfileFieldLevelSecurity fieldSec = new MetadataService.ProfileFieldLevelSecurity();
        fieldSec.field='Folder__c.'+objName;
        fieldSec.editable=true;
        admin.fieldPermissions  = new MetadataService.ProfileFieldLevelSecurity[] {fieldSec} ;
        List<MetadataService.SaveResult> results =
            service.updateMetadata(
                new MetadataService.Metadata[] { admin });
        handleSaveResults(results[0]);
    }
    
    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

    /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleSaveResults(MetadataService.SaveResult saveResult)
    {
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
    }
    
     public class MetadataServiceExamplesException extends Exception { }
}