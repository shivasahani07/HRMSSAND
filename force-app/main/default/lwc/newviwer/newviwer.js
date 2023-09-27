import { LightningElement,wire  } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getDocumentTemplatesWithAttachments from '@salesforce/apex/DocumentTemplateController.getDocumentTemplatesWithAttachments';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    // Add more columns for other fields you want to display
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    }
];

const actions = [
    { label: 'View Attachments', name: 'view_attachments' }
];
export default class Newviwer extends LightningElement {
   documentTemplates;
    columns = columns;
     showModal = false;

    @wire(getDocumentTemplatesWithAttachments)
    wiredDocumentTemplates({ data, error }) {
        if (data) {
            this.documentTemplates = data;
        } else if (error) {
            console.error(error);
        }
    }

     handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view_attachments') {
             this.selectedTemplateName = row.Name;
            this.attachments = row.Attachments;
            this.showModal = true;
            
        }
    }
}