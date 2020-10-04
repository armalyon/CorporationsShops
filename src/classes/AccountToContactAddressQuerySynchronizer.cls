
public with sharing class AccountToContactAddressQuerySynchronizer implements Database.Batchable<SObject>, Database.Stateful {
    /**
     a.	Batch should copy from Account.BillingAddress to Contact.MailingAddress
     b.	Set Contact.IsSynced__c = true;
     c.	Update Account field Updated By Contact = true;
     d.	Use Query Locator
     **/
    private final static String QUERY = 'SELECT ' +
            'MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Is_Synced__c, AccountId ' +
            'FROM Contact ' +
            'WHERE Is_Synced__c = FALSE AND AccountId!= NULL';
    public Integer totalRecordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(QUERY);
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Id> accIds = new List<Id>();
        for (Contact c: scope){
            accIds.add(c.AccountId);
        }
        Map<Id, Account> accs =
                new Map<Id, Account>([
                        SELECT BillingCity, BillingState, BillingStreet, BillingCountry, BillingPostalCode
                        FROM Account
                        WHERE Id IN :accIds]);
        for (Contact contact : scope) {
            Account account = accs.get(contact.AccountId);
            account.Updated_By_Contact__c = true;
            contact.MailingCity = account.BillingCity;
            contact.MailingCountry = account.BillingCountry;
            contact.MailingPostalCode = account.BillingPostalCode;
            contact.MailingState = account.BillingState;
            contact.MailingStreet = account.BillingStreet;
            contact.Is_Synced__c = true;
            totalRecordsProcessed++;
        }
        update scope;
    }


    public void finish(Database.BatchableContext bc) {
        System.debug('>>>>>>>JOB ID: ' + bc.getJobId());
        System.debug('>>>>>Total Contact records synchronized with accounts: ' + totalRecordsProcessed);
    }
}