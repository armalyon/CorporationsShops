import {LightningElement, api, track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    {label: 'Show record', name: 'show_record'},
];

export default class SobjectsTable extends NavigationMixin(LightningElement) {

    @track columns = [
        {
            label: 'Name',
            fieldName: 'Name'
        },
        {
            label: 'Created Date',
            fieldName: 'CreatedDate'
        },
        {
            type: 'action',
            typeAttributes: {rowActions: actions}
        }
    ]

    @api objects;
    @api objectApiName;

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'show_record':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    showRowDetails(row) {
        const recordId = row.Id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: this.objectApiName,
                actionName: 'view'
            }
        });

    }

}