import { LightningElement,wire,api,track } from 'lwc';
import addCandidateToJobReq from '@salesforce/apex/JobapplicationHelper.addCandidateToJobReq';
export default class HrDashboardPlaceholder extends LightningElement {
   isShowHrDB=false;
   isShowAlljobs=false;
   isPostJob=false;
   currentContent;
   data = [];
   selectedJobReq;

    
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


    handleSelect(event) {
        const selected = event.detail.name;

        if (selected === 'AllJons') {
            this.isShowAlljobs=true;
            this.isShowHrDB=false;
        }else if(selected === 'Screening'){
             this.isShowHrDB=true;
             this.isShowAlljobs=false;
        }

        // this.currentContent = selected;
    }


    postJob(event){
        debugger;
        let choosenJobReq=event.target.value;
        this.selectedJobReq=choosenJobReq;
        this.isPostJob=true;


    }

    closeisShowResume(){
         this.isPostJob=false;
    }

}