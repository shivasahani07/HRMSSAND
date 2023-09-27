//Shiva 25 August 2023..
public class ApprovalProcessJobRequsition {
    
    /*Public static void sendApprovalProcessPass(list<Mandate__c> jobReqList){
        for(Mandate__c  jobReq:jobReqList){
            if(jobReq.Approval_Status__c=='New'){
             sendApprovalProcess(jobReq); 
            }
        }
    }
       
    Public static void sendApprovalProcess(Mandate__c  jobReq){
        Approval.ProcessSubmitRequest  pass = new Approval.ProcessSubmitRequest();
        pass.setComments('Submitting request for approval automatically using Trigger');
        pass.setObjectId(jobReq.id);
        pass.setProcessDefinitionNameOrId('Double_Step_Approval_Process ');        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(pass);
    } */
    

}