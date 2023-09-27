import { LightningElement,wire, track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllpartners from '@salesforce/apex/JobapplicationHelper.getAllpartners';
import createPostJobRecords from '@salesforce/apex/JobapplicationHelper.createPostJobRecords';


export default class PostJob extends LightningElement {
    @api recordId='a250k000000jvFwAAI';
      data = [];
    error;
    @track selectedRecordIds = [];
    @track selectedRadioRecord = '';
    
    @wire(getAllpartners, {JobReqId:'$recordId'})
    wireAccounts({ error, data }) {
        debugger;
        if (data) {
            this.data = data;
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


    
}