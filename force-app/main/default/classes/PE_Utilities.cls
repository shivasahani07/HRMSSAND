/* -----------------------------------------------------------------------------------------------------------------------
   Name:        PE_Utilities.cls
/*****************************************************************************************
@=========================================================================================
@=========================================================================================
@Purpose:  This method will check is event is disabled or not
@
@=========================================================================================
@History                                                            
@----------                                                            
@VERSION AUTHOR            DATE             DETAIL                                 
@1.0 - keshab Maity        16/10/2015       INITIAL DEVELOPMENT               
******************************************************************************************/ 
public with sharing class PE_Utilities{

    public static String AFTER_INSERT ='After_Insert__c';
    public static String BEFORE_INSERT='Before_Insert__c';
    
    public static String AFTER_UPDATE ='After_Update__c';
    public static String BEFORE_UPDATE='Before_Update__c';
    
    public static String AFTER_DELETE ='After_Delete__c';
    public static String BEFORE_DELETE='Before_Delete__c';
    
    public static String AFTER_UNDELETE='After_Undelete__c';
    
    public static boolean checkDisabledTriggerEvent(String TriggerControllerName,String event) {
        boolean isDisabled=false;
        try{            
            PE_Trigger_Controller__c triggerController =PE_Trigger_Controller__c.getValues(TriggerControllerName);            
            if(triggerController<>null && triggerController.IsActive__c==true){
                if(triggerController.get(event)!=true){
                    isDisabled=true;
                }                   
            }
            return isDisabled;
        }catch(Exception e){
            return false;
        }
    }
    
    
/*****************************************************************************************
@Purpose:  Return all recordtype in  map<id,name>
@=========================================================================================                                                          
@VERSION AUTHOR            DATE             DETAIL                                 
@1.0 - keshab Maity        16/06/2014       INITIAL DEVELOPMENT               
******************************************************************************************/ 
    public static Map<String, String> getRecordTypes(String objType) {
        List<RecordType> rTypes = [SELECT Name, Id FROM RecordType WHERE sObjectType=:objType AND isActive=true order by Name ASC];
        //system.debug('rTypes======='+rTypes);
        Map<String, String>listRecordTypes = new Map<String, String>{}; 
            for (RecordType rt:rTypes)    
            listRecordTypes.put(rt.Name, rt.Id);       
        return listRecordTypes;    
    }
/*****************************************************************************************
@Purpose:  Set Current USER profile details
@=========================================================================================                                                          
@VERSION AUTHOR            DATE             DETAIL                                 
@1.0 - keshab Maity        23/09/2014       INITIAL DEVELOPMENT               
******************************************************************************************/ 
   Public static String currentUserLicenseName;
   Public static String currentUserID;
    public static String getCurrentUserLicenseName() {
        if((currentUserLicenseName=='' ||  currentUserLicenseName==null) && 
            ( currentUserID==null || currentUserID=='' || currentUserID<> UserInfo.getProfileId())){
            currentUserID=UserInfo.getProfileId();
            Profile pr= [Select  UserLicense.Name, UserLicense.Id, UserLicenseId ,Id  From Profile p where id=:currentUserID limit 1];
            currentUserLicenseName=pr.UserLicense.Name;
            
        }
        return currentUserLicenseName;
    }   




    public static Map<String, String> getRecordTypesKeyId(String objType) {
        List<RecordType> rTypes = [SELECT Name, Id FROM RecordType WHERE sObjectType=:objType AND isActive=true];
        //system.debug('rTypes======='+rTypes);
        Map<String, String>listRecordTypes = new Map<String, String>{}; 
            for (RecordType rt:rTypes)    
            listRecordTypes.put(rt.Id,rt.Name);       
        return listRecordTypes;    
    }      

    public static Map<String,User> getUserRoleId(){
        List<User> usersList=new List<User>();
        usersList=[Select Id,UserRoleId,ManagerId from User];
        Map<String,User> mapUserandRole=new Map<String,User>();
        for(User u:usersList){
            mapUserandRole.put(u.Id, u);
        }
        return mapUserandRole;
    }
    
    
        public static Map<String,UserRole> allRoleMap;
    
    
      public static  Map<String,UserRole> allUserRoleMap(){
        Map<String,UserRole> userRoleMap=new Map<String,UserRole>();
        List<UserRole> userRoleList=new List<UserRole>();
        userRoleList=[Select Id,Name,ParentRoleId from UserRole];

        for(UserRole urObj:userRoleList){
            userRoleMap.put(urObj.Id, urObj);
        }
        return userRoleMap;
    }  
}