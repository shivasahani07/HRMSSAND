import { LightningElement,api,wire,track } from 'lwc';
import getUserdata from'@salesforce/apex/CommunitiesLoginControllerLwc.getUserdata';
import updateContact from '@salesforce/apex/CommunitiesLoginControllerLwc.updateContact';
export default class CandidateDetail extends LightningElement {
    //Booleans for templates
    @api recordid;
    isDetailsdone=true;
    isWorkExperinceSection=false;
    isDisabledinput=true;

    candidateObject={};
    address = {};


    @wire (getUserdata,{recordId: '$recordid'})
    wiredResult(result){
        debugger;
        
        if(result.data){
            this.candidateObject = result.data.conrecord;
            //this.picklistValues =result.data.piclistValues;
            // this.picklistValues =result.data.piclistValues;
            console.log('this.recordId',this.recordId);
            console.log('this.conRecord',this.conRecord);
            console.log(' this.picklistValues',this.picklistValues);
        }
        if(result.error){
            alert('Please check console for error');
             window.location.href = loginPage;
        }
    } 

    handleChangeValidation(event){
        debugger;
      let getFirstName = event.target.name;
      let getLstName = event.target.name;
      let getUserEmail = event.target.name;
      let getUserPhone = event.target.name;
      let getUserdepartment = event.target.name;
      let LinkedInurl=event.target.value;
      let permanentAddress=event.target.value
      let tempraryAddress=event.target.value;
      let higerEducation = event.target.name;
 
 
      if(getFirstName === "firstName"){
          let firstName = this.template.querySelector('.firstName');
          this.candidateObject.FirstName =firstName.value;
        //   this.candidateObject.push({firstName:firstName.value});
        //   if(!firstNameVal){
        //     firstName.setCustomValidity('Please Enter the First Name');
        //   }else{
        //     firstName.setCustomValidity('');
        //   }
        //   firstName.reportValidity();
      }
 
 
      else if(getLstName === "lastName"){
        let lastName = this.template.querySelector('.lastName');
         this.candidateObject.LastName =lastName.value;
        //  if(!lastNameVal){
        //     lastName.setCustomValidity('Please Enter the Larst Name');
        // }else{
        //     lastName.setCustomValidity('');
        // }
        // lastName.reportValidity();
       }
 
 
       else if(getUserEmail === "userEmail"){
        let userEmail = this.template.querySelector('.userEmail');
        this.candidateObject.Email=userEmail.value;
        // if(!userEmailVal){
        //     userEmail.setCustomValidity('Please Enter the Email Id');
        // }else{
        //     userEmail.setCustomValidity('');
        // }
        // userEmail.reportValidity();
       }
 
 
       else if(getUserPhone === "userPhone"){
        let userPhone = this.template.querySelector('.userPhone');
        this.candidateObject.Phone=userPhone.value;
        // if(!userPhoneVal){
        //     userPhone.setCustomValidity('Please Enter the Email Id');
        // }else{
        //     userPhone.setCustomValidity('');
        // }
        // userPhone.reportValidity();
       }


        else if(getUserdepartment === "department"){
        let department = this.template.querySelector('.department');
        this.candidateObject.Department=department.value;
        // if(!userPhoneVal){
        //     userPhone.setCustomValidity('Please Enter the Email Id');
        // }else{
        //     userPhone.setCustomValidity('');
        // }
        // userPhone.reportValidity();
       }

       
        else if(LinkedInurl === "LinkedInURL"){
        let LinkedInurll = this.template.querySelector('.LinkedInURL');
        this.candidateObject.LinkedIn_URL__c=LinkedInurll.value;
        // if(!userPhoneVal){
        //     userPhone.setCustomValidity('Please Enter the Email Id');
        // }else{
        //     userPhone.setCustomValidity('');
        // }
        // userPhone.reportValidity();
       }

       else if(higerEducation === "higherEducation"){
        let higerEducation = this.template.querySelector('.LinkedInURL');
        this.candidateObject.Higereducation__c=higerEducation.value;
        // if(!userPhoneVal){
        //     userPhone.setCustomValidity('Please Enter the Email Id');
        // }else{
        //     userPhone.setCustomValidity('');
        // }
        // userPhone.reportValidity();
       }

       else if(permanentAddress === "permanentAddress"){
        debugger;
        let PermanentAddress = this.template.querySelector('.permanentAddress');
        this.candidateObject.MailingAddress.street=PermanentAddress.value.street;
        
       }

       else if(tempraryAddress === "tempraryAddress"){
        debugger;
        let TempraryAddress = this.template.querySelector('.tempraryAddress');
        this.candidateObject.OtherAddress=TempraryAddress.value;
        
       }


 


       console.log('at final view candidateObject--->',this.candidateObject);     
 
    }


    handleWorkExperiance(event){
        debugger;
        let getdataName = event.target.name;


        if(getdataName =='company'){
            let company = this.template.querySelector('.company');
            let companyval = firstName.value;
        }
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
        this.candidateObject.Id=this.recordid;
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

}