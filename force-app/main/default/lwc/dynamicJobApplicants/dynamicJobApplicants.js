import { LightningElement,wire,api,track } from 'lwc';
import getJobApplications from '@salesforce/apex/JobapplicationHelper.getJobApplicationsFinsl';
export default class DynamicJobApplicants extends LightningElement {
     @api recordId;
    @track  columns = [
    { label: 'Candidate Name', fieldName: 'ConName' },
    { label: 'Linkedin', fieldName: 'ConLinkedInURL', type: 'url',cellAttributes: { 
            iconName: 'utility:link', 
            iconAlternativeText: 'Priority' 
        } },
    { label: 'Phone', fieldName: 'conPhone', type: 'phone',cellAttributes: { 
            iconName: 'utility:call', 
            iconAlternativeText: 'Priority' 
        } },
    { label: 'mail', fieldName: 'ConEmail', type: 'email' },
    { label: 'Last Working Date', fieldName: 'ConRole',type: 'date'},
    { label: 'Docs',type: "button", typeAttributes: {  
        label: 'View',  
        name: 'View',  
        title: 'View',  
        disabled: false,  
        value: 'view',  
        iconPosition: 'left'  
    } },  
];


 


@track wiredResponse;
@track wiredata;
showDocCategories = false;
 frameURLSelf;
//this.frameURLSelf = 'https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/DocumentTemplates?id=';

@wire(getJobApplications,{recordId:'$recordId'})
wiredResult(result){
         debugger;
     this.wiredResponse = result;
        if(result.data){
            var tempRecords = result.data;
            tempRecords = tempRecords.map( row => {
                return { ...row, ConName: (row.Contact__r.Name != null) ? row.Contact__r.Name : '', 
                                ConLinkedInURL: row.Contact__r.LinkedIn_URL__c, 
                                conPhone : row.Contact__r.Phone, 
                                ConEmail : row.Contact__r.Email, 
                                conRole : row.Last_Working_Day__c};
            })
            this.wiredata=tempRecords;
            console.log(result.data);
        }

        if(result.error){

        }

 }

     callRowAction( event ) {
          const actionName = event.detail.action.name; 
          const recId = event.detail.row.Contact__c;
          debugger;
            if ( actionName === 'View' ){
                this.showDocCategories=true;
            this.frameURLSelf = 'https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/DocumentTemplatesCandidate?id='+recId;

        }   
     }


     closeiframe(){
         this.showDocCategories=false;
     }

     
 
}