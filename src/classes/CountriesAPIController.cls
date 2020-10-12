
public with sharing class CountriesAPIController {

    @AuraEnabled(Cacheable = true)
    public static List<Country> getCountriesBySelectorAndValue(String searchCriteria, String searchKeyword){
        return CountriesAPICallout.getCountriesListCallout(searchCriteria, searchKeyword);
    }

}