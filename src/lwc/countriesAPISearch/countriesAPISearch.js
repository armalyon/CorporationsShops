
import {LightningElement, track} from 'lwc';
import getCountriesBySelectorAndValue from '@salesforce/apex/CountriesAPIController.getCountriesBySelectorAndValue';
import {ShowToastEvent} from "lightning/platformShowToastEvent";


export default class CountriesApiSearch extends LightningElement {

    @track countries;

    handleSearchClick(){
        let searchCriteria = this.template.querySelector('select').value;
        let searchKeyword = this.template.querySelector('input').value;

        if (searchCriteria==='' || searchKeyword === ''){
            const event = new ShowToastEvent({
                title: 'Incorrect Input',
                message: 'Please select criteria and enter keyword',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        } else {
            getCountriesBySelectorAndValue({
                searchKeyword: searchKeyword,
                searchCriteria: searchCriteria
            })
                .then(result => {
                    this.countries = result;
                })
                .catch(error => {
                    console.log(error)
                    this.countries = [];
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: 'Something went wrong on request',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                });

        }
    }
}