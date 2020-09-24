
@RestResource(UrlMapping='/accounts/*')
global with sharing class AccountRestResource {

    @HttpGet
    global static Account getById() {
        String accId = getIdFromRequest();
        return [
                SELECT Id, Name, OwnerId, BillingAddress, Type, Industry
                FROM Account
                WHERE Id = :accId
        ];
    }

    @HttpPost
    global static Id createNewAccount(Account account) {
        insert account;
        return account.Id;
    }

    @HttpDelete
    global static void deleteAccountById() {
        String accId = getIdFromRequest();
        Account accToDelete = [SELECT id FROM Account WHERE Id = :accId];
        delete accToDelete;
    }

    @HttpPut
    global static Account updateAccountById(String name, String rating, String phone, String site,
            String industry, String billingCountry, String billingState, String billingPostalCode,
            String billingCity, String billingStreet) {
        String accId = getIdFromRequest();
        Account accountToUpdate = new Account();
        accountToUpdate.Id = accId;
        accountToUpdate.Name = name;
        accountToUpdate.Rating = rating;
        accountToUpdate.Industry = industry;
        accountToUpdate.Phone = phone;
        accountToUpdate.Site = site;
        accountToUpdate.BillingCountry = billingCountry;
        accountToUpdate.BillingState = billingState;
        accountToUpdate.BillingCity = billingCity;
        accountToUpdate.BillingPostalCode = billingPostalCode;
        accountToUpdate.BillingStreet = billingStreet;
        update accountToUpdate;
        return accountToUpdate;
    }

    private static String getIdFromRequest() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI
                .substring(
                        request.requestURI.lastIndexOf('/') + 1
                );
        return accId;
    }


}