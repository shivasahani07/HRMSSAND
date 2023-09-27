/**
 * @author Dinesh B
 * @email dinesh.b@utilitarianlab.com
 * @create date 2023-09-19 18:19:15
 * @modify date 2023-09-19 18:19:15
 * @desc [description]
 */

import { LightningElement,track,api } from 'lwc';
import LightningConfirm from "lightning/confirm";
import LightningAlert from 'lightning/alert';
import staticlogo from '@salesforce/resourceUrl/HRMS_Logo';
import applayLeaveMethod from '@salesforce/apex/LeaveManagementHelper.applayLeaveMethod';
import getPickListValuesMethod from '@salesforce/apex/LeaveManagementHelper.getPickListValuesMethod';
// import getAllDateListMethod from '@salesforce/apex/LeaveManagementHelper.getAllDatesList';
// import getAllDayType from '@salesforce/apex/LeaveManagementHelper.getAllDayTypeList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import modal from "@salesforce/resourceUrl/custommodalcss";
import { loadStyle } from "lightning/platformResourceLoader";
import insertLeavRecord from '@salesforce/apex/LeaveManagementHelper.insertingLeavTrasRecord';


export default class LeaveForm extends LightningElement {


    
 
addimage = staticlogo;
// contactId = '0030k00001UFaohAAD';
employeId;
contactEmail;
@api recordId;
@track result;
@track error;
@track leaveTypeList = [];
@track dateList = [];
@track dayTypeList = [];
@track dynamicDateList = [];
@track showTable = false;
@track startdate;
@track enddate;

@track diffStartDate;
@track diffEndDate;
@track timeDifference;
@track diffDays;
@track EmpPolDetails;
@track leavPolDetails;
@track leaveMasterDetails;
@track LevPolicyStartDate;
@track LeaPolicyEndDate;
@track leaveBalance;
@track AllowInAccessCheck;
@track totalDayCount = 0;
@track intialDayCount= 0;
@track intialIndex;
@track leaveDescription;
@track leaveMasterDetailID;
@track showDateWarning = false;
@track selectedOption;
@track defaultLeaveType = 'Full Day';
@track selectedRecordIdFromParent;


options = [
            { label: 'Half Day', value: 'Half Day' },
            { label: 'Full Day', value: 'Full Day' },
        ];

 connectedCallback(){
        setTimeout(() => {
            loadStyle(this, modal);
           // this.getRecordDetails();
            this.getPicklistValue();
           // this.getDayTypeList();
        }, 300);
    }



   getRecordDetails(){
       debugger;
      applayLeaveMethod({
          recordId : this.selectedRecordIdFromParent
      })
      .then(result =>{
          if(result){
          this.EmpPolDetails = result.getEmpPolDetails;
          this.leavPolDetails = result.getLeavePol;
          this.leaveMasterDetails = result.getLevMasDetails;
          this.LevPolicyStartDate = this.leavPolDetails.Start_Date__c;
          this.LeaPolicyEndDate = this.leavPolDetails.End_Date__c;
          this.leaveBalance = result.getLevMasDetails.Leave_Balance__c;
          this.AllowInAccessCheck = result.getLevMasDetails.Allow_In_Access__c;
          this.leaveMasterDetailID = result.getLevMasDetails.Id;
          }
      })
      .catch(error =>{
       this.error = error;
      })
   }

   getPicklistValue(){
       debugger;
       getPickListValuesMethod()
       .then(result => {
                console.log('result 1--', result);
                let arr1 = [];
                if(result){
                    for (var key in result) { 
                        console.log('key 1--', key);
                        arr1.push({ label:key,value:result[key]});
                    }
                }
                this.leaveTypeList = arr1;
            })
            .catch(error => {
                this.error = error;
            });
       }

HandleChangeLeaveReason(event){
debugger;
this.value = event.detail.value;
this.leaveDescription = this.value;
}

    handleChangeDays(event) {
        debugger;
       this.value = event.detail.value;
       this.intialIndex = parseInt(event.target.dataset.index);
        if(this.value === 'Half Day'){
            this.intialDayCount =  this.intialDayCount +  0.5 ;
        }
        if(this.value === 'Full Day'){
            this.intialDayCount = this.intialDayCount + 1;
        }
        this.dateList[this.intialIndex].leavePlan = this.value;
        this.calculateTotalLeave();
    }

    calculateTotalLeave(){
        let tDayCount = 0;
        this.dateList.forEach(leave=>{
            debugger;
            tDayCount = tDayCount + (JSON.stringify(leave.leavePlan) == JSON.stringify('Full Day')? 1:0.5);
        });
        this.totalDayCount = tDayCount;
    }

    HandleChangeLeaveType(event){
      //  debugger;
        this.value = event.detail.value;
    }

       HandleChangedate(event){
           debugger;
             let value=event.target.value;
             if(event.target.name=='startDate'){
             this.startdate=value;
            }
             if(event.target.name=='endDate'){
             this.enddate=value;
            }
            if(this.enddate >= this.startdate){
                this.showTable = true;
            }else{
                 this.showTable = false;
            }
            if(this.enddate < this.startdate){
                this.showToastEndLessThanStartDate();
            }
             this.diffStartDate = new Date(this.startdate);
             this.diffEndDate = new Date(this.enddate);
             if(this.diffEndDate !=undefined && this.diffStartDate !=undefined){
             this.timeDifference =  this.diffEndDate -  this.diffStartDate;
             this.diffDays = Math.ceil(this.timeDifference / (1000 * 60 * 60 * 24));
             console.log('Day difference === > '+ this.diffDays);
              }
            let dArray = [];
            if(this.diffDays === 0){
             let currentDate = new Date(this.startdate);
             dArray.push({selectedDate:currentDate.toDateString(),leavePlan:this.defaultLeaveType});
             
            }else{
                for (let i = 1; i <= this.diffDays + 1; i++) {
                        let currentDate = new Date(this.startdate);
                        currentDate.setDate(currentDate.getDate() + i - 1); // Add i - 1 days
                        dArray.push({selectedDate:currentDate.toDateString(),leavePlan:this.defaultLeaveType});      
                 }
            }

            this.dateList = dArray;
            this.calculateTotalLeave();
            console.log('Leave Cycle StartDate === > '+ this.LevPolicyStartDate);
            console.log('Leave Cycle EndDate === > '+ this.LeaPolicyEndDate);
            if(this.startdate <this.LevPolicyStartDate){
                alert('Leave Start Date can be less then Leave Cycle StartDate');
                return;
            }
            if(this.startdate > this.LeaPolicyEndDate){
                alert('Leave Start Date & End Date can not be greater then Leave Cycle EndDate');
                return;
            }
       }

HandleSumbit(){
    debugger;
    if( this.leaveBalance === 0 && this.AllowInAccessCheck === false){
        alert('Leave Balance is Zero,');
        this.showToastLeaveBalanceZero();
        return;
    }
   
   insertLeavRecord({
       CandidateId : this.selectedRecordIdFromParent,LeaveMasterDetailsId : this.leaveMasterDetailID,LeaveDaysCount : this.totalDayCount,ApplyStartDate:this.startdate,ApplyEndDate:this.enddate,LeaveDescription:this.leaveDescription,leavePlanObj:this.dateList
   })
   .then(result=>{
       if(result){
           this.showSuccessMessage();
           var BaseURL =  window.location.href.slice(0,63);
            window.location.replace( BaseURL+'lightning/r/Leave_Transaction__c/'+result.Id+'/view');
       }
   })
   .catch(error =>{
      this.showErrorToast();
   })
}
        showToastEndLessThanStartDate(){
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'End Date can not be Less Start Date',
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

     showToastLeaveBalanceZero(){
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Leave Balance Zero. Can not Applay Leave',
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


     showSuccessMessage(){
        const evt = new ShowToastEvent({
        title: 'SUCCESS',
        message: 'Leave Applied Successfully !',
        variant: 'success',
        mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


    showErrorToast() {
    const evt = new ShowToastEvent({
        title: 'ERROR',
        message: 'Some unexpected error',
        variant: 'error',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
}


 hanldeProgressValueChange(event) {
     debugger;
    this.selectedRecordIdFromParent = event.detail;
    this.getRecordDetails();
  }

}