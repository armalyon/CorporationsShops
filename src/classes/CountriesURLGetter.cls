public with sharing class CountriesURLGetter {
    private static final String METADATA_RECORD_NAME = 'V1';
    public static final String NAME_VALUE = 'Name';
    public static final String CURRENCY_VALUE = 'Currency';
    public static final String CAPITAL_VALUE = 'Capital';

    public static String getCountriesURL(String searchSelector, String searchValue) {
        Countries_API__mdt countriesAPI = [
                SELECT Capital_Endpoint__c, Name_Endpoint__c, Currency_Endpoint__c, Fields_Filter__c
                FROM Countries_API__mdt
                WHERE Label = :METADATA_RECORD_NAME
        ];

        if (searchSelector == NAME_VALUE) {
            return countriesAPI.Name_Endpoint__c + searchValue + countriesAPI.Fields_Filter__c;
        } else if (searchSelector == CURRENCY_VALUE) {
            return countriesAPI.Currency_Endpoint__c + searchValue + countriesAPI.Fields_Filter__c;
        } else if (searchSelector == CAPITAL_VALUE) {
            return countriesAPI.Capital_Endpoint__c + searchValue + countriesAPI.Fields_Filter__c;
        } else {
            throw new InvalidParameterValueException('searchSelector', searchSelector);
        }
    }

}