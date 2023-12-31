import { LightningElement,api,track,wire } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import updaateEducation from '@salesforce/apex/CommunitiesLoginControllerLwc.updaateEducation';
import CompleteCandiateData from '@salesforce/apex/CommunitiesLoginControllerLwc.CompleteCandiateData';

import updateStatutoeyDetails from '@salesforce/apex/CommunitiesLoginControllerLwc.updateStatutoeyDetails';
import { NavigationMixin } from 'lightning/navigation'; 
import getAssignmentList from '@salesforce/apex/AssSelectionLwcHelper.getAssignmentList';
import harvestInternational	 from "@salesforce/resourceUrl/harvestInternational";
import SelfAssesmentValues from '@salesforce/apex/SelfAssForAppHelper.SelfAssesmentValues';
import SelfAssesmentResCreation from '@salesforce/apex/SelfAssForAppHelper.SelfAssesmentResCreation';
import insertWorkExperienceData from '@salesforce/apex/SelfAssForAppHelper.insertWorkExperienceData';
import OnePagerResCreation from '@salesforce/apex/SelfAssForAppHelper.OnePagerResCreation';
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Birthdate  from '@salesforce/schema/Contact.Birthdate';
import LinkedIn_URL__c  from '@salesforce/schema/Contact.LinkedIn_URL__c';
import Phone  from '@salesforce/schema/Contact.Phone';
import job_Area__c  from '@salesforce/schema/Contact.job_Area__c';
import Office_State__c  from '@salesforce/schema/Contact.Office_State__c';
import Email  from '@salesforce/schema/Contact.Email';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile';
import getApplicationList from '@salesforce/apex/AssSelectionLwcHelper.getApplicationList';
import getSelfAssIdandOPId from '@salesforce/apex/AssSelectionLwcHelper.getSelfAssIdandOPId';
import CONFETTI from "@salesforce/resourceUrl/Confetti";
import SWEETALERT from "@salesforce/resourceUrl/sweetalert";

export default class NewEmployeeEnrolment extends NavigationMixin(LightningElement) {

    connectedCallback() {
    debugger;
    Promise.all([
        loadScript(this, SWEETALERT),
        loadScript(this, CONFETTI)
    ])
    }

    
    harvestImage = harvestInternational;
    @api recordId ; //Conid
    @api conId ;
    @api appId ;
    @api objectApiName = 'Contact';
    @api objectName = 'Application__c';
    @api assId;
    @api appList;
    frameURLSelf;
    showDocCategoriesModal;
    frameURLOP;
    onePagerlist;
    selfasslist;
    isLogin = true;
    isSignup = true;
    selfAssId;
    onePagerId;
    regid;
    isCreatingOP;
    heading;
    showSelfAssTemp;
    selectedAppId;
    appView = false;
    areAppsAvailable = false;
    showWarning = true;
    showSpinner = false;
    showTable = false;
    showSecondPage = false;
    isModalOpen = false;
    isModalDocsOpen = false;
    isEducationdetails=false
    workExperienceReq = false;
    isModalDocsViewOpen = false;
    isShowFileUploaderLWC=false;
    isSelfAssOpen =false;
    assView = false;
    selfAss = false;
    isCreatingApp = false;
    confirmation = false;
    showProgress = true;
    showreg = false;
    showAss = false;
    showStatutorySection=false;
    showMainPage = true;
    areDetailsVisible = true;
    JobDescId ;
    ResStratId ;
    EmpPrfId;
    ExecSummId ;
    attFound = false;
    noAttFound = false;
    viewAttForDoc = false;
    modalWithAssDocs = false;
    isDetailsdone=true;
    isFamilySection=false
    selectedStep;
    lastStep=1;
    @track errorMessages = {};
    fields = [FirstName,LastName,Email,Birthdate,Office_State__c,LinkedIn_URL__c,job_Area__c,Phone];
    
    @track aadharNumber = '';
    @track panNumber = '';
    @track uanNumber = '';
    @track fatherName = '';
    @track pfNumber = '';
    @track esiNumber = '';
    parentObject={};

    @track columns = [
        {  
            label: "Assignment Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Job Function',
            fieldName: 'Job_Function__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Employment Type',
            fieldName: 'Employment_Type__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Required Candidates',
            fieldName: 'Total_Candidates_Required__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Ass Start Date',
            fieldName: 'Mandate_Start_Date__c',
            type: 'date',
            sortable: true
        },
        {
            label: 'Ass End Date',
            fieldName: 'Mandate_End_Date__c',
            type: 'date',
            sortable: true
        },
        {type: "button", typeAttributes: {  
            label: 'Apply For Job🧑‍💻🧑‍💻',  
            name: 'Apply',  
            title: 'Apply',  
            disabled: false,  
            value: 'Apply',  
            iconPosition: 'right'  
        }},{type: "button", typeAttributes: {  
            label: 'View Documents📄📄',  
            name: 'Docs',  
            title: 'Docs',  
            disabled: false,  
            value: 'Apply',  
            iconPosition: 'right'  
        }},  
    ];
    @track columnForApp = [
        {  
            label: "Application Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Assignment Start Date',
            fieldName: 'Mandate_Start_Date__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Status Summary Line',
            fieldName: 'Status_Summary_Line__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Origin',
            fieldName: 'Origin__c',
            type: 'text',
            sortable: true
        },
        {type: "button", typeAttributes: {  
            label: 'View Docs',  
            name: 'View Docs',  
            title: 'View Docs',  
            disabled: false,  
            value: 'Docs',  
            iconPosition: 'right'  
        }},
    ];



    keyIndex = 0;


    @track itemList = [{ id: 0 ,Company__c :"",Start_Year__c : "",End_Year__c : "",Title__c : ""  }];
    @track educationList=[{School_Institute__c:"",Start_Date__c:"",End_Date__c:"",Percentage__c:""}];
    @track statutoryList=[];

    
    @wire (CompleteCandiateData,{candidateId: '$conId'})
    wiredResult(result){
        debugger;
        if(result.data){
            this.itemList=
            this.parentObject = result.data;
            this.itemList=[...this.parentObject.workExpList];
            this.educationList=[...this.parentObject.edutionList];
            // this.statutoryList=[...this.parentObject.statutoryList];
            let tempStade= [...this.parentObject.statutoryList]
            for(let i=0;  i < tempStade.length; i++){
                if(tempStade[i].Type__c=='Aadhar'){
                    this.aadharNumber=tempStade[i].Document_Number__c;
                }
                else if(tempStade[i].Type__c=="PAN"){
                    this.panNumber=tempStade[i].Document_Number__c;
                }
                else if(tempStade[i].Type__c == "UAN") {
                    this.uanNumber = tempStade[i].Document_Number__c;
                }
                else if(tempStade[i].Type__c== 'ESIC') {
                    this.esiNumber = tempStade[i].Document_Number__c;
                }
                else if(tempStade[i].Type__c== 'PF'){
                    this.pfNumber = tempStade[i].Document_Number__c;
                } 
                else if( tempStade[i].Type__c== 'FATHER'){
                    this.fatherName = tempStade[i].Document_Number__c;
                }
            }
           
            //this.parentObject = { ...result.data };
            console.log('result.data------->',result.data);

            
        }
        if(result.error){
            alert('Please check console for error');
            //  window.location.href = loginPage;
        }
    } 


    handleInputChange(event) {
        debugger;
        let index = event.target.dataset.id;
        let fieldName = event.target.name;
        let value = event.target.value;
        for(let i = 0; i < this.itemList.length; i++) {
            if(this.itemList[i].id === parseInt(index)) {
                if(this.itemList[i].Start_Year__c>this.itemList[i].End_Year__c){
                   alert('Please check years',i);
                }
                this.itemList[i][fieldName] = value;
            }
        }
    }

    // handleInputChange(event) {
    //     let index = event.target.dataset.id;
    //     let fieldName = event.target.name;
    //     let value = event.target.value;

    //     // Ensure that errorMessages is initialized as an object
    //     this.errorMessages = this.errorMessages || {};

    //     for (let i = 0; i < this.itemList.length; i++) {
    //         if (this.itemList[i].id === parseInt(index)) {
    //             // Validation logic based on fieldName
    //             let fieldError = '';

    //             if (fieldName === 'Start_Year__c' && this.itemList[i].End_Year__c && value > this.itemList[i].End_Year__c) {
    //                 fieldError = "Start year cannot be greater than end year";
    //             }
    //             if (fieldName === 'End_Year__c' && this.itemList[i].Start_Year__c && value < this.itemList[i].Start_Year__c) {
    //                 fieldError = "End year cannot be less than start year";
    //             }
    //             // Add more validation logic for other fields

    //             // Update the errorMessages track variable
    //             this.errorMessages = {
    //                 ...this.errorMessages,
    //                 [index]: { ...this.errorMessages[index], [`${fieldName}Error`]: fieldError }
    //             };

    //             // Update the field value
    //             this.itemList[i][fieldName] = value;
    //         }
    //     }
    // }

    educaionHandleChange(event){
        debugger;
        let index = event.target.dataset.id;
        let fieldName = event.target.name;
        let value = event.target.value;
        for(let i = 0; i < this.educationList.length; i++) {
            if(this.educationList[i].id === parseInt(index)) {
                delete this.educationList[i].id; 
                this.educationList[i][fieldName] = value;
            }
        }
    }

    eduaddNewRow(){
        debugger;
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        this.educationList = this.educationList.concat(newItem);
        console.log(this.educationList);
    }

    eduremoveRow(event){
        debugger;
        let toBeDeletedRowIndex = event.target.name;
        let educationList = [];
        for(let i = 0; i < this.educationList.length; i++) {
            let tempRecord = Object.assign({}, this.educationList[i]); //cloning object
            if(tempRecord.index !== toBeDeletedRowIndex) {
                educationList.push(tempRecord);
            }
        }
        for(let i = 0; i < educationList.length; i++) {
            educationList[i].index = i + 1;
        }
        this.educationList = educationList;
    }


    addNewRow() {
        debugger;
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        this.itemList = this.itemList.concat(newItem);
        console.log(this.itemList);
    }

    removeRow(event) {
        debugger;
        let toBeDeletedRowIndex = event.target.name;
        let itemList = [];
        for(let i = 0; i < this.itemList.length; i++) {
            let tempRecord = Object.assign({}, this.itemList[i]); //cloning object
            if(tempRecord.index !== toBeDeletedRowIndex) {
                itemList.push(tempRecord);
            }
        }
        for(let i = 0; i < itemList.length; i++) {
            itemList[i].index = i + 1;
        }
        this.itemList = itemList;
    }

    removeAllRows() {
        let itemList = [];
        this.addNewRow();
        this.itemList = itemList;
    }

    // handleChangeStatutory(event){
    //     debugger;
    //     let index = event.target.dataset.id;
    //     let fieldName = event.target.name;
    //     let value = event.target.value;
    //     for (let i = 0; i < this.statutoryList.length; i++) {
    //         if (this.statutoryList[i].id=== parseInt(index)) {
    //             //delete this.statutoryList[i].id; 
    //             this.statutoryList[i][fieldName] = value;
    //         }
    //     }
    // }

    // removeRowStatutory(event){
    //     debugger;
    //     let toBeDeletedRowIndex = event.target.name;
    //     let statutoryList = [];
    //     for(let i = 0; i < this.statutoryList.length; i++) {
    //         let tempRecord = Object.assign({}, this.statutoryList[i]); //cloning object
    //         if(tempRecord.index !== toBeDeletedRowIndex) {
    //             statutoryList.push(tempRecord);
    //         }
    //     }
    //     for(let i = 0; i < statutoryList.length; i++) {
    //         statutoryList[i].index = i + 1;
    //     }
    //     this.statutoryList = statutoryList;
    // }

    // addNewRowStatutory(){
    //     debugger;
        
    //     var newItem = [{ id: this.keyIndex,  Type__c: null, Document_Number__c: null}];
    //     this.statutoryList = this.statutoryList.concat(newItem);
    //     ++this.keyIndex;
    //     console.log(this.statutoryList);
    // }

    //its being called from child component in success messsage on save of personal details 
    showEducationSection(event){
        debugger;
        let eveValue=event.detail;
        this.areDetailsVisible = false;
        this.workExperienceReq = false;
        this.isEducationdetails=true;
        if(!this.lastStep>=2){
         this.lastStep=2;
        }
       
    }

    savdEducationDetails(){
        debugger;
        let educations=this.educationList;
        var recId=this.conId;
        for(let i=0; i=educations.length; i++ ){
        }
        updaateEducation({updateEducationdetailslist:educations,conId:this.conId})
        .then(result =>{
            alert('Education Details Update');
            this.workExperienceReq = true;
            this.isEducationdetails=false;

        })
        .catch(error =>{
            alert('Error...');
            console.log(error);
        })

    }

    uploadFilelwc(){
        debugger;
       let checkIsOpen =this.isShowFileUploaderLWC;
       if(!checkIsOpen){
        this.isShowFileUploaderLWC =!checkIsOpen;
       }
       else{
        this.isShowFileUploaderLWC =!checkIsOpen;
       }
    }

    closefileupoaderModal(){
        this.isShowFileUploaderLWC =false;
    }
    
    handleWorkExperience(){
        debugger;
        let workExpData = this.itemList;
        var recId = this.conId;

        insertWorkExperienceData({ WorkExperienceData:workExpData,conid:this.conId})
        .then(result => {
            if(!this.lastStep>=3){
                this.lastStep=3;
            }
           
            //swal("Congrats", "You Work Experience Have Been Updated Succesfully!!", "success");
          
         });
      this.workExperienceReq = false;
      this.showStatutorySection=true;
    //   this.frameURLSelf = 'https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/DocumentTemplatesCandidate?id='+this.conId;
    //   this.showDocCategories = true;
    }


    handleStatutoryDetails(){
        debugger;
        let statutoryList = this.statutoryList;
        let recId = this.conId;
       
        updateStatutoeyDetails({statutories:this.statutoryList,conId:this.conId})
        .then(result =>{
            swal("🧑‍💻🧑‍💻", " statutories Details Update' ", "success");
            // alert('statutories Details Update');    
            this.showStatutorySection = false;
            this.showDocCategories=true;
            this.frameURLSelf = 'https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/DocumentTemplatesCandidate?id='+this.recordId;

             console.log( this.frameURLSelf);
             if(!this.lastStep>=4){
                this.lastStep=4;
             }
            
        })
        .catch(error =>{
            alert('Error...');
            console.log(error);
        })

    }
 
    

    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg'];
    }

    handleChange() {
        this.showSecondPage = true;
        this.showMainPage = false;
    }

    regExisting(){
        debugger;
        this.showSecondPage = false;
        this.existUserData = true;
    }

    regNew() {
        this.showSecondPage = false;
        this.showreg = true;
        this.areDetailsVisible = true;
        this.showMainPage = false;
    }
    
    handleSubmit(event){
        console.log('Account detail : ',event.detail.fields);
        
    }
    
    removeCSS() {
        this.box = 'box-border';
    }

    handleSuccessCon(event) {
        debugger;
        this.areDetailsVisible = false;
        this.workExperienceReq = true;
        debugger;
       this.conId = event.detail.id;
       //this.getAssignmentList();
       //this.assView = true;
       //alert(event.detail.id);
       //swal("Congrats", "Your Record Has Been Created sucessfully", "success");
       confetti({
        particleCount: 100,
        spread: 70,
        origin: {
          y: 0.6
        }
      });
    }

    openAppModel(){
        debugger;
        this.areAppsAvailable = false;
        this.assView = true;
        this.showProgress = false;
    }

    updateRegId(event){
        debugger;
       this.regid = event.target.value;
    }

    showData(){
        debugger;
        this.showSpinner = true;
        getApplicationList()
        .then(result => {
              this.appList = result;
              if (result.length > 0) {
                debugger;
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                 let tempRecord = Object.assign({}, result[i]);
                 tempRecord.recordLink = "/" + tempRecord.Id;  
                 tempOppList.push(tempRecord);  
                }
                this.appList = tempOppList;
                this.showSecondPage = false;
                this.existUserData =false;
                this.showSpinner = false;
                this.appView = true; 
            }else{
                this.showSpinner = false;
                swal("Sorry", "No Application in Process!!", "error");
            }
         });
        
    }


    showDataOfNewCon(){
        debugger;
        this.showSpinner = true;
        const conId = this.conId;
        getApplicationList({ conID:conId})
        .then(result => {
              this.appList = result;

              if (result) {
                debugger;
                console.log('result'+result);
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                 let tempRecord = Object.assign({}, result[i]); //cloning object  
                 tempRecord.recordLink = "/" + tempRecord.Id;  
                 tempOppList.push(tempRecord);  
                }
                this.appList = tempOppList;
            }
         });
    }

    closeiframe(){
     debugger;
     this.showSelfAssTemp = false;
    }

    openDocsModal(event){
        debugger;
        this.selectedAppId =  event.detail.row.Id;  

        getSelfAssIdandOPId({ appID:this.selectedAppId})
        .then(result => {
            this.JobDescId = result.SelfAssId;
            this.ResStratId = result.OnePagerId
            this.EmpPrfId = result.SelfAssId;
            this.ExecSummId = result.OnePagerId
        });

        this.areAppsAvailable = false;
        this.appView = false;
        this.showProgress = false;
        this.isModalDocsViewOpen = true;
    }

 
    
  openfileUploadApp(event){
    debugger;
    const file = event.target.files[0]
    var reader = new FileReader()
    reader.onload = () => {
        var base64 = reader.result.split(',')[1]
        this.fileData = {
            'filename': file.name,
            'base64': base64,
            'recordId': this.selectedAppId 
        }
        console.log(this.fileData)
    }
    reader.readAsDataURL(file)
    }

    createApp(){
            debugger;
            //this.conId = this.regid;
            this.showProgress = false;
            this.assView = true;
            this.appView = false;
    }

    handleSortdata(event) {
        debugger;
        this.sortBy = event.detail.fieldName;
         
        
        if(event.detail.fieldName == 'recordLink'){
            event.detail.fieldName = 'Name'; 
        }
        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        debugger;
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.accList));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.accList = parseData;

    }

    //fileData
    openfileUploadapp(event) {
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.appId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
   
    openfileUploadSelApp(event) {
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.selectedAppId 
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
    
    openSelfAssModel(event) {
        debugger;
        this.isSelfAssOpen = true;
        this.isModalDocsOpen = false;
        this.assId;
        SelfAssesmentValues({ mandateRecId:this.assId})
        .then(result => {
            this.selfasslist = result[0];
            this.onePagerlist = result[1];
            console.log('hi::'+result);
        })
        .catch(error => {
            this.resultsum = undefined;
            //this.error = error;
        });
    }

    handleClick(){
        debugger;
        const {base64, filename, recordId} = this.fileData
        uploadFile({ base64, filename, recordId }).then(result=>{
            this.fileData = null
            let title = `${filename} uploaded successfully!!`
            
            swal("Congrats", title+" Succesfully Uploaded", "success");
           /* const evt = new ShowToastEvent({
                title: 'Succesfully Uploaded',
                message: title+' has been Uploaded Succesfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);*/
        })
    }

  
    showAssignments() {
        debugger;
        console.log('Show Assignment Method');
        console.log(this.accList);
        this.assView = true;
        this.areDetailsVisible = false;
        this.showMainPage = false;
        this.showAss = false;
        
    }

    callRowAction( event ) {  
        var button = event.detail.action.name;
        if(button == 'Apply'){
        debugger;
        const recId =  event.detail.row.Id;  
        this.assId = recId;
        
        //this.isSelfAssOpen = true;
        SelfAssesmentValues({ mandateRecId:this.assId})
        .then(result => {
            this.selfasslist = result[0];
            this.onePagerlist = result[1];
            //this.isSelfAssOpen = true;
            this.isCreatingApp = true;
            this.assView = false;
            console.log('hi::'+result);
        })
        .catch(error => {
            this.resultsum = undefined;
            //this.error = error;
        });
       }else{
        debugger;
        const recId =  event.detail.row.Id;  
        this.frameURLSelf = 'https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/DocumentTemplates?id='+recId;
        this.showDocCategoriesModal = true;
       }
        
    }

    closeModal() {
        this.isModalOpen = false;
        this.isModalDocsOpen = false;
        this.modalWithAssDocs = false;
    }
    
    closeiframe() {
        this.showDocCategoriesModal = false;
    }

    handleSuccessApp(event) {
        debugger;
        this.appId = event.detail.id;
        this.isCreatingApp = false;
        this.isSelfAssOpen = true;
        //swal("Congrats", "Application Has Been Created sucessfully", "success");
        confetti({
            particleCount: 100,
            spread: 70,
            origin: {
              y: 0.6
            }
          });
       
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        debugger;
        this.selectedAppId;
        if(event.target.name == 'selfAssUploader'){
            event.detail.files[0].name = 'Self Assesment.pdf';
        } else{
            event.detail.files[0].name = 'One Pager.pdf';
        }           
        const uploadedFiles = event.detail.files;

        swal("Congrats", event.detail.files[0].name+" Succesfully Uploaded", "success");
        
    }

    openSelfAss(){
        debugger;
        this.isSelfAssOpen = true;
        this.assId;
        SelfAssesmentValues({ mandateRecId:this.assId})
        .then(result => {
            this.selfasslist = result;
            console.log('hi::'+result);
            // this.error = undefined;
        })
        .catch(error => {
            this.resultsum = undefined;
            //this.error = error;
        });
    }

    submitApp(){
        this.isModalOpen = false;
        this.isSelfAssOpen = false;
        swal("🧑‍💻🧑‍💻", " Your Have Succesfully Applied for this Job Application ", "success");
        confetti({
            particleCount: 100,
            spread: 70,
            origin: {
              y: 0.6
            }
          });
     
    }

    updateResponseSelf(event){
        debugger;
        let tempAllRecords = Object.assign([], this.selfasslist);
        let tempRec = Object.assign({}, tempAllRecords[event.target.name]);
        tempRec.Response__c = event.target.value;
        tempRec.Related_Assignment__c = this.appId;
        tempAllRecords[event.target.name] = tempRec;
        this.selfasslist = tempAllRecords;
    }

    updateResponseOne(event){
        debugger;
        let tempAllRecords = Object.assign([], this.onePagerlist);
        let tempRec = Object.assign({}, tempAllRecords[event.target.name]);
        tempRec.Response__c = event.target.value;
        tempRec.Related_Assignment__c = this.appId;
        tempAllRecords[event.target.name] = tempRec;
        this.onePagerlist = tempAllRecords;
    }

    closeselfAss() {
        this.isSelfAssOpen = false;
    }

    submitSar(){
        debugger;
        let selfAssData = this.selfasslist;
        SelfAssesmentResCreation({ selfAssRes:selfAssData})
        .then(result => {
            //swal("Congrats", "Your Self Assesment Has Been Submitted Succesfully!!", "success");
         });
         this.isSelfAssOpen = false;
         this.isCreatingOP = true;
    }

	getAssignmentListinitial(){
		debugger;
		getAssignmentList()
		.then(result => {
			var tempOppList = [];  
			for (var i = 0; i < result.length; i++) {  
			let tempRecord = Object.assign({}, result[i]); //cloning object  
			tempRecord.recordLink = "/lightning/r/Mandate__c/" + tempRecord.Id+'/view';  
			tempOppList.push(tempRecord);  
			}
			this.accList = tempOppList;
			this.showDocCategories = false;
			this.confirmation = true;
            if(!this.lastStep>=5){
                this.lastStep=5;
            }
           
		});
	}
	 
    submitOP(){
        debugger;
        let onePagerData = this.onePagerlist;
        OnePagerResCreation({ onePagerRes:onePagerData})
        .then(result => {
            swal("😊😊", "Application Submitted Succesfully!!", "success");   
         });
         this.showDataOfNewCon();
         this.showWarning = false;
         this.isSelfAssOpen = false;
         this.isCreatingOP = false;
         this.showSpinner = false;
         this.confirmation = true;
         //this.appView = true;
    }

    handleChangeStatutory(event) {
        debugger;
        const fieldName = event.target.dataset.field;
        const fieldValue = event.target.value;
        let tempList = [];
        let isTypeFound = false;
    
        switch (fieldName) {
            case 'aadharNumber':
                this.aadharNumber = fieldValue;
                tempList.push({ Type__c: 'Aadhar', Document_Number__c: fieldValue });
                break;
            case 'panNumber':
                this.panNumber = fieldValue;
                tempList.push({ Type__c: 'PAN', Document_Number__c: fieldValue });
                break;
            case 'uanNumber':
                this.uanNumber = fieldValue;
                tempList.push({ Type__c: 'UAN', Document_Number__c: fieldValue });
                break;
            case 'fatherName':
                this.fatherName = fieldValue;
                tempList.push({ Type__c: 'FATHER', Document_Number__c: fieldValue });
                break;
            case 'pfNumber':
                this.pfNumber = fieldValue;
                tempList.push({ Type__c: 'PF', Document_Number__c: fieldValue });
                break;
            case 'esiNumber':
                this.esiNumber = fieldValue;
                tempList.push({ Type__c: 'ESIC', Document_Number__c: fieldValue });
                break;
            default:
                break;
        }
    
        // Check if object with the same Type__c already exists
        for (let i = 0; i < this.statutoryList.length; i++) {
            if (this.statutoryList[i].Type__c === tempList[0].Type__c) {
                // Replace the existing object with the new one
                this.statutoryList[i] = tempList[0];
                isTypeFound = true;
                break;
            }
        }
    
        // If the object with the same Type__c doesn't exist, add the new object to the list
        if (!isTypeFound) {
            this.statutoryList = [...this.statutoryList, ...tempList];
        }
    
        console.log('list of statutory list is ', this.statutoryList);
        console.log(JSON.stringify(this.statutoryList));
    }

    selectStep(event){
        debugger
       this.selectedStep=event.target.value;
       let choosenPath=this.selectedStep;
        if(choosenPath==1){
            this.areDetailsVisible=true;
            this.isEducationdetails=false;
            this.workExperienceReq=false;
            this.showStatutorySection=false;
            this.showDocCategories=false;
            this.confirmation=false;

        }else if (choosenPath==2 &&choosenPath<=3){
            this.isEducationdetails=true;
            this.areDetailsVisible=false;
            this.workExperienceReq=false;
            this.showStatutorySection=false;
            this.showDocCategories=false;
            this.confirmation=false;
        } 
        else if (choosenPath==3 &&choosenPath<=3){
            this.workExperienceReq=true;
            this.isEducationdetails=false;
            this.areDetailsVisible=false;
            this.showStatutorySection=false;
            this.showDocCategories=false;
            this.confirmation=false;
        }
        else if (choosenPath==4 &&choosenPath<=4){
            this.showStatutorySection=true;
            this.workExperienceReq=false;
            this.isEducationdetails=false;
            this.areDetailsVisible=false;
            this.showDocCategories=false;
            this.confirmation=false;
        }
        else if (choosenPath==5 && choosenPath<=5){
            this.showDocCategories=true;
            this.showStatutorySection=false;
            this.workExperienceReq=false;
            this.isEducationdetails=false;
            this.areDetailsVisible=false;
            this.confirmation=false;
        }
        else if (choosenPath==6 ){
            this.confirmation=true;
            this.showDocCategories=false;
            this.showStatutorySection=false;
            this.workExperienceReq=false;
            this.isEducationdetails=false;
            this.areDetailsVisible=false;
        }
        
    }
    
    
}