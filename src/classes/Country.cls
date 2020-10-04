
global with sharing class Country {
    @AuraEnabled
    public List<Currencies> currencies;
    @AuraEnabled
    public String name { get; set; }
    @AuraEnabled
    public String capital { get; set; }
    @AuraEnabled
    public String subregion { get; set; }
    @AuraEnabled
    public Integer population { get; set; }
    @AuraEnabled
    public String flag { get; set; }

    public class Currencies {
        @AuraEnabled
        public String code { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String symbol { get; set; }
    }
}