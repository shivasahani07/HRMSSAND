public without sharing class UserTriggerHandler {
    
    static UserTriggerHandler userTriggerHandlerObj;

    public static UserTriggerHandler getInstance(){
        if(userTriggerHandlerObj==null)
            userTriggerHandlerObj = new UserTriggerHandler();
        return userTriggerHandlerObj;
    }


    public void afterInsert(Map<Id,User> userMap){
        createAvailabilityRecords(userMap);
    }

    public void afterUpdate(Map<Id,User> oldUserMap, Map<Id,User> newUserMap){

        Map<Id,User> userChangedMap = new Map<Id,User>();

        for(User u : newUserMap.values()){
            if((newUserMap.get(u.Id).Working_Days__c != oldUserMap.get(u.Id).Working_Days__c) || 
                (newUserMap.get(u.Id).Working_End_Time__c != oldUserMap.get(u.Id).Working_End_Time__c) ||
                (newUserMap.get(u.Id).Working_Start_Time__c != oldUserMap.get(u.Id).Working_Start_Time__c) ||
                (newUserMap.get(u.Id).Start_Date__c != oldUserMap.get(u.Id).Start_Date__c) ||
                (newUserMap.get(u.Id).End_Date__c != oldUserMap.get(u.Id).End_Date__c)
                ){
                userChangedMap.put(u.Id,u);
            }
        }

        if(!userChangedMap.isEmpty()){
            deleteAvailabilityRecords(userChangedMap);
            createAvailabilityRecords(userChangedMap);
        }
    }


    private void deleteAvailabilityRecords(Map<Id,User> userMap){
        List <Availability__c>  avList = [Select Id From Availability__c Where  OwnerId IN:userMap.keySet()];
        if(!avList.isEmpty()){
            delete avList;
        }   
    }

    private void createAvailabilityRecords(Map<Id,User> userMap){
        List<Availability__c> avList = new List<Availability__c>();

        for(User u : userMap.values()){
            Date startDate = u.Start_Date__c;
            Date endDate = u.End_Date__c;

            integer diffInDays = startDate.daysBetween(endDate)+1;

            for(integer i=0;i<diffInDays;i++){
                Date currentDate = startDate.addDays(i);

                Availability__c av = new Availability__c();

                av.Name = u.firstName +' - '+currentDate.format();
                av.Date__c = currentDate;
                av.Start_Time__c = u.Working_Start_Time__c;
                av.End_Time__c = u.Working_End_Time__c;
                av.OwnerId = u.Id;

                Datetime dt = (DateTime)currentDate;
                String dayOfWeek = dt.format('EEEE');

                if(!String.isEmpty(u.Working_Days__c) && u.Working_Days__c.containsIgnoreCase(dayOfWeek)){
                    avList.add(av);
                }
            }
        }

        if(!avList.isEmpty()){
            insert avList;
        }
    }
}