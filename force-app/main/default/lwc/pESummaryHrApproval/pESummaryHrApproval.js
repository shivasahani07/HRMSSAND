import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import submitForApproval from '@salesforce/apex/PESummaryHrApproval.submitForApproval';

export default class PESummaryHrApproval extends LightningElement {
    @api recordId;
    showSuccessMessage = false;
    errorMessage;

    connectedCallback() {
        setTimeout(() => {
          this.sendApprovalRequest();
        }, 3000);
    }

    sendApprovalRequest() {
        submitForApproval({ summaryId: this.recordId })
            .then(() => {
                    this.showSuccessMessage = true;
                    this.errorMessage = null;
                    this.showToast('Success', 'Approval sent successfully!!', 'success', true);
                    this.updateRecordView();
                    this.closeQuickAction();
            })
            .catch(error => {
                this.errorMessage = error.message;
                this.showToast('Error', this.errorMessage, 'error', false);
                this.closeQuickAction();
                throw new Error('Failed to submit approval');
            });
    }

    showToast(title, message, variant, closePanel) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

   updateRecordView() {
       setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
       }, 1000); 
    }
}