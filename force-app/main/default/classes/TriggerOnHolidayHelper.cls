public class TriggerOnHolidayHelper {
    //create bydefualt some hoidays whenever new contact will be created shall addthis from custom setting..? bhaiya
    Public Static void CommonHolidays(List<Contact> newContacts){
        system.debug('newContacts--'+newContacts);
        list<Holiday__c> commonHilidaysLIst= new list<Holiday__c>();
        String dateString = '2023-07-15';
        List<String> standardHolidays  = new List<string>();
        standardHolidays.add('2023-07-15');
        standardHolidays.add('2023-08-15');
        standardHolidays.add('2023-08-02');
        Date convertedDate = Date.valueOf(dateString);
        for(contact con:newContacts){
            for(String str : standardHolidays){
                Holiday__c createHolidat = new Holiday__c();
                createHolidat.Contact__c=con.Id;
                createHolidat.Type__c='Company Event';
                createHolidat.Status__c='Approved';
                createHolidat.Type__c = 'Govt Holiday';
                createHolidat.Start_Date__c= Date.valueOf(str);//convertedDate;
                createHolidat.End_Date__c=convertedDate.addDays(1);
                createHolidat.Manager__c='0052v00000jEssmAAC';
                commonHilidaysLIst.add(createHolidat);
            }
           
        }  
        
        if(!commonHilidaysLIst.isEmpty()){
            insert commonHilidaysLIst;
        }
    }
    
}