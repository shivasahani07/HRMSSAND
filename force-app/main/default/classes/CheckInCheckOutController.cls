public class CheckInCheckOutController {

   @AuraEnabled(cacheable=true)
    Public Static Boolean CheckAttendesRecord(){
        Boolean AttendesMaster;
        Id CurrentLoginUserId=UserInfo.getUserId();
        List<Attendance_Master__c> AttendesList=[Select Id,Date__c,User__c From Attendance_Master__c Where User__c=:CurrentLoginUserId AND Date__c=:system.today()];
        System.debug('AttendesList--'+AttendesList);
        if(AttendesList.size()>0){
          AttendesMaster=true;
        }else{
          AttendesMaster=false;
        }
        System.debug('AttendesMaster--'+AttendesMaster);
        return AttendesMaster;
    }

     @AuraEnabled
    Public Static String HandleCheckIn(){

        DateTime Session=system.now();
        Date TodaysDate=date.newinstance(Session.year(), Session.month(), Session.day());
        String s = Session.format('HH:mm:ss');
        system.debug('s--'+s);

        String[] strTimeSplit = s.split(':');
        system.debug('strTimeSplit--'+strTimeSplit);
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                        ,Integer.valueOf(strTimeSplit[1]) //min
                        ,0                                //sec
                        ,0);                                
        system.debug('timeChange--'+timeChange);

          Id CurrentLoginUserId=UserInfo.getUserId();
          Attendance_Master__c AttendesRec=new Attendance_Master__c();
          AttendesRec.User__c=CurrentLoginUserId;
          AttendesRec.Date__c=TodaysDate;
          AttendesRec.Candidate__c='0030k00001QuuwaAAB';
          Insert AttendesRec;

          if(AttendesRec.Id!=null){
              Daily_Attendance_Tracker__c DATRec=new Daily_Attendance_Tracker__c();

              DATRec.Attendance_Master__c=AttendesRec.Id;
              DATRec.Check_In_Time__c=timeChange;
              DATRec.Candidate__c='0030k00001QuuwaAAB';

              Insert DATRec;
          }

          return 'SUCCESS';
    }

    @AuraEnabled
    Public Static String HandleCheckOut(){

        Id CurrentLoginUserId=UserInfo.getUserId();
        DateTime Session=system.now();
        String s = Session.format('HH:mm:ss');
        system.debug('s--'+s);

        String[] strTimeSplit = s.split(':');
        system.debug('strTimeSplit--'+strTimeSplit);
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                        ,Integer.valueOf(strTimeSplit[1]) //min
                        ,0                                //sec
                        ,0);                                
        system.debug('timeChange--'+timeChange);
        List<Attendance_Master__c> AttendesList=[Select Id,Date__c,User__c From Attendance_Master__c Where User__c=:CurrentLoginUserId AND Date__c=:system.today()];
        List<Daily_Attendance_Tracker__c> DailyAttendesList=[Select Id,Attendance_Master__c,Candidate__c,Check_In_Time__c,Check_Out_Time__c From Daily_Attendance_Tracker__c Where Attendance_Master__c=:AttendesList[0].Id AND Check_Out_Time__c=null];
        System.debug('DailyAttendesList--'+DailyAttendesList);
        if(!DailyAttendesList.isEmpty()){
            for(Daily_Attendance_Tracker__c DAT:DailyAttendesList){
                DAT.Check_Out_Time__c=timeChange;
            }
        }
        
       Update DailyAttendesList;

       return 'SUCCESS';
    }

    @AuraEnabled
    Public Static String HandleEndBreakTime(){

        Id CurrentLoginUserId=UserInfo.getUserId();
        DateTime Session=system.now();
        String s = Session.format('HH:mm:ss');
        system.debug('s--'+s);

        String[] strTimeSplit = s.split(':');
        system.debug('strTimeSplit--'+strTimeSplit);
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                        ,Integer.valueOf(strTimeSplit[1]) //min
                        ,0                                //sec
                        ,0);                                
        system.debug('timeChange--'+timeChange);

        List<Attendance_Master__c> AttendesList=[Select Id,Date__c,User__c From Attendance_Master__c Where User__c=:CurrentLoginUserId AND Date__c=:system.today()];
        if(!AttendesList.IsEmpty()){

              Daily_Attendance_Tracker__c DATRec=new Daily_Attendance_Tracker__c();

              DATRec.Attendance_Master__c=AttendesList[0].Id;
              DATRec.Check_In_Time__c=timeChange;
              DATRec.Candidate__c='0030k00001QuuwaAAB';

              Insert DATRec;  
        }
        List<Break_Time_Tracker__c> BTTRecList=[Select Id,Start_Time__c,User__c,End_Time__c,Candidate__c From Break_Time_Tracker__c Where Attendance_Master__c=:AttendesList[0].Id];
        for(Break_Time_Tracker__c Btt:BTTRecList){
            Btt.End_Time__c=timeChange;
        }
         Update BTTRecList;

        return 'SUCCESS';
        
    }

     @AuraEnabled
    Public Static String HandleStartBreakTime(){

        Id CurrentLoginUserId=UserInfo.getUserId();
        DateTime Session=system.now();
        String s = Session.format('HH:mm:ss');
        system.debug('s--'+s);

        String[] strTimeSplit = s.split(':');
        system.debug('strTimeSplit--'+strTimeSplit);
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                        ,Integer.valueOf(strTimeSplit[1]) //min
                        ,0                                //sec
                        ,0);                                
        system.debug('timeChange--'+timeChange);
        List<Attendance_Master__c> AttendesList=[Select Id,Date__c,User__c From Attendance_Master__c Where User__c=:CurrentLoginUserId AND Date__c=:system.today()];
        List<Daily_Attendance_Tracker__c> DailyAttendesList=[Select Id,Attendance_Master__c,Candidate__c,Check_In_Time__c,Check_Out_Time__c From Daily_Attendance_Tracker__c Where Attendance_Master__c=:AttendesList[0].Id AND Check_Out_Time__c=null];
        System.debug('DailyAttendesList--'+DailyAttendesList);
        if(!DailyAttendesList.isEmpty()){
            for(Daily_Attendance_Tracker__c DAT:DailyAttendesList){
                DAT.Check_Out_Time__c=timeChange;
            }
        }
        
       Update DailyAttendesList;

       Break_Time_Tracker__c BTT=new Break_Time_Tracker__c();
       BTT.Candidate__c='0030k00001QuuwaAAB';
       BTT.User__c=CurrentLoginUserId;
       BTT.Start_Time__c=timeChange;
       BTT.Attendance_Master__c=AttendesList[0].Id;

       Insert BTT;


       return 'SUCCESS';
    }

    

}