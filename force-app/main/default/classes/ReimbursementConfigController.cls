public class ReimbursementConfigController {
 	@RemoteAction
    public static List<ReimbursementConfig__c> getReimbDet(){
        try{
            return [SELECT Id, Name,Description__c,Comment_Required__c,Comment_Required_Status__c,Expense_Limit__c,Expense_Limit_Status__c,
                    Limit_Cycle__c,Receipt_Required__c,Receipt_Required_Status__c,Request_Cycle__c,Request_Limit__c,Request_Limit_Status__c 
                    FROM ReimbursementConfig__c];               
        }catch(Exception e){
            return null;
        }
    }
    @RemoteAction
    public static List<Claim_Request__c> getClaimRequests(){
        try{
            return [SELECT Id, Name,Description__c,Bill_No__c,Status__c,Bill_Date__c,Bill_Amount__c,Reimbursement_Config__r.Name,Candidate__r.Name FROM Claim_Request__c];               
        }catch(Exception e){
            return null;
        }
    }
    @RemoteAction
    public static List<Claim_Request__c> getClaimRequestsById(String candidateId){
        try{
            if(candidateId==null)
            	return [SELECT Id, Name,Description__c,Bill_No__c,Status__c,Bill_Date__c,Bill_Amount__c,Reimbursement_Config__r.Name,Candidate__r.Name FROM Claim_Request__c];               
            else
                return [SELECT Id, Name,Description__c,Bill_No__c,Status__c,Bill_Date__c,Bill_Amount__c,Reimbursement_Config__r.Name,Candidate__r.Name FROM Claim_Request__c where candidate__c=:candidateId];
        }catch(Exception e){
            return null;
        }
    }
    @RemoteAction
    public static List<Claim_Request__c> getClaimRequestDateWise(Integer fyear, Integer fmonth, Integer fday, Integer tyear, Integer tmonth, Integer tday,String RecType){
        try{
           Date fromDate;
           Date toDate;
            if(fday!=0){
                fromDate=Date.newInstance(fyear,fmonth,fday);                
            }
            if(tday!=0){
                toDate=Date.newInstance(tyear,tmonth,tday);                
            }
            if(RecType=='All')
            	return [SELECT Id, Name,Description__c,Bill_No__c,Status__c,Bill_Date__c,Bill_Amount__c,Reimbursement_Config__r.Name,Candidate__r.Name FROM Claim_Request__c where Bill_Date__c >:fromDate and Bill_Date__c <: toDate ];               
            else
                return [SELECT Id, Name,Description__c,Bill_No__c,Status__c,Bill_Date__c,Bill_Amount__c,Reimbursement_Config__r.Name,Candidate__r.Name FROM Claim_Request__c where Bill_Date__c >:fromDate and Bill_Date__c <: toDate and status__C=:RecType ];
        }catch(Exception e){
            return null;
        }
    }
    @RemoteAction
    public static String SaveHeadDetail(ReimbursementConfig__c instanceReimb){
        try{            
            upsert instanceReimb;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    @RemoteAction
    public static String DeleteExpenseHead(String rId){
        try{
            ReimbursementConfig__c instanceReimb=new ReimbursementConfig__c(Id=rId);
            delete instanceReimb;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
     @RemoteAction
    public static String saveClaimRequest(Claim_Request__c instanceClaimRequest, Integer year, Integer month, Integer day){
        try{
            Date claimDate;
            if(day!=0){
                claimDate=Date.newInstance(year,month,day);
                instanceClaimRequest.Bill_Date__c=claimDate;
            }
            upsert instanceClaimRequest;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
     @RemoteAction
    public static String DeleteClaimRequest(String rId){
        try{
            Claim_Request__c instanceReimb=new Claim_Request__c(Id=rId);
            delete instanceReimb;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
   @RemoteAction
    public static String ApproveRejectClaimRequest(String rId,String recStatus){
        try{
            Claim_Request__c instanceClaimReq=new Claim_Request__c(Id=rId);
            instanceClaimReq.status__c=recStatus;
            update instanceClaimReq;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    /**************************************************Exit Management*****************************************************************/
    /*@RemoteAction
    public static String getCandidate(){
        try{
            Claim_Request__c instanceClaimReq=new Claim_Request__c(Id=rId);
            instanceClaimReq.status__c=recStatus;
            update instanceClaimReq;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }*/
}