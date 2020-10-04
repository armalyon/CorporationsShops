
public with sharing class ContactsRelatedToAccountController {

    @AuraEnabled
    public static List<Contact> getContactsByAccount(Id accId){
        return [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE AccountId = :accId];
    }

}