
public with sharing class CountriesAPICallout {

    public static List<Country> getCountriesListCallout(String searchSelector, String searchValue){
        String url = CountriesURLGetter.getCountriesURL(searchSelector, searchValue);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        String responseBody = response.getBody();
        return CountriesParser.parse(responseBody);
    }
}