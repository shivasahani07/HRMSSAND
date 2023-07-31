import { LightningElement,track,wire,api } from 'lwc';
import CheckAttendesRecord from '@salesforce/apex/CheckInCheckOutController.CheckAttendesRecord';
import HandleCheckIn from '@salesforce/apex/CheckInCheckOutController.HandleCheckIn';
import HandleCheckOut from '@salesforce/apex/CheckInCheckOutController.HandleCheckOut';
import HandleEndBreakTime from '@salesforce/apex/CheckInCheckOutController.HandleEndBreakTime';
import HandleStartBreakTime from '@salesforce/apex/CheckInCheckOutController.HandleStartBreakTime';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CheckInCheckOutLWC extends LightningElement {

     BooleanValue;
     HandleDisable;

    @wire(CheckAttendesRecord,{})
    wiredAttendes({ error, data }) {
        debugger;
        if (data) {
            this.BooleanValue = data;
            if(data==true){
               this.HandleDisable=true;
            }else{
               this.HandleDisable=false;
            }
            console.log('BooleanValue--'+JSON.stringify(this.BooleanValue));
            console.log('data--'+JSON.stringify(data));
        } else if (error) {
            console.log('Error--'+JSON.stringify(error));
        }
    }

        handleCheckIn(){
        debugger;
        this.HandleDisable=true;
        HandleCheckIn()
            .then(result => {
                        if(result=='SUCCESS'){
                        const event = new ShowToastEvent({
                        title: 'success',
                        message: 'success',
                        variant: 'success',
                        mode: 'dismissable'
                        });
                        this.dispatchEvent(event); 
                    }
            })
            .catch(error => {
                console.log('Errorured:- '+error.body.message);
            });
        }

    handleCheckOut(){
     debugger;
            HandleCheckOut()
            .then(result => {
                        if(result=='SUCCESS'){
                        const event = new ShowToastEvent({
                        title: 'success',
                        message: 'success',
                        variant: 'success',
                        mode: 'dismissable'
                        });
                        this.dispatchEvent(event); 
                    }
            })
            .catch(error => {
                console.log('Errorured:- '+error.body.message);
            });
    }

    handleEndBreakTime(){
         debugger; 
        HandleEndBreakTime()
        then(result => {
            if(result=='SUCCESS'){
                    const event = new ShowToastEvent({
                    title: 'success',
                    message: 'success',
                    variant: 'success',
                    mode: 'dismissable'
                    });
                    this.dispatchEvent(event); 
                }         
            })
            .catch(error => {
                console.log('Errorured:- '+error.body.message);
            });

    }

    handleStartBreakTime(){
        debugger;
        HandleStartBreakTime()
            .then(result => {
                        if(result=='SUCCESS'){
                        const event = new ShowToastEvent({
                        title: 'success',
                        message: 'success',
                        variant: 'success',
                        mode: 'dismissable'
                        });
                        this.dispatchEvent(event); 
                    }
            })
            .catch(error => {
                console.log('Errorured:- '+error.body.message);
            });
    }

}