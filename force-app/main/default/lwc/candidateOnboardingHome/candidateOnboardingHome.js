import { LightningElement,api,track,wire } from 'lwc';
import performLogout from '@salesforce/apex/CommunitiesLoginControllerLwc.performLogout';
import getUserdata from'@salesforce/apex/CommunitiesLoginControllerLwc.getUserdata';
import { CurrentPageReference } from 'lightning/navigation';


const loginPage = 'https://sales-production--hrmsdemo.sandbox.my.salesforce-sites.com/candidatelogin' // Replace this with the actual login page URL

export default class CandidateOnboardingHome extends LightningElement {
// booleans for tempaltes show hide
    conRecord;
    @track picklistValues;

    @api recordId;
    @api hashCodeId='1938463916781488686';
    isShowMyProfile=false;
    isShowDocUploader=false;
    // fullurlforDocPage=`https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/DocumentTemplatesCandidate?Id=`+recordId;
    @track error;
    @track wireResponse;
    @track logOutSuccess;
    candidateName;

    

    @wire(CurrentPageReference)
    currentPageReference;


    @wire (getUserdata,{recordId: '$hashCodeId'})
    wiredResult(result){
        debugger;
        
        if(result.data){
            this.recordId=result.data.conrecord.Id;
            this.candidateName=result.data.conrecord.Name;
            this.conRecord = result.data.conrecord;
            this.picklistValues =result.data.piclistValues;
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
  

    selectedNav = 'default_recent';
    @api togglePanel() {
        let leftPanel = this.template.querySelector("div[data-my-id=leftPanel]");
        let rightPanel = this.template.querySelector("div[data-my-id=rightPanel]");
        if (leftPanel.classList.contains('slds-is-open')) {
            leftPanel.classList.remove("slds-is-open");
            leftPanel.classList.remove("open-panel");
            leftPanel.classList.add("slds-is-closed");
            leftPanel.classList.add("close-panel");
            rightPanel.classList.add("expand-panel");
            rightPanel.classList.remove("collapse-panel");
        } else {
            leftPanel.classList.add("slds-is-open");
            leftPanel.classList.add("open-panel");
            leftPanel.classList.remove("slds-is-closed");
            leftPanel.classList.remove("close-panel");
            rightPanel.classList.remove("expand-panel");
            rightPanel.classList.add("collapse-panel");
        }
    }
    refreshUserData(evt){
        const buttonIcon = evt.target.querySelector('.slds-button__icon');
        buttonIcon.classList.add('refreshRotate');
        setTimeout(() => {
            buttonIcon.classList.remove('refreshRotate');
        }, 1000);
    }
    handleSelect(event) {
        debugger;
        const selected = event.detail.name;
        this.selectedNav = selected;
        if(selected !='Profile'){
            this.isShowMyProfile=false;
             //this.isShowDocUploader=false;
        }
        else{
            this.isShowMyProfile=true;
        }
        if(selected =='logout'){
            //alert('this is logout function');
           
        }

        if(selected !='docUploader'){
            this.isShowDocUploader=false;
            //this.isShowMyProfile=false;
        }
        else{
            this.isShowDocUploader=true;
        }
    }

    logOut() {
        debugger;
        performLogout({hashCode :this.recordId})
            .then(() => {
                // Display a success alert for debugging
                window.location.href = loginPage;
                 alert('Success: Logged out successfully');
            })

            .catch(error => {
                this.error = error;
                
                 window.location.href = loginPage;
            });
    }


    handlePageLoad() {
        // Get the URL query parameters from the current page reference
        const queryParameters = this.currentPageReference && this.currentPageReference.state;

        // Check if the 'hashCode' parameter is present in the URL
        if (queryParameters && 'hashCode' in queryParameters) {
            const hashCodeValue = queryParameters.hashCode;
            // Do something with the 'hashCode' value, e.g., handle login or logout actions
            console.log('HashCode found in URL:', hashCodeValue);
            // Perform your login actions here if needed
        } else {
            // 'hashCode' parameter not found in URL, redirect to the login page
            console.log('HashCode not found in URL, redirecting to login page');
            window.location.href = loginPage;
        }
    }


   
    

}