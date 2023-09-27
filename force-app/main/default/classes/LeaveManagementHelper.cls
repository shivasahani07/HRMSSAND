/**
 * @author Dinesh B
 * @email dinesh.b@utilitarianlab.com
 * @create date 2023-09-19 18:19:15
 * @modify date 2023-09-19 18:19:15
 * @desc [description]
 */

public with sharing class LeaveManagementHelper {
    
    // ==============================================================================================================================================================================
    public static void createLeavePolicy_LeaveCycle_LeaveCreditMetod(List<Employee_Leave_Policy__c> empLeavePolicList){
        System.debug('empLeavePolicList ==== >'+empLeavePolicList);
        List<Employee_Leave_Policy__c> EmpLevPolicyListToQuery = new List<Employee_Leave_Policy__c>();
        List<Leave_Credit__c> LeaveCreditToInsertList = new List<Leave_Credit__c>();
        Map<Id,Employee_Leave_Policy__c> mapOfEmpLevPolicy = new Map<Id,Employee_Leave_Policy__c>();
        Map<String,String> mapOfLeaPolicyId = new Map<String,String>();
        
        try{
            for(Employee_Leave_Policy__c empleave : empLeavePolicList){
                mapOfEmpLevPolicy.put(empleave.id,empleave);
            }
            System.debug('mapOfEmpLevPolicy === >'+mapOfEmpLevPolicy);
            if(mapOfEmpLevPolicy.keySet().size()>0){
                for(Employee_Leave_Policy__c emp : [SELECT Id,Name,Candidate__c,Candidate__r.Joining_Date__c,Leave_Cycle__c,Leave_Policy__c,Leave_Policy__r.Start_Date__c,Leave_Policy__r.End_Date__c,Leave_Cycle__r.Year_Type__c,Leave_Cycle__r.End_Date__c,Leave_Cycle__r.Start_Date__c,Leave_Cycle__r.IsActive__c FROM Employee_Leave_Policy__c WHERE ID IN:mapOfEmpLevPolicy.keySet()]){
                    if(String.isNotBlank(emp.Leave_Policy__c)){
                        mapOfLeaPolicyId.put(emp.id,emp.Leave_Policy__c);
                    }
                    System.debug('mapOfLeaPolicyId === >'+mapOfLeaPolicyId);
                    if(mapOfLeaPolicyId.values().size()>0){
                        for(Leave_Master_Details__c  lms : [SELECT Id,Name,Leave_Master__c,Leave_Policy__c,Leave_Policy__r.Start_Date__c,Leave_Policy__r.End_Date__c,Is_Active__c,Accrual_Based_on__c,Pro_Rated_on_Joining__c,Pay_Type__c FROM Leave_Master_Details__c WHERE Leave_Policy__c IN:mapOfLeaPolicyId.values() AND Is_Active__c = true]){
                             Date LeaveEndDate = emp.Leave_Cycle__r.End_Date__c;
                            if(lms.Accrual_Based_on__c == 'Monthly'){
                                
                                Integer joiningmonth =  emp.Candidate__r.Joining_Date__c.month();
                                System.debug('joiningmonth === >'+joiningmonth);
                                Integer joiningyear =  emp.Candidate__r.Joining_Date__c.year();
                                System.debug('joiningyear === >'+joiningyear);
                                
                                Integer LeavCycleStartmonth;
                                Integer LeavCycleStartyear ;
                                Date LeveStartDate = emp.Leave_Cycle__r.Start_Date__c;
                               
                                Integer DaysCount = emp.Leave_Cycle__r.End_Date__c.day();
                                
                                
                                while(LeveStartDate <=emp.Leave_Cycle__r.End_Date__c){
                                    Leave_Credit__c levcred = new Leave_Credit__c();
                                    if(emp.Leave_Cycle__r.Start_Date__c > emp.Candidate__r.Joining_Date__c){ 
                                        if(lms.Pro_Rated_on_Joining__c == 'Half'){
                                           // levcred.Days__c = DaysCount/2;
                                        }else if(lms.Pro_Rated_on_Joining__c == 'Based on Month Days'){
                                           //  levcred.Days__c = DaysCount/2;
                                        }else if(lms.Pro_Rated_on_Joining__c == 'Custom'){
                                           //  levcred.Days__c = DaysCount/2;
                                        }
                                        System.debug('Inside If  Condition');
                                        levcred.Leave_Policy_Id__c = lms.Leave_Policy__c;
                                        levcred.Candidate__c = emp.Candidate__c;
                                        levcred.Candidate_Id__c = levcred.Candidate__c;
                                        levcred.Employee_Leave_Policy__c = emp.Id;
                                        levcred.Leave_Master_Details__c = lms.Id;
                                        levcred.Effect_Date__c = LeveStartDate;
                                        levcred.Expiry_Date__c = LeaveEndDate;
                                        LeaveCreditToInsertList.add(levcred);
                                    }
                                    else {
                                        System.debug('Inside Else  Condition');
                                        LeavCycleStartmonth =  LeveStartDate.month();
                                        System.debug('LeavCycleStartmonth === >'+LeavCycleStartmonth);
                                        LeavCycleStartyear =  LeveStartDate.year();
                                        System.debug('LeavCycleStartyear === >'+LeavCycleStartyear);
                                        if(LeavCycleStartyear == joiningyear && LeavCycleStartmonth == joiningmonth){
                                            System.debug('Inside the Same Year & Month');
                                            levcred.Leave_Policy_Id__c = lms.Leave_Policy__c;
                                            levcred.Candidate__c = emp.Candidate__c;
                                            levcred.Candidate_Id__c = levcred.Candidate__c;
                                            levcred.Employee_Leave_Policy__c = emp.Id;
                                            levcred.Leave_Master_Details__c = lms.Id;
                                            levcred.Effect_Date__c = LeveStartDate;
                                            levcred.Expiry_Date__c = LeaveEndDate;
                                            LeaveCreditToInsertList.add(levcred);
                                        }
                                    }
                                    LeveStartDate= LeveStartDate.addMonths(1); 
                                  
                                }
                                
                            }
                            else if(lms.Accrual_Based_on__c == 'Quarterly'){
                                for(integer i=1;i<=4;i++){
                                    Leave_Credit__c levcred = new Leave_Credit__c();
                                    levcred.Leave_Policy_Id__c = lms.Leave_Policy__c;
                                    levcred.Candidate__c = emp.Candidate__c;
                                    levcred.Candidate_Id__c = levcred.Candidate__c;
                                    levcred.Employee_Leave_Policy__c = emp.Id;
                                    levcred.Leave_Master_Details__c = lms.Id;
                                    levcred.Effect_Date__c = emp.Leave_Cycle__r.End_Date__c;
                                }
                            }
                            else if(lms.Accrual_Based_on__c == 'Advance'){
                                Leave_Credit__c levcred = new Leave_Credit__c();
                                if(lms.Pro_Rated_on_Joining__c == 'Half'){
                                    // levcred.Days__c = DaysCount/2;
                                }else if(lms.Pro_Rated_on_Joining__c == 'Based on Month Days'){
                                    //  levcred.Days__c = DaysCount/2;
                                }else if(lms.Pro_Rated_on_Joining__c == 'Custom'){
                                    //  levcred.Days__c = DaysCount/2;
                                }
                                
                                levcred.Leave_Policy_Id__c = lms.Leave_Policy__c;
                                levcred.Candidate__c = emp.Candidate__c;
                                levcred.Candidate_Id__c = levcred.Candidate__c;
                                levcred.Employee_Leave_Policy__c = emp.Id;
                                levcred.Leave_Master_Details__c = lms.Id;
                                levcred.Effect_Date__c = emp.Leave_Cycle__r.End_Date__c;
                                levcred.Expiry_Date__c = LeaveEndDate;
                                LeaveCreditToInsertList.add(levcred);
                            }
                        }
                    }
                }
                if(LeaveCreditToInsertList.size()>0){
                    insert LeaveCreditToInsertList;
                    System.debug('LeaveCreditToInsertList == > '+LeaveCreditToInsertList);
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }

    // Method for Applying Leave
     @AuraEnabled
    public static leaveWrapper applayLeaveMethod(String recordId){
       // Employee_Leave_Policy__c em = new Employee_Leave_Policy__c();
        Leave_Cycle__c levpol = new Leave_Cycle__c();
        Employee_Leave_Policy__c empLevPol = new Employee_Leave_Policy__c();
        Leave_Master_Details__c leaveMasDetails = new Leave_Master_Details__c();
         try{
         if(String.isNotBlank(recordId)){
        leaveWrapper wrap = new leaveWrapper();
        empLevPol = [SELECT Id,Name,Leave_Policy__c,Candidate__c,Leave_Cycle__c FROM Employee_Leave_Policy__c WHERE Candidate__c =:recordId LIMIT 1];
        if(empLevPol !=null){
            wrap.getEmpPolDetails = empLevPol;
        }
        if(String.isNotBlank(empLevPol.Leave_Cycle__c)){
            levpol = [SELECT Id,Name,End_Date__c,Start_Date__c FROM Leave_Cycle__c WHERE ID =: empLevPol.Leave_Cycle__c];
            if(levpol !=null){
                wrap.getLeavePol = levpol;
            }
         }
         if(String.isNotBlank(empLevPol.Leave_Policy__c)){
          leaveMasDetails = [SELECT Id,Name,Leave_Policy__c,Is_Active__c,Allow_In_Access__c,Accrual_Based_on__c,Leave_Balance__c,Pro_Rated_on_Joining__c,Pay_Type__c,Leave_Master__c,Max_Requests_in_Month__c FROM Leave_Master_Details__c WHERE Leave_Policy__c=: empLevPol.Leave_Policy__c];
          if(leaveMasDetails !=null){
              wrap.getLevMasDetails = leaveMasDetails;
          }
         }
          System.debug('wrap Employee_Leave_Policy__c === >'+wrap.getEmpPolDetails);
          System.debug('wrap Leave_Cycle__c === >'+wrap.getLeavePol);
          return wrap;
        }
        }catch(Exception e){
         System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }

 // For Getting Picklist Leave Types
    @AuraEnabled
    public Static Map<String,String> getPickListValuesMethod(){
     Map<String,String> lstPickvals   = new Map<String,String>();
    try{
     lstPickvals.put('Earned Leave','Earned Leave');
     lstPickvals.put('Sick Leave','Sick Leave');
     lstPickvals.put('Casual Leave','Casual Leave');
     return lstPickvals;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
    }

    public class leaveWrapper{
        @AuraEnabled 
        public Employee_Leave_Policy__c getEmpPolDetails;
        @AuraEnabled
        public Leave_Cycle__c getLeavePol;
        @AuraEnabled
        public Leave_Master_Details__c getLevMasDetails;
    }

    // Method for Inserting Leave Transaction
    public class LeavePlanWrapper{
        @AuraEnabled
        public String sDate;
        @AuraEnabled
        public String leaveType;
    }

    // ============================================================================================================================================================================

    // Method creating Leave Transaction record
    @AuraEnabled
    public static Leave_Transaction__c insertingLeavTrasRecord(String CandidateId,String LeaveMasterDetailsId,String LeaveDaysCount,Date ApplyStartDate,Date ApplyEndDate,String LeaveDescription,List<Map<String, Object>> leavePlanObj){
        System.debug('CandidateId == >'+CandidateId);
        System.debug('LeaveMasterDetailsId == >'+LeaveMasterDetailsId);
        System.debug('LeaveDaysCount == >'+LeaveDaysCount);
        System.debug('leavePlanObj == >'+leavePlanObj);
        List<Leave_Transaction__c> levTraRecordToInsertList = new List<Leave_Transaction__c>();
        try{
            if(String.isNotBlank(candidateId) && String.isNotBlank(LeaveMasterDetailsId) && String.isNotBlank(LeaveDaysCount)){
               Leave_Transaction__c levTraRec = new Leave_Transaction__c();
               levTraRec.Candidate__c = CandidateId;
               levTraRec.Leave_Master_Details__c = LeaveMasterDetailsId;
               levTraRec.Leave_Days__c	 = Decimal.valueOf(LeaveDaysCount);
               levTraRec.Apply_From__c = ApplyStartDate;
               levTraRec.Apply_To__c = ApplyEndDate;
               levTraRec.Approval_Status__c = 'Pending';
                if( String.isNotBlank(LeaveDescription)){
                levTraRec.Leave_Description__c = LeaveDescription;
                }
               levTraRecordToInsertList.add(levTraRec);
               if(levTraRecordToInsertList.size()>0){
                   insert levTraRecordToInsertList;
                   System.debug('Inserted Leav Tra Record === >'+levTraRecordToInsertList[0]);
                   if(levTraRecordToInsertList.size()>0){
                    //  insertLeaveTrascationDetailsRecord(leavePlanObj,levTraRecordToInsertList[0].Id,levTraRec.Candidate__c);
                   return levTraRecordToInsertList[0];
                   }
               }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }

   // ============================================================================================================================================================================

    // Method for creating Leave Transcation Details
    @AuraEnabled 
    public static void insertLeaveTrascationDetailsRecord(List<Map<String, Object>> leavePlanObj,String levTransId,String candidateId){
         System.debug('levTransId: >>> ' + levTransId);
         System.debug('candidateId: >>> ' + candidateId);
         List<Leave_Transaction_Details__c> LeaveTransDetailRecordToInsert = new List<Leave_Transaction_Details__c>();
         Leave_Transaction__c levTrans = new Leave_Transaction__c();

            Map<String, Integer> monthMap = new Map<String, Integer>{
            'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4, 'May' => 5, 'Jun' => 6,
            'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12
            };
         if(leavePlanObj !=null){
            for(Map<String,Object> data : leavePlanObj){
                String leavePlan = (String)data.get('leavePlan');
                
                String selectedDate = (String)data.get('selectedDate');
                System.debug('Selected Date: ' + selectedDate);
                List<String> dateParts = selectedDate.split(' ');
                Integer year = Integer.valueOf(dateParts[3]);
                Integer month = monthMap.get(dateParts[1]);
                Integer day = Integer.valueOf(dateParts[2]);
                  Leave_Transaction_Details__c LevTraDetRec = new Leave_Transaction_Details__c();
                  LevTraDetRec.Leave_Transaction__c = levTransId;
                  LevTraDetRec.Candidate__c = candidateId;
                  LevTraDetRec.Leave_Date__c= Date.newInstance(year, month, day);
                  if(leavePlan == 'Full Day'){
                      LevTraDetRec.Leave_Days__c = 1;
                  }else{
                      LevTraDetRec.Leave_Days__c = 0.5;
                  }
                  LeaveTransDetailRecordToInsert.add(LevTraDetRec);
            }
             if(LeaveTransDetailRecordToInsert.size()>0){
                  insert LeaveTransDetailRecordToInsert;
                  System.debug('Inserted Record for Leave Transcation Details Size === >'+LeaveTransDetailRecordToInsert.size());
            }
       }
    }

// ============================================================================================================================================================================

     // Method creating Leave Transaction record HR Leave
    @AuraEnabled
    public static Leave_Transaction__c insertingLeavTrasRecordForHR(String CandidateId,String LeaveMasterDetailsId,String LeaveDaysCount,Date ApplyStartDate,Date ApplyEndDate,String LeaveDescription,List<Map<String, Object>> leavePlanObj){
        System.debug('CandidateId == >'+CandidateId);
        System.debug('LeaveMasterDetailsId == >'+LeaveMasterDetailsId);
        System.debug('LeaveDaysCount == >'+LeaveDaysCount);
        System.debug('leavePlanObj == >'+leavePlanObj);
        List<Leave_Transaction__c> levTraRecordToInsertList = new List<Leave_Transaction__c>();
        try{
            if(String.isNotBlank(candidateId) && String.isNotBlank(LeaveMasterDetailsId) && String.isNotBlank(LeaveDaysCount)){
               Leave_Transaction__c levTraRec = new Leave_Transaction__c();
               levTraRec.Candidate__c = CandidateId;
               levTraRec.Leave_Master_Details__c = LeaveMasterDetailsId;
               levTraRec.Leave_Days__c	 = Decimal.valueOf(LeaveDaysCount);
               levTraRec.Apply_From__c = ApplyStartDate;
               levTraRec.Apply_To__c = ApplyEndDate;
                if( String.isNotBlank(LeaveDescription)){
                levTraRec.Leave_Description__c = LeaveDescription;
                }
               levTraRecordToInsertList.add(levTraRec);
               if(levTraRecordToInsertList.size()>0){
                   insert levTraRecordToInsertList;
                   System.debug('Inserted Leav Tra Record For HR === >'+levTraRecordToInsertList[0]);
                   if(levTraRecordToInsertList.size()>0){
                      insertLeaveTrascationDetailsRecord(leavePlanObj,levTraRecordToInsertList[0].Id,levTraRec.Candidate__c);
                   return levTraRecordToInsertList[0];
                   }
               }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
}