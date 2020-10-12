import {LightningElement, api, track} from 'lwc';
import getContactsCount from '@salesforce/apex/ContactsPagableController.getContactsCount';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Paginator extends LightningElement {
    @track totalPages;

    connectedCallback() {
        getContactsCount().then(result => {
            let pageSize = this.template.querySelector('select').value;
            this.totalPages = Math.ceil(result / pageSize);
        });
    }

    previousHandler() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    nextHandler() {
        this.dispatchEvent(new CustomEvent('next'));
    }

    FirstPageHandler() {
        let event = new CustomEvent('firstpage');
        this.dispatchEvent(event);
    }

    LastPageHandler() {
        let event = new CustomEvent('lastpage');
        this.dispatchEvent(event);
    }

    changeOptionHandler(event) {
        event.preventDefault();
        let selectedOption = event.target.value;
        let selectedEvent = new CustomEvent('selectedoption', {detail: selectedOption});
        this.dispatchEvent(selectedEvent);

        let pageSize = event.target.value;
        getContactsCount().then(result => {
            this.totalPages = Math.ceil(result / pageSize);
        });
    }

    handleSwitchToPage() {
        let inputField = this.template.querySelector('lightning-input');
        let pageIndex = parseInt(inputField.value, 10) - 1;
        if (pageIndex < 0 || pageIndex > this.totalPages - 1) {
            console.log('page index' + pageIndex);
            const event = new ShowToastEvent({
                title: 'Wrong Input',
                message: 'Page Number should be bigger than 0 and lowe than total pages number',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        } else {
            let event = new CustomEvent('switchtopage', {detail: pageIndex});
            this.dispatchEvent(event);
        }
    }

}