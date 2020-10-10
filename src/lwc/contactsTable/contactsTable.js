import {LightningElement, track, wire} from 'lwc';
import getPaginatedContacts from '@salesforce/apex/ContactsPagableController.getPaginatedContacts';
import getContactsCount from '@salesforce/apex/ContactsPagableController.getContactsCount';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class ContactsTable extends LightningElement {

    @track columns = [
        {
            label: 'Id',
            fieldName: 'Id'
        },
        {
            label: 'Name',
            fieldName: 'Name'
        }
    ];

    @track pageNumber = 0;
    @track pageSize = 2;
    @track contactsCount;
    @track contacts;

    @wire(getPaginatedContacts, {
            pageNumber: '$pageNumber',
            pageSize: '$pageSize'
        }
    ) wiredContacts({error, data}) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.log(error);
        }
    }


    connectedCallback() {
        getContactsCount().then(result => {
            this.contactsCount = result;

        });
    }

    firstPageHandler() {
        if (this.pageNumber > 0) {
            this.pageNumber = 0;
        } else {
            const event = new ShowToastEvent({
                title: 'First Page',
                message: 'The first page is already reached',
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }

    lastPageHandler() {
        let lastPageIndex = Math.floor(this.contactsCount / this.pageSize) - 1;
        if (this.pageNumber < lastPageIndex) {
            this.pageNumber = lastPageIndex;
        } else {
            const event = new ShowToastEvent({
                title: 'Last Page',
                message: 'The last page is already reached',
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }

    nextPageHandler() {
        let lastPageIndex = Math.floor(this.contactsCount / this.pageSize) - 1;
        if (this.pageNumber < lastPageIndex) {
            this.pageNumber += 1;
        } else {
            const event = new ShowToastEvent({
                title: 'Last Page',
                message: 'The last page is already reached',
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);

        }
    }

    previousPageHandler() {
        if (this.pageNumber > 0) {
            this.pageNumber -= 1;
        } else {
            const event = new ShowToastEvent({
                title: 'First Page',
                message: 'The first page is already reached',
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }

    optionSelectedHandler(event) {
        this.pageSize = event.detail;
    }

    switchToPageHandler(event){
        this.pageNumber = event.detail;
    }
}