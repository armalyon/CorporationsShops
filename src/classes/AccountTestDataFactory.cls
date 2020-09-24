
public class AccountTestDataFactory {

    public static void insertAccountsWithOneContactAndBillingAddresses(Integer accNumber, Boolean isSynced, Boolean updatedByContact) {

        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < accNumber; i++) {
            Account account = new Account();
            account.Updated_By_Contact__c = updatedByContact;
            account.Name = 'Name' + i + 'Not Duplicate ' + (i*32);
            account.Rating = 'Warn';
            account.BillingCity = 'Kyiv';
            account.BillingStreet = '21312';
            account.BillingPostalCode = '4543';
            account.BillingCountry = 'Ukraine';
            accounts.add(account);
        }
        insert accounts;

        for (Account acc : accounts) {
            Contact contact = new Contact();
            contact.LastName = 'Contact ' + acc.Name;
            contact.Processed_By_Future__c = false;
            contact.AccountId = acc.Id;
            contact.Is_Synced__c = isSynced;
            contacts.add(contact);
        }
        insert contacts;

    }
}