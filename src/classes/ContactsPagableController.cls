
public with sharing class ContactsPagableController {

    @AuraEnabled(Cacheable = true)
    public static List<Contact> getPaginatedContacts(Integer pageNumber, Integer pageSize){
        return [SELECT Id, Name FROM Contact LIMIT :pageSize OFFSET :pageNumber];
    }

    @AuraEnabled(Cacheable = true )
    public static Integer getContactsCount() {
        return [SELECT COUNT() FROM Contact];
    }

}