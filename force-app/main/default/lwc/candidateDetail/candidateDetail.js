import { LightningElement,api,wire,track } from 'lwc';
import getUserdatachild from'@salesforce/apex/CommunitiesLoginControllerLwc.getUserdatachild';
import updateContact from '@salesforce/apex/CommunitiesLoginControllerLwc.updateContact';
export default class CandidateDetail extends LightningElement {
    //Booleans for templates
    @api recordid;
    isDetailsdone=true;
    isWorkExperinceSection=false;
    isDisabledinput=true;
     @track tempCandidateObject = {};
     @track  candidateObject={
         FirstName:'',
         LastName:''
     };
      MailingAddress = {
        street: '',
        city: '',
        country: '',
        province: '',
        postalCode: ''
    };
     OtherAddress = {
        street: '',
        city: '',
        country: '',
        province: '',
        postalCode: ''
    };
    @wire (getUserdatachild,{recordId: '$recordid'})
    wiredResult(result){
        debugger;
        if(result.data){
            this.candidateObject = result.data;
            this.tempCandidateObject = { ...result.data };
            console.log('result.data------->',result.data);

            
        }
        if(result.error){
            alert('Please check console for error');
            //  window.location.href = loginPage;
        }
    } 

    handleChangeValidation(event) {
        debugger;
        let fieldName = event.target.name;
        let value = event.target.value;
        let candidateObject = {...this.candidateObject};
        if (fieldName === "firstName") {
            candidateObject.FirstName = value;
        } else if (fieldName === "lastName") {
            candidateObject.LastName = value;
        } else if (fieldName === "userEmail") {
            candidateObject.Email = value;
        } else if (fieldName === "userPhone") {
            candidateObject.Phone = value;
        } else if (fieldName === "fatherName") {
            candidateObject.Father_Name__c = value;
        } else if (fieldName === "higherEducation") {
            candidateObject.Higereducation__c = value;
        } else if (fieldName === "LinkedInURL") {
            candidateObject.LinkedIn_URL__c = value;
        } else if (fieldName==="birthdate") {
            candidateObject.Birthdate=value;  
        } else if(fieldName==="anniVerserydate"){
            candidateObject.Anniversary_Date__c=value;  
        }
        this.candidateObject = candidateObject;
           
        
    }
    

    handleWorkExperiance(event){
        debugger;
        let getdataName = event.target.name;


        if(getdataName =='company'){
            let company = this.template.querySelector('.company');
            let companyval = firstName.value;
        }
    }


    pernanentAddresChange(event){
        debugger;
        let pernanentAddress=event.target;
        this.permaAddress.street=pernanentAddress.street;
        this.permaAddress.city=pernanentAddress.city;
        this.permaAddress.province=pernanentAddress.province;
        this.permaAddress.country=pernanentAddress.country;
        this.permaAddress.postalCode=pernanentAddress.postalCode;
        this.candidateObject.MailingAddress=this.permaAddress;
    }

    tempraryAddresChange(event){
        debugger;
        let tempraryAddress=event.target;
        this.tempAddress.street=tempraryAddress.street;
        this.tempAddress.city=tempraryAddress.city;
        this.tempAddress.province=tempraryAddress.province;
        this.tempAddress.country=tempraryAddress.country;
        this.tempAddress.postalCode=tempraryAddress.postalCode;
        this.candidateObject.OtherAddress=this.tempAddress;

    }

    backTo(){
       this.isDetailsdone=true;
        this.isWorkExperinceSection=false;
    }

    nestToAddress(){
        this.isDetailsdone=false;
        this.isWorkExperinceSection=true;
    }

    saveNext(){
       
        debugger;
        updateContact({updatConact:this.candidateObject})
        .then(response=>{
            alert('updated successfully');
        })
        .catch(error=>{
            alert('updated error');
            console.log('Error',error.body.message);
        })
        debugger;
        console.log('at final view candidateObject--->',this.candidateObject);     
        // this.isDetailsdone=false;
        // this.isWorkExperinceSection=true;
    }

    editCandidate(){
        debugger;
        let getStatus=this.isDisabledinput;
        if(getStatus==false){
            this.isDisabledinput=true;
        }
        else{
            this.isDisabledinput=false;
        }
    }

}