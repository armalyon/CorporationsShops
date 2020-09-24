
@IsTest
private class ContactsFutureUnsyncerTest {

    @IsTest
    static void unsyncAndProcessContactsRelatedToAccountWithBillingAddress() {
        AccountTestDataFactory.insertAccountsWithOneContactAndBillingAddresses(
                ContactsFutureUnsyncer.ACCOUNTS_TO_SELECT_LIMIT, true, false);

        Test.startTest();
        ContactsFutureUnsyncer.unsyncAndProcessContactsRelatedToAccountWithBillingAddress();
        Test.stopTest();

        List<Contact> contacts = [
                SELECT Id
                FROM Contact
                WHERE Is_Synced__c = FALSE AND Processed_By_Future__c = TRUE
        ];

        System.assert(contacts.size() == ContactsFutureUnsyncer.ACCOUNTS_TO_SELECT_LIMIT);
    }
}