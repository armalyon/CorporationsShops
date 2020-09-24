
public with sharing class ContactsFutureUnsyncer {
    public final static Integer ACCOUNTS_TO_SELECT_LIMIT = 150;

    /**
        a.	Select 150 Accounts from database.
        b.	For accounts in which BillingAddress is not empty select all related Contacts
        c.	Set to all Contacts Is Synced = false; Processed By Future = true
    */
    @future
    public static void unsyncAndProcessContactsRelatedToAccountWithBillingAddress() {
        List<Account> accounts = getAccounts();
        filterAccountsByNotEmptyBillingAddress(accounts);
        setUnsyncAndProcessedRelatedContacts(accounts);
    }

    private static List<Account> getAccounts() {
        List<Account> accounts = [SELECT Id, BillingAddress FROM Account LIMIT :ACCOUNTS_TO_SELECT_LIMIT];
        return accounts;
    }

    private static void filterAccountsByNotEmptyBillingAddress(List<Account> accounts) {
        for (Integer i = 0; i < accounts.size(); i++) {
            Account account = accounts.get(i);
            if (account.BillingAddress == null) {
                accounts.remove(i);
            }
        }
    }

    private static void setUnsyncAndProcessedRelatedContacts(List<Account> accounts) {
        List<Contact> contacts = [SELECT Id, Is_Synced__c, Processed_By_Future__c FROM Contact WHERE AccountId IN :accounts];
        for (Contact contact : contacts) {
            contact.Processed_By_Future__c = true;
            contact.Is_Synced__c = false;
        }
        update contacts;
    }

}