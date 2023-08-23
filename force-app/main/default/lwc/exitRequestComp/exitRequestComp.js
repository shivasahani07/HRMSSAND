import { api, LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getEmployeeDetails from '@salesforce/apex/ExitRequestCompController.getEmployeeDetails';
import saveDetails from '@salesforce/apex/ExitRequestCompController.saveExitRequestDetails';

export default class ExitRequestComp extends LightningElement {
@api recordId;
employeeData;
@track exitrequestData = {'Job_Title__c':''};
@track ContactData = {'Email':''};
name = '';
employeId = '';
mobile = '';
email = '';
landingPage = true;
secondPage = false;

@wire(getEmployeeDetails,{employeeId:'$recordId'})
    wiredResponse(result){
        debugger;
        console.log('result ---- ',result);
        if(result.data){
            console.log('Employee Data-------',result.data);
            this.employeeData = result.data;
            this.name = result.data.Name;
            this.employeId = result.data.Id;
            this.mobile = result.data.MobilePhone;
            this.email = result.data.Email;
            
        }else{
            console.log("Error to fetch data",result);
        }
    }

    showSecondPage(){
        debugger;
        this.secondPage = true;
        this.landingPage = false;
    }

    handleChange(event){
        debugger;
        var selectedName = event.target.name;
        if(selectedName == 'startDate'){
            this.exitrequestData.Start_Date__c = event.target.value;
        }
        if(selectedName == 'seperationDate'){
            this.exitrequestData.Separation_Date__c = event.target.value;
        }
        if(selectedName == 'reason'){
            this.exitrequestData.Reason_For_Leaving__c = event.target.value;
        }
        if(selectedName == 'seekAnotherJob'){
            this.exitrequestData.What_prompted_you_to_seek_another_job__c = event.target.value;
        }
        if(selectedName == 'email'){
            this.ContactData.Email = event.target.value;
        }
        if(selectedName == 'phone'){
            this.ContactData.MobilePhone = event.target.value;
        }

    }

    submitDetails(){
        debugger;
        this.exitrequestData.Employee__c = this.employeId;
        this.ContactData.Id = this.employeId;
        saveDetails({ exitReq: JSON.stringify(this.exitrequestData),contactRecord: JSON.stringify(this.ContactData) })
        .then(result => {
            console.log('Result:', result);
            this.showNotification('Success','Your exit Request have been submitted successfully..','success');
            this.closeAction();
        })
        .catch(error => {
            console.error('Error:', error);
            this.showNotification('Error',error.body.message,'error');
        });
    }

    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}