import { refreshApex } from '@salesforce/apex';
import { LightningElement,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllObjects from '@salesforce/apex/DMSConfigController.getAllObjects'
import DMSConfigHelper from '@salesforce/apex/DMSConfigController.saveDMSConfig'
import getDMSConfigRecords from '@salesforce/apex/DMSConfigController.getDMSConfigRecords'


const columns = [
    { label: 'Trigger Details', fieldName: 'Trigger_Details__c', editable: false },
    { label: 'Trigger Name', fieldName: 'Trigger_Name__c', editable: false },
    { label: 'Object', fieldName: 'Object__c', editable: false },
    { label: 'Trigger Point', fieldName: 'Trigger_Point__c', editable: false},
    { label: 'Folders', fieldName: 'Folders__c', editable: false },
];

export default class CreateDMSConfigLWC extends LightningElement {
    
    columns = columns;
    rowOffset = 0;

    @track records = [];
    @track objects = [];
    @track wiredResponse;
    @track recordsAvailable = false;
    @track isLoading = false;
    @track showLoader = false;
    @track showCreateRecordPopup = false;

    @track newRecord = {
        Trigger_Name__c:'',
        Object__c:'',
        Trigger_Point__c:'',
        Folders__c:''
    }

    triggerPointList = [
        {label:'After Insert',value:'After Insert'},
        {label:'After Update',value:'After Update'},
    ]

    @wire(getDMSConfigRecords)
    configWiredResponse(result){
        this.wiredResponse = result;
        if(result.data){
            console.log('Records',result.data)
            this.records = result.data;
            this.recordsAvailable = this.records.length>0;
        }else{
            this.recordsAvailable = false;
        }
    }

    createRecordPopupHandler(){
        getAllObjects().then(result=>{
            console.log('Objects----',result);
            if(result){
                this.objects = [];
                result.forEach(item=>{
                    this.objects.push({label:item.SobjectType,value:item.SobjectType});
                })
            }
            this.showCreateRecordPopup = true;
        }).catch(error=>{
            console.log('Error to fetch objects');
        })
    }

    hideRecordPoupHandler(){
        this.showCreateRecordPopup = false;
    }

    inputChangeHandler(event){
        let type = event.currentTarget.dataset.id;
        let value = event.target.value;

        this.newRecord[type] = value;
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

        this.showLoader = true;
        DMSConfigHelper({dms:this.newRecord}).then(result=>{
            if(result=='Success'){
                this.showToast('Success',`New DMS Configuration created`,'success');
                this.showCreateRecordPopup = false;
                this.showLoader = false;
                refreshApex(this.wiredResponse);
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