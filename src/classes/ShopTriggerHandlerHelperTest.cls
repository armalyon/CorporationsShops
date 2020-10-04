
@IsTest
private class ShopTriggerHandlerHelperTest {

    @TestSetup
    private static void init() {
        Contact director = new Contact();
        director.LastName = 'Test name';
        director.Email = 'bot_bot@i.ua';
        insert director;

        Corporation__c corporation = new Corporation__c();
        corporation.Name = 'Corporation';
        insert corporation;

        Shop__c shop = new Shop__c();
        shop.Name = 'Shop';
        shop.Director__c = director.Id;
        shop.Corporation__c = corporation.Id;
        insert shop;
    }

    @IsTest
    static void addDefaultLogoUrlIfEmptyTest() {
        final String DEFAULT_LOGO_URL = 'https://miro.medium.com/max/2800/0*fcNjCdBDJ3fy9Kqt';
        final String LOGO_URL = 'https://miro.medium.com/max/2800/0*fcNjCdBDJ3fy9Kqt';

        Shop__c shop1 = new Shop__c(Name = 'Name 1');
        Shop__c shop2 = new Shop__c(Name = 'Name 1');
        Shop__c shop3 = new Shop__c(Name = 'Name 1', logo_url__c = LOGO_URL);
        List<Shop__c> shops = new List<Shop__c>();
        shops.add(shop1);
        shops.add(shop2);
        shops.add(shop3);
        ShopTriggerHandlerHelper.addDefaultLogoUrlIfEmpty(shops);
        System.assertEquals(DEFAULT_LOGO_URL, shop1.logo_url__c);
        System.assertEquals(DEFAULT_LOGO_URL, shop2.logo_url__c);
        System.assertEquals(LOGO_URL, shop3.logo_url__c);
    }

    @IsTest
    static void sendEmailToShopDirectorTest() {
        List<Shop__c> shops = [SELECT Id, Director__c, Name, Corporation__c FROM Shop__c];

        Test.startTest();
        ShopTriggerHandlerHelper.sendEmailToShopDirector(shops);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, invocations, 'An email should be sent');
    }

    @IsTest
    static void sendEmailToNewDirectorTest() {
        List<Shop__c> shops = [SELECT Id, Director__c, Name, Corporation__c FROM Shop__c];
        Contact director2 = new Contact();
        director2.LastName = 'Test name 2';
        director2.Email = 'b@i.ua';
        insert director2;

        Shop__c newShop = new Shop__c();
        newShop.Name = shops.get(0).Name;
        newShop.Corporation__c = shops.get(0).Corporation__c;
        newShop.Director__c = director2.Id;
        newShop.Id = shops.get(0).Id;

        Map<Id, Shop__c> oldMap = new Map<Id, Shop__c>();
        oldMap.put(shops.get(0).Id, shops.get(0));

        Map<Id, Shop__c> newMap = new Map<Id, Shop__c>();
        newMap.put(newShop.Id,  newShop);

        Test.startTest();
        ShopTriggerHandlerHelper.sendEmailToNewDirector(newMap, oldMap);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations, 'An email should be sent');

    }

    @IsTest
    static void checkIfShopIsGrowingShouldSetIsGrowingTrueIfMonthlyRevenueIsGrowing(){
        final Id ID = 'a023V000002653NQAQ';
        final String name = 'Name';

        Shop__c newShop = new Shop__c();
        newShop.Id = ID;
        newShop.Name = name;
        newShop.Is_Growing__c = false;
        newShop.Monthly_Revenue__c = 2;

        Shop__c oldShop = new Shop__c();
        oldShop.Id = ID;
        oldShop.Name = name;
        oldShop.Is_Growing__c = false;
        oldShop.Monthly_Revenue__c = 1;

        Map<Id, Shop__c> oldShops = new Map<Id, Shop__c>();
        oldShops.put(oldShop.Id, oldShop);

        Map<Id, Shop__c> newShops = new Map<Id, Shop__c>();
        newShops.put(newShop.Id, newShop);

        Test.startTest();
        ShopTriggerHandlerHelper.checkIfShopIsGrowing(oldShops, newShops);
        Test.stopTest();

        System.assert(newShops.get(newShop.Id).Is_Growing__c);
    }

    @IsTest
    static void checkIfShopIsGrowingShouldSetIsGrowingFalseIfMonthlyRevenueIsNotGrowing() {
        final Id ID = 'a023V000002653NQAQ';
        final String name = 'Name';

        Shop__c newShop = new Shop__c();
        newShop.Id = ID;
        newShop.Name = name;
        newShop.Is_Growing__c = true;
        newShop.Monthly_Revenue__c = 2;

        Shop__c oldShop = new Shop__c();
        oldShop.Id = ID;
        oldShop.Name = name;
        oldShop.Is_Growing__c = true;
        oldShop.Monthly_Revenue__c = 2;

        Map<Id, Shop__c> oldShops = new Map<Id, Shop__c>();
        oldShops.put(oldShop.Id, oldShop);

        Map<Id, Shop__c> newShops = new Map<Id, Shop__c>();
        newShops.put(newShop.Id, newShop);

        Test.startTest();
        ShopTriggerHandlerHelper.checkIfShopIsGrowing(oldShops, newShops);
        Test.stopTest();

        System.assert(!newShops.get(newShop.Id).Is_Growing__c);
    }
}