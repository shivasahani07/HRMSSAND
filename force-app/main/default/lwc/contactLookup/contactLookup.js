import { LightningElement,wire,track,api } from 'lwc';
import searchContacts from '@salesforce/apex/JobapplicationHelper.searchContacts';

export default class ContactLookup extends LightningElement {

    @track selectedContactName = '';
    @track selectedContactId = ''; // To store the selected Contact's ID
    @track contacts = [];

    handleSearch(event) {
        debugger;
        const searchValue = event.target.value;
        searchContacts({searchTerm:searchValue})
        .then( result => {
           this.contacts=result;
            console.log('contactList---->',this.contactList);
          
        }).catch( error => {
            console.log(error);
        });
    }

    selectContact(event) {
        const selectedContactId = event.currentTarget.dataset.key; // Assuming you set a 'data-key' attribute with the Contact's ID
        const selectedContact = this.contacts.find(contact => contact.Id === selectedContactId);

        if (selectedContact) {
            this.selectedContactName = selectedContact.Name;
            this.selectedContactId = selectedContact.Id; // Store the selected Contact's ID
        }
    }

}