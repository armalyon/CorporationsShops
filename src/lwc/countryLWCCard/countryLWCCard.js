
import {LightningElement, api} from 'lwc';

export default class CountryLwcCard extends LightningElement {
    @api name;
    @api capital;
    @api subregion;
    @api population;
    @api flag;
    @api currencies;

}