
@IsTest
private class AccountRestResourceTest {
    private static final String REQUEST_URL = 'https://eu27.force.com/services/apexrest/accounts/';

    @TestSetup
    private static void init() {
        Account acc = new Account();
        acc.Name = 'Test Rest Account';
        acc.Rating = 'Warn';
        acc.Type = '123412';
        acc.Industry = 'Other';
        insert acc;
    }

    @IsTest
    static void getByIdShouldReturnAccount() {
        Account expected = [
                SELECT Id, Name, Industry, Type
                FROM Account
        ].get(0);
        RestRequest request = new RestRequest();
        request.requestURI = REQUEST_URL + expected.Id;
        RestContext.request = request;

        Test.startTest();
        Account actual = AccountRestResource.getById();
        Test.stopTest();

        System.assert(actual != null);
        System.assertEquals(expected.Name, actual.Name);
        System.assertEquals(expected.Type, actual.Type);
        System.assertEquals(expected.Industry, actual.Industry);
    }

    @IsTest
    static void createAccountShouldInsertSobjectAndReturnCorrectId() {
        Account accToCreate = new Account();
        accToCreate.Name = 'Post Acc Name';
        accToCreate.Rating = 'Warn';
        accToCreate.Industry = 'Other';

        Test.startTest();
        Id actualId = AccountRestResource.createNewAccount(accToCreate);
        Test.stopTest();
        Account actual = [SELECT Name, Rating, Industry FROM Account WHERE Id = :actualId];
        System.assert(actual != null);
        System.assertEquals(actual.Name, accToCreate.Name);
        System.assertEquals(actual.Rating, accToCreate.Rating);
        System.assertEquals(actual.Industry, accToCreate.Industry);
    }

    @IsTest
    static void deleteAccountByIdShouldDeleteAccount() {
        Id idToDelete = [
                SELECT Id, Name, Industry, Type
                FROM Account
        ].get(0).Id;

        RestRequest request = new RestRequest();
        request.requestURI = REQUEST_URL + idToDelete;
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        Test.startTest();
        AccountRestResource.deleteAccountById();
        Test.stopTest();

        List<Account> result = [SELECT Id FROM Account WHERE Id = :idToDelete];
        System.assert(result.size() == 0);
    }

    @IsTest
    static void updateAccountByIdShouldReturnUpdatedAccount() {
        Id idToUpdate = [
                SELECT Id, Name, Industry, Type
                FROM Account
        ].get(0).Id;
        RestRequest request = new RestRequest();
        request.requestURI = REQUEST_URL + idToUpdate;
        request.httpMethod = 'PUT';
        RestContext.request = request;

        String newName = 'hello world';
        String newRating = 'Hot';
        String newPhone = '3789456';
        String newSite = 'youtube.com';
        String newIndustry = 'Electronics';

        Test.startTest();
        Account actual = AccountRestResource.updateAccountById(
                newName, newRating, newPhone, newSite, newIndustry, '', '', '', '', '');
        Test.stopTest();

        System.assert(actual != null);
        System.assertEquals(actual.Name, newName);
        System.assertEquals(actual.Rating, newRating);
        System.assertEquals(actual.Phone, newPhone);
        System.assertEquals(actual.Site, newSite);
        System.assertEquals(actual.Industry, newIndustry);
    }


}