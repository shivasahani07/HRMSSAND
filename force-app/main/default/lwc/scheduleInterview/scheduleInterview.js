import { LightningElement,api ,wire,track } from 'lwc';
import showPreviousInt from '@salesforce/apex/JobapplicationHelper.showPreviousInt';
export default class ScheduleInterview extends LightningElement {
    @api conId;
    currentIntervireId;
    previousIntId;
    candidateId;
    isShowMeeting=false;
    isShowCurrentInterview=true;
    isShowNextInterview=false;
    currentIntervireObject;
    nextInterViewObject;
    error;
    data = []; 
    @wire(showPreviousInt,{conId:'$conId'})
    wireAccounts({ error, data }) {
        debugger;
        if (data) {
            this.data = data
            alert('cool');
            // this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }

    // isOnlineInterview=false;
    handleTodoChange(event) {
        debugger;
        this.isShowMeeting = event.target.checked;        
        console.log("Todo: " + event.target.checked);

    }


    nextroundInterView(){
        debugger;
        this.isShowCurrentInterview=false;
        this.isShowNextInterview=true;
        this.nextInterViewObject=this.currentIntervireObject;

    }

    backroundInterView(){
        debugger;
        this.isShowCurrentInterview=true;
        this.isShowNextInterview=false;
    }

    saveIntRecord(){
       debugger;
        confirm('save ..?');
    }

}