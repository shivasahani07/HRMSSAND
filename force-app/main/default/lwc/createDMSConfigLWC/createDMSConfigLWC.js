import { LightningElement,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DMSConfigHelper from '@salesforce/apex/DMSConfigController.saveDMSConfig'
import getDMSConfigRecords from '@salesforce/apex/DMSConfigController.getDMSConfigRecords'

export default class CreateDMSConfigLWC extends LightningElement {
    @track showCreateRecordPopup = false;
    @track isLoading = false;
    @track objects = [];

    @track newRecord = {
        Trigger_Name__c:'',
        Object__c:'',
        Trigger_Point__c:'',
        Folders__c:''
    }

    @wire(getDMSConfigRecords)
    configWiredResponse({data,error}){
        if(data){
            console.log('Records',data)
        }
    }

    handleSaveResult(){
        if(!this.newRecord.Trigger_Name__c){
            this.showToast('Error','Please enter trigger name','error');
            return;
        }
        if(!this.newRecord.Object__c){
            this.showToast('Error','Please choose object','error');
            return;
        }
        if(!this.newRecord.Trigger_Point__c){
            this.showToast('Error','Please choose a trigger point','error');
            return;
        }
        if(!this.newRecord.Folders__c){
            this.showToast('Error','Please give name of the folders','error');
            return;
        }

        DMSConfigHelper({dms:this.newRecord}).then(result=>{
            if(result=='Success'){
                this.showToast('Success',`New DMS Configuration created`,'success');
            }else{
                this.showToast('Failed',`${result}`,'error');
            }
        }).catch(error=>{
            this.showToast('Error',error,'error');
        })
    }

    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}