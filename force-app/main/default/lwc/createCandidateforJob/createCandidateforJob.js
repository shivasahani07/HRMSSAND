import { LightningElement,wire,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions';
import updateCandidatesList from '@salesforce/apex/JobapplicationHelper.updateCandidatesList';
import createApplicatiosForSelectedJobAndCandidate from '@salesforce/apex/JobapplicationHelper.createApplicatiosForSelectedJobAndCandidate';
import addCandidateToJobReq from '@salesforce/apex/JobapplicationHelper.addCandidateToJobReq';
import showTaggedCandidate from '@salesforce/apex/JobapplicationHelper.showTaggedCandidate';
import deleteSelectedContact from '@salesforce/apex/JobapplicationHelper.deleteSelectedContact';



export default class CreateCandidateforJob extends LightningElement {

    @api recordId='a250k000000jvFwAAI';
    @track selectedCanidateId;
    wiredWrapper;
    data = [];
    sigleJobRecord;
    allPostedJobs;
    @track cureentJobDes;
    @track currentJobTitle;
    submittedApp;
    showJobDESTemp=false;
    showTagedcandidate=false;
    isShowCreateContactForm=false;
    isShowResumeUploaderComp=false;
    isShowTaggingCandidateComp=false;
    selectedJobReqId;
    allCand
    seprateRecro
    isDisabledinput=true;
    error;
    @track selectedRecordIds = [];
    @track selectedRadioRecord = '';
    @track jobtemplate=[];
    @track createCandidateSection=false;
    @track showCandidateSection=false;
    @track showJobDetails=false;
    // sectionn contacts
    @track newRcords;
    @track records;
    @track partnerRelatedCandidate;
    @track deleteConatctIds = '';


    @wire(addCandidateToJobReq)
    wireAccounts({ error, data }) {
        debugger;
        if (data) {
            console.log('datajson',JSON.stringify(data))
            this.wiredWrapper=data
            this.data = this.wiredWrapper.alljobs;
            this.partnerRelatedCandidate =this.wiredWrapper.tageCandidate;
            this.jobtemplate=this.wiredWrapper.allJobsDesTemp;
            this.submittedApp=this.wiredWrapper.submitedApplicatons;
            this.allJobPosted=this.wiredWrapper.allPostedJobs;
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }
    handleCheckboxSelect(event) {
        debugger;
        let selectedRows = this.template.querySelectorAll('lightning-input[data-key="firstColumnCheckbox"]');
        let allSelected = true;
        selectedRows.forEach(currentItem => {
            if (!currentItem.checked && currentItem.type === 'checkbox') {
                allSelected = false;
            }
        });
        let selectedRow = this.template.querySelector('lightning-input[data-key="allCheckbox"]');
        if (allSelected) {
            selectedRow.checked = true;
        } else {
            selectedRow.checked = false;
        }
    }
    //Select/unselect all rows
    handleAllSelected(event) {
        debugger;
        let selectedRows = this.template.querySelectorAll('lightning-input[data-key="firstColumnCheckbox"]');
        selectedRows.forEach(row => {
            if (row.type == 'checkbox') {
                row.checked = event.target.checked;
            }
        });
    }
    // handleSingleCheckboxSelect(event) {
    //     debugger
    //     const boxes = this.template.querySelectorAll('lightning-input[data-key="singleSelectColumnCheckbox"]');
    //     boxes.forEach(box => box.checked = event.target.name === box.name);
    // }
    getAllSelectedRecord() {
        debugger;
        //first column checkbox selected records
        let firstColumnSelectedRecord = [];
        let firstColumnCheckboxRows = this.template.querySelectorAll('lightning-input[data-key="firstColumnCheckbox"]');
        firstColumnCheckboxRows.forEach(row => {
            if (row.type == 'checkbox' && row.checked) {
                firstColumnSelectedRecord.push(row.dataset.id);
            }
        });
        //single selected checkbox record
        let selectedRecord = '';
        let singleColumnCheckbox = this.template.querySelectorAll('lightning-input[data-key="singleSelectColumnCheckbox"]');
        singleColumnCheckbox.forEach(row => {
            if (row.type == 'checkbox' && row.checked) {
                selectedRecord = row.value;
            }
        });
        let selectedRadioRecord = '';
        let selectedRadioRows = this.template.querySelectorAll('lightning-input[data-name="radio"]');
        selectedRadioRows.forEach(currentItem => {
            if (currentItem.type === 'radio' && currentItem.checked) {
                selectedRadioRecord = currentItem.value;
            }
        })

        if(firstColumnSelectedRecord !=null){
            debugger;
            createPostJobRecords({PartnersId:firstColumnSelectedRecord,JobReqId:this.recordId})
             .then(result => {
                const evt = new ShowToastEvent({
                    title: 'Toast Success',
                    message: 'Opearion sucessful',
                    variant: 'success',
                    mode: 'dismissable'
                 });
                    this.dispatchEvent(evt);
                })
             .catch(error => {
                console.log('Errorured:- '+error.body.message);
            });
            
        }
        console.log('multiple selected Record : ' + JSON.stringify(firstColumnSelectedRecord));
        console.log('single checkbox selected Record : ' + selectedRecord);
        console.log('single radio selected Record : ' + selectedRadioRecord);
    }

    showJD(event){
    debugger
    let JobId=event.target.value;
    this.createCandidateSection=false;
    this.showJobDetails=true;
    // this.jobtemplate.forEach(item=>item.Id==JobId){

    // }
        for(let i=0; i<this.jobtemplate.length; i++){
            if(this.jobtemplate[i].Id==JobId){

            }
        }

        for(let i=0; i<this.data.length; i++){
             if(this.data[i].Id==JobId){
                this.sigleJobRecord=this.data[i]
            }
        }

    }

   

    //add candiates sections 
    addRow() {
        debugger;
        //let randomId = Math.random() * 16;
        let myNewElement = {Email: "", FirstName: "", LastName: "",Aadhar__c:"",Phone:""};
        this.partnerRelatedCandidate = [...this.partnerRelatedCandidate,  myNewElement];

    }
    handleDeleteAction(event){
        debugger;
        
        let selectedRecordIndex=event.target.dataset.ind;
        if(isNaN(event.target.dataset.id)){
            this.handleDeleteContact(event);
            
            // this.deleteConatctIds = this.deleteConatctIds + ',' + event.target.dataset.id;

        }
        if(!isNaN(event.target.dataset.id)){
            this.partnerRelatedCandidate.splice(this.partnerRelatedCandidate.findIndex(row => row.index === selectedRecordIndex), 1);
        }
       
    }

    updateValues(event){
        var foundelement = this.partnerRelatedCandidate.find(ele => ele.Id == event.target.dataset.id);
        if(event.target.name === 'FirstName'){
            foundelement.FirstName = event.target.value;
        } else if(event.target.name === 'LastName'){
            foundelement.LastName = event.target.value;
        } else if(event.target.name === 'Email'){
            foundelement.Email = event.target.value;
        } else if(event.target.name== 'Phone'){
            foundelement.Phone = event.target.value;
        } else if(event.target.name == 'AadharNumber'){
            foundelement.AadharNumber = event.target.value;
        }
    }

     //to close quick action
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }


     handleSaveAction(){
        debugger;
        updateCandidatesList({Contacts: this.partnerRelatedCandidate})
        .then( result => {
            alert('Cool');
           
            // refreshApex(this.wiredRecords);
            // this.updateRecordView(this.recordId);
            // this.closeAction();
            // this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            alert('Not cool bro');
            console.log(error);
            // this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }


     tagCandidate(event){
         debugger;
        // let myNewElement = {Email: "", FirstName: "", Id: "", LastName: "",Aadhar__c:"",Phone:""};
        let JobId=event.target.value; 
        this.selectedJobReqId=JobId;
        this.createCandidateSection=true;
        this.showJobDetails=false;
        this.isShowTaggingCandidateComp=true;
        //this.records=[];
        // for(let i=0; i<this.allJobPosted.length; i++){
        //    if(this.allJobPosted[i].Id==JobId){
        //     for(let j=0; j<this.submittedApp.length; j++){

        //     }
        //    }
        // }

        // var temparrry = [];
        // for(let i=0; i<this.submittedApp.length; i++){
        //     for(let j=0; j<this.records.length; j++){
        //         if(this.submittedApp[i].Contact__c==this.records[j].Id){
        //             let tempRecords=[this.records[j]];
        //             temparrry.push(this.records[j]);
        //             //this.records=this.records[j];
        //         }
        //     }
        //     this.records = temparrry;
            
        // }
    }


    handle_Green_Text_Click(event){
        debugger
       
        
        let TempId=event.target.dataset.id;
        if(TempId !=null ){
             for(let i=0; i<this.jobtemplate.length; i++){
            if(TempId==this.jobtemplate[i].Id){
                this.cureentJobDes=this.jobtemplate[i].Description__c;
                this.currentJobTitle=this.jobtemplate[i].Name;
                 this.showJobDESTemp=true;
            }
            else{
                this.currentJobTitl='Soon wll be updates here..';
                this.cureentJobDe='PLease Contact HR Team for more details';
                }
            }
        }
        else if(TempId ==undefined ){
             this.currentJobTitl='Soon wll be updates here..';
            this.cureentJobDe='PLease Contact HR Team for more details';
             this.showJobDESTemp=true;
        }
       

        // alert('JobId',TempId);
    }

    closeModal(event){
        debugger;
        this.showJobDESTemp=false;
        this.showTagedcandidate=false;
        this.isShowCreateContactForm=false;
          
    }

    showCandidate(event){
        debugger;
        let jobReqId=event.target.value;
         showTaggedCandidate({jobReqId:jobReqId})
        .then( result => {
            this.records=result;
            this.showTagedcandidate=true;
            
            // this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            console.log(error);
            // this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });

    }

    handleDeleteContact(event){
        debugger;
        let contactId=event.target.dataset.id;
        deleteSelectedContact({contactId:contactId})
        .then( result => {
            const evt = new ShowToastEvent({
                    title: 'Toast Success',
                    message: 'Opearion sucessful',
                    variant: 'success',
                    mode: 'dismissable'
                 });
                    this.dispatchEvent(evt);
            // this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            console.log(error);
            // this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }

    showCreateContactForm(event){
        debugger;
        this.isShowCreateContactForm=true;
    }

    uploadResume(event){
        debugger;
        let contactId=event.target.dataset.id;
        this.selectedCanidateId=contactId;
        this.isShowResumeUploaderComp=true;
    }

    closeResumeUploader(){
        debugger;
         this.isShowResumeUploaderComp=false;
    }

    closeShowTaggingCandidateComp(){
        debugger;
        this.isShowTaggingCandidateComp=false;
    }


    selectCandidateCheckbox(event){
        debugger
        let selectedCandidateIds=[];
        let selectedCandidate=event.target.dataset.id;


        

    }
    
    createApplications(event){
        debugger;
        const selectedIds = [];
        const checkboxes = this.template.querySelectorAll('lightning-input[data-key="firstColumnCheckbox"]');
        checkboxes.forEach(checkbox => {
            if (checkbox.checked) {
                // If the checkbox is selected, add its data-id attribute (which stores the ID) to the selectedIds array
                selectedIds.push(checkbox.getAttribute('data-id'));
            }
        });

        if(selectedIds.length>0){
        createApplicatiosForSelectedJobAndCandidate({selectedCandidatesId:selectedIds,JobReqId:this.selectedJobReqId})
        .then( result => {
            const evt = new ShowToastEvent({
                    title: 'Toast Success',
                    message: 'Opearion sucessful',
                    variant: 'success',
                    mode: 'dismissable'
                 });
                    this.dispatchEvent(evt);
            // this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            alert('Im error');
            console.log(error);
            // this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });

        }else{
            alert("Please Select candidate to Tag..");
        }
    }


    closeshowJobDetails(){
        debugger;
        this.showJobDetails=false;
    }


    // Upssert candidate for prtner 



    

}