
public with sharing class ContactsQueueableUnsyncer implements Queueable {
    /**
     a.	For accounts in which BillingAddress is not empty select all related Contacts
     b.	Set to all Contacts Is Synced = false; Processed By Queue = true;
     * */


    public void execute(QueueableContext param1) {
        List<Account> accounts = getAccountsWithBillingAddress();
        if (accounts.size() > 0) {
            unsyncContacts(getRelatedContacts(accounts));
        }
    }

    private List<Account> getAccountsWithBillingAddress() {
        List<Account> accounts = [
                SELECT Id
                FROM Account
                WHERE BillingPostalCode != NULL AND BillingCountry != NULL AND BillingState != NULL AND BillingCity != NULL AND BillingStreet != NULL
        ];
        return accounts;
    }

    private List<Contact> getRelatedContacts(List<Account> accounts) {
        return [
                SELECT Id, Is_Synced__c, Processed_By_Queue__c
                FROM Contact
                WHERE AccountId IN :accounts
        ];
    }

    private void unsyncContacts(List<Contact> contacts) {
        for (Contact contact : contacts) {
            contact.Is_Synced__c = false;
            contact.Processed_By_Queue__c = true;
        }
        update contacts;
    }

}