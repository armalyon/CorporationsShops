
public with sharing class DynamicSearchService {

    public static List<Account> getAccountsByPartOfName(String keyword){
        keyword = keyword + '%';
        return [SELECT Id, Name, CreatedDate FROM Account WHERE Name LIKE :keyword];
    }

    public static List<Contact> getContactsByPartOfName(String keyword){
        keyword = keyword + '%';
        return [SELECT Id, Name, CreatedDate FROM Contact WHERE Name LIKE :keyword];
    }

    public static List<Lead> getLeadsByPartOfName(String keyword){
        keyword = keyword + '%';
        return [SELECT Id, Name, CreatedDate FROM Lead WHERE Name LIKE :keyword];
    }

    public static List<Opportunity> getOpportunitiesByPartOfName(String keyword){
        keyword = keyword + '%';
        return [SELECT Id, Name, CreatedDate FROM Opportunity WHERE Name LIKE :keyword];
    }

}