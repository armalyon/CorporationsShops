
public with sharing class AccountToContactAddressIterSynchronizer implements Database.Batchable<SObject> {

    public Iterable<SObject> start(Database.BatchableContext bc) {
        return [
                SELECT MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Is_Synced__c, AccountId
                FROM Contact
                WHERE Is_Synced__c = FALSE AND AccountId != NULL
        ];
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        for (Contact contact : scope) {
            Account account = [SELECT BillingCity, BillingState, BillingStreet, BillingCountry, BillingPostalCode FROM Account WHERE Id = :contact.AccountId];
            contact.MailingCity = account.BillingCity;
            contact.MailingCountry = account.BillingCountry;
            contact.MailingPostalCode = account.BillingPostalCode;
            contact.MailingState = account.BillingState;
            contact.MailingStreet = account.BillingStreet;
            contact.Is_Synced__c = true;
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
    }
}