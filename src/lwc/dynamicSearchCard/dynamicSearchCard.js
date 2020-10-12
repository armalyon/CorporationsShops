import {LightningElement, wire, track} from 'lwc';
import getSobjectsByNameAndSobjectType from '@salesforce/apex/DynamicSearchController.getSobjectsByNameAndSobjectType'

const SEARCH_DELAY = 400;

export default class DynamicSearchCard extends LightningElement {

    sobjectName;
    @track sobjectType;
    @track searchResults;

    @wire(getSobjectsByNameAndSobjectType, {
        sobjectType: '$sobjectType',
        sobjectName: '$sobjectName'
    }) wiredResults({error, data}) {
        if (data) {
            this.searchResults = data;
        } else if (error) {
            console.log(error);
        }
    };

    renderedCallback() {
        this.sobjectType = this.template.querySelector('select').value;
    }

    handleSelectChange(event) {
        this.sobjectType = event.target.value;
    }

    handleInputChange(event) {
        window.clearTimeout(this.delayTimeout);
        let searchKey = event.target.value.trim();
        this.delayTimeout = setTimeout(() => {
            if (searchKey !== '') {
                this.sobjectName = searchKey;
            }
        }, SEARCH_DELAY);
    }

}