
@IsTest
private class AccountToContactAddressQuerySyncTest {

    @IsTest
    static void test() {
        Integer accRecordsNumber = 200;

        AccountTestDataFactory.insertAccountsWithOneContactAndBillingAddresses(accRecordsNumber, false, false);

        Test.startTest();
        AccountToContactAddressQuerySynchronizer obj = new AccountToContactAddressQuerySynchronizer();
        Id batchId = Database.executeBatch(obj);
        Test.stopTest();

        List<Contact> contacts = [SELECT Id, Is_Synced__c FROM Contact WHERE Is_Synced__c = TRUE];
        System.assertEquals(accRecordsNumber, contacts.size());


    }
}