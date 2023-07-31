public without sharing class GMeetAPIHandler {

    private static final String GOOGLECALENDARENDPOINT = 'https://www.googleapis.com/calendar/v3';

    @future(callout=true)
    public static void generateMeetLink_V2(String bId){

        List<Map<String,String>> emailMapList = new List<Map<String,String>>();
        Map<String,String> emailMap = new Map<String,String>();
        
        
        Booked_Slot__c bs = [Select Id,Name,Date__c,OwnerId,Start_Time__c,End_Time__c,Email__c From Booked_Slot__c Where Id=:bId];
        Booked_Slot__c updatedbs = new Booked_Slot__c();
        updatedbs.id = bId;
        emailMap.put('email', bs.Email__c);
        emailMapList.add(emailMap);

        //=============== for dateTime ========================================
        //time starttime = createTime(bs.Start_Time__c);
        datetime StartDatetime = Datetime.newInstance(bs.Date__c,(bs.Start_Time__c));
        
        System.debug('StartDatetime =======> ' + StartDatetime);
        System.debug('StartDatetime serialize =======> ' + JSON.serialize(StartDatetime));

        datetime EndDateTime = Datetime.newInstance(bs.Date__c,(bs.End_Time__c));
        System.debug('EndDateTime =======> ' + EndDateTime);
        System.debug('EndDateTime  serialized =======> ' + JSON.serialize(EndDateTime));

        String endPoint = '/primary/events?conferenceDataVersion=1&maxAttendees=5&sendNotifications=true&sendUpdates=all&supportsAttachments=true';
    
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        
        req.setEndpoint('callout:Google_Meet'+endPoint);
        req.setHeader('content-type', 'application/json');
      

        //String body = '{"summary":"MT New Meeting","end": {"dateTime": "2022-10-28T09:30:00-08:00","timeZone": "America/Los_Angeles"},"start": {"dateTime": "2022-10-28T10:30:00-07:00","timeZone": "America/Los_Angeles"},"conferenceData": {"createRequest": {"conferenceSolutionKey": {"type": "hangoutsMeet"},"requestId": "test"}},"attendees":[{"email":"bhaskarjha514@gmail.com"},{"email":"baskijha514@gmail.com"}]}';
        // String updatedbodylog = {"summary":Meeting with Shubham,"end": {"dateTime": "2022-10-20T07:00:00.000Z","timeZone": "Asia/Kolkata"},"start": {"dateTime": "2022-10-20T06:30:00.000Z","timeZone": "Asia/Kolkata"},"conferenceData": {"createRequest": {"conferenceSolutionKey": {"type": "hangoutsMeet"},"requestId": "test"}},"attendees":[{"email":"jengaakash@gmail.com"}]} 
        string updatedBody = '{"summary":' + JSON.serialize(bs.Name) + ',"end": {"dateTime": ' + JSON.serialize(EndDateTime) + ',"timeZone": "Asia/Kolkata"},"start": {"dateTime": ' + JSON.serialize(StartDatetime) + ',"timeZone": "Asia/Kolkata"},"conferenceData": {"createRequest": {"conferenceSolutionKey": {"type": "hangoutsMeet"},"requestId": "test"}},"attendees":'+JSON.serialize(emailMapList)+'}';
        System.debug('updatedBody =======> ' + updatedBody);
        req.setBody(updatedBody);
        req.setHeader('Content-length', String.valueOf(updatedBody.length()));
        req.setTimeout(60 * 1000);
        HttpResponse resp = http.send(req);
        System.debug('Response-----' + resp.getBody());
        if(resp.getStatusCode()==200||resp.getStatusCode()==201){
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
            //responseMap.put('event_url', m.get('hangoutLink').toString());
            //responseMap.put('event_id', m.get('id').toString());
            //return responseMap;
            
            
            if (m.get('hangoutLink') != null) {
                updatedbs.Meeting_Link__c = m.get('hangoutLink').toString();
            }
        }
        update updatedbs;


        Task inv_task = new Task();
        inv_task.OwnerId = bs.OwnerId;
        inv_task.Subject ='Meeting with '+bs.Name;  
        inv_task.Status = 'Not Started';
        inv_task.Priority = 'High';
        inv_task.WhatId   = bId;
        inv_task.IsReminderSet = true;
        inv_task.ReminderDateTime = StartDatetime.addhours(-1);
        inv_task.ActivityDate = date.newinstance(StartDatetime.year(), StartDatetime.month(), StartDatetime.day());
        insert inv_task;



        //return 'Success';
    }


    public static Time createTime(Long lTime){
        Long milliseconds = lTime;
        Long mins = milliseconds / 60000;
        Long hours = mins / 60;
        Long remainingMins = mins - (hours * 60);

        return Time.newInstance(hours.intValue(),remainingMins.intValue(),0,0);
        //String totalTime = String.valueOf(hours) + ' hrs ' +  String.valueOf(remainingMins) +' mins';
    }
}