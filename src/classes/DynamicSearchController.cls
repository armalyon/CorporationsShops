
public with sharing class DynamicSearchController {

    private static final String ACCOUNT = 'Account';
    private static final String CONTACT = 'Contact';
    private static final String LEAD = 'Lead';
    private static final String OPPORTUNITY = 'Opportunity';


    @AuraEnabled(Cacheable=true)
    public static List<SObject> getSobjectsByNameAndSobjectType(String sobjectType, String sobjectName) {
        if (sobjectType == ACCOUNT) {
            return DynamicSearchService.getAccountsByPartOfName(sobjectName);
        }
        if (sobjectType == CONTACT) {
            return DynamicSearchService.getContactsByPartOfName(sobjectName);
        }
        if (sobjectType == LEAD) {
            return DynamicSearchService.getLeadsByPartOfName(sobjectName);
        }
        if (sobjectType == OPPORTUNITY) {
            return DynamicSearchService.getOpportunitiesByPartOfName(sobjectName);
        }
        throw new AuraHandledException('Object type does not match with existing');
    }

}