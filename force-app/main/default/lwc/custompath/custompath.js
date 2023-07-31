import { LightningElement,api,wire,track } from 'lwc';
import getJobReqrecord from '@salesforce/apex/CustompathHelper.getJobReqrecord';

export default class Custompath extends LightningElement {
    @api recordId='a250k000000jvDqAAI';
     wireResponse;

    currentvalue ;
    selectedvalue;
    pathHandler(event) {
        // let targetValue = event.currentTarget.value;
        // let selectedvalue = event.currentTarget.label;
        // this.currentvalue = targetValue;
        // this.selectedvalue = selectedvalue;
    }

    @wire (getJobReqrecord,{recordId:'$recordId'})
    wiredResult(result){
        debugger;
        if(result.data){
            //this.recordId=result.data.Id;
            this.wireResponse=result.data;
            this.currentvalue=this.wireResponse.Approval_Status__c;

        }
        if(result.error){
            alert('Please check console for error');
           
        }
    }  


}