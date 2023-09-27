import { LightningElement,wire,api,track } from 'lwc';
import addCandidateToJobReq from '@salesforce/apex/JobapplicationHelper.addCandidateToJobReq';
import viewSibmittedApplicsations from '@salesforce/apex/JobapplicationHelper.viewSibmittedApplicsations';
import updateApplications from '@salesforce/apex/JobapplicationHelper.updateApplications';
import showCandidate from '@salesforce/apex/JobapplicationHelper.showCandidate';
import showRelCandidate from '@salesforce/apex/JobapplicationHelper.showRelCandidate';
import acceptRejectCandidate from '@salesforce/apex/JobapplicationHelper.acceptRejectCandidate';





export default class HrDashboard extends LightningElement {
@track columns = [
    {
        label: 'Candidate',
        fieldName: 'Name',
        type: 'text',
    }, {
        label: 'Job Post',
        fieldName: 'Job_Post__c',
        type: 'text',
       
    }, {
        label: 'Status',
        fieldName: 'Status__c',
        type: 'text',
        editable: true,
    }
];
data = []; 
@track selectedOption;
wiredWrapper;
isShowJobsReqs=true;
isShowCandidateDetails=false;
saveDraftValues = [];
RelatedApplications=[];
isShowRelatedApplications=false;
isShowResume=false;
isShowInterView=false;
selectedContatcId;
candidates=[];


  @wire(addCandidateToJobReq)
    wireAccounts({ error, data }) {
        debugger;
        if (data) {
            // console.log('datajson',JSON.stringify(data))
            this.wiredWrapper=data
            this.data = this.wiredWrapper.alljobs;
            // this.partnerRelatedCandidate =this.wiredWrapper.tageCandidate;
            // this.jobtemplate=this.wiredWrapper.allJobsDesTemp;
            // this.submittedApp=this.wiredWrapper.submitedApplicatons;
            // this.allJobPosted=this.wiredWrapper.allPostedJobs;
            // this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }


    //THIS METHOD WILL SHOW RELATED APPLICATION OF SELECTED JOB REQ
    viewApplications(event){
        debugger;
        let choosenJobReq=event.target.value;
        

    }

    showRelatedApplications(event){
        debugger;
        this.isShowJobsReqs=false;
        this.isShowRelatedApplications=true;
        this.isShowCandidateDetails=false;
        let choosenJobReq=event.target.value;
         viewSibmittedApplicsations({JobReqId:choosenJobReq})
        .then( result => {
           this.RelatedApplications=result;
            console.log('RelatedApplications---->',this.RelatedApplications);
          
                      // this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            console.log(error);
            // this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });

    }

    closeisShowRelatedApplications(event){
        this.isShowRelatedApplications=false;
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
 
        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.ShowToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }

    ShowToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
                title: title,
                message:message,
                variant: variant,
                mode: mode
            });
            this.dispatchEvent(evt);
    }
 
    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.contacts);
    }


   changeHandler(event) {
    debugger;
    const field = event.target.name;
    if (field === 'optionSelect') {
        this.selectedOption = event.target.value;
        
        } 
    }

    updateApplication(event){
        debugger;
        updateApplications({AppTobeUpdates: this.RelatedApplications})
        .then( result => {
            alert("Cool😎");
        }).catch( error => {
            console.log(error);
        });

    }

    backToJbReq(){
          this.isShowJobsReqs=true;
          this.isShowRelatedApplications=false;
          this.isShowCandidateDetails=false;
    }

    showCandidateDetails(event){
        debugger;
        let appId=event.target.value;
        this.isShowCandidateDetails=true;
        this.isShowJobsReqs=false;
        this.isShowRelatedApplications=false;
        showRelCandidate({jobReqId:appId})
        .then( result => {
            alert("Cool😎");
            let tempCanObject=result
            // this.candidates=result;
            for(let i=0; i<tempCanObject.length; i++){
                if(tempCanObject[i].Status_Summary_Line__c=='Rejected'){
                    tempCanObject[i].showHideInterviewbutton=false;
                    
                } 
                else if(tempCanObject[i].Status_Summary_Line__c!='Rejected'){
                    tempCanObject[i].showHideInterviewbutton=true;
                }
                
            }
            
            this.candidates=tempCanObject;

            
           
        }).catch( error => {
            console.log(error);
        });

        
    }

    backFromCanDetasils(){
        debugger;
        this.isShowCandidateDetails=false;
        this.isShowJobsReqs=false;
        this.isShowRelatedApplications=true;
    }

    viewResume(event){
        let conId=event.target.dataset.id;
        this.selectedContatcId=conId;
        this.isShowResume=true;

    }

    closeisShowResume(){
         this.isShowResume=false;
    }


    showRelatedCandidate(event){
        debugger;
        let choosenJobReq=event.target.value;
        

    }

    rejectCandidate(event){
        debugger;
        let actionName=event.target.name;
        let conId=event.target.dataset.id;
        
        acceptRejectCandidate({conId:conId,status:actionName})
        .then( result => {
            alert('rejected');
        }).catch( error => {
            console.log(error);
        });

    }

    acceptCandidate(event){
        debugger;
        let actionName=event.target.name;
        let conId=event.target.dataset.id;
        acceptRejectCandidate({conId:conId,status:actionName})
        .then( result => {
            alert('Accepted');
        }).catch( error => {
            console.log(error);
        });
        // this.isShowInterView=true;
    }

    closeisShowInterView(){
        this.isShowInterView=false;
    }

    showisShowInterView(event){
        let actionName=event.target.name;
        let conId=event.target.dataset.id;
        this.selectedContatcId=conId;
        this.isShowInterView=true;
    }
}