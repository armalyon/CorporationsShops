
public with sharing class CountriesAPIController {

    @AuraEnabled
    public static List<Country> getCountriesBySelectorAndValue(String searchSelector, String searchValue){
        return CountriesAPICallout.getCountriesListCallout(searchSelector, searchValue);
    }

}