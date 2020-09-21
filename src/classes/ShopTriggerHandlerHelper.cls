
public with sharing class ShopTriggerHandlerHelper {
    private static final String DEFAULT_LOGO_URL = 'https://miro.medium.com/max/2800/0*fcNjCdBDJ3fy9Kqt';

    public static void addDefaultLogoUrlIfEmpty(List<Shop__c> shops) {
        for (Shop__c shop : shops) {
            if (shop.logo_url__c != '') {
                shop.logo_url__c = DEFAULT_LOGO_URL;
            }
        }
    }

    public static void sendEmailToShopDirector(List<Shop__c> shops) {
        List<Contact> directors = getDirectors(shops);
        sendEmailsToDirectors(directors);
    }

    public static void sendEmailToNewDirector(Map<Id, Shop__c> newShops, Map<Id, Shop__c> oldShops) {
        List<Shop__c> shopsWithNewDirectors = getShopsWithNewDirectors(newShops, oldShops);
        List<Contact> directors = getDirectors(shopsWithNewDirectors);
        sendEmailsToDirectors(directors);
    }

    public static void checkIfShopIsGrowing(Map<Id, Shop__c> oldShops, Map<Id, Shop__c> newShops) {
        for (Shop__c shop : newShops.values()) {
            if (oldShops.get(shop.Id).Monthly_Revenue__c < shop.Monthly_Revenue__c) {
                shop.Is_Growing__c = true;
            } else {
                shop.Is_Growing__c = false;
            }
        }
    }

    private static void sendEmailsToDirectors(List<Contact> directors) {
        for (Contact director : directors) {
            if (director.Email != null) {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String []{
                        director.Email
                };
                message.subject = 'You was assigned as Director of the shop in our system';
                message.plainTextBody = 'Dear Director' + director.Name + '! You were assigned as a Director of '
                        + getShopNamesString(director.Shops__r) + ' shop. Please check if data was added correctly.';
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{
                        message
                };
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                System.debug('>>>>>>>>>>>>> results of sending email to the new Director: ' + results);
            }
        }
    }

    private static List<Contact> getDirectors(List<Shop__c> shops) {
        List<Contact> directors = [
                SELECT Id, Email, Name, (
                        SELECT Name
                        FROM Shops__r
                        WHERE Id IN :shops
                )
                FROM Contact
                WHERE Id
                        IN (
                                SELECT Director__c
                                FROM Shop__c
                                WHERE Id IN :shops
                        )
        ];
        return directors;
    }

    private static String getShopNamesString(List<Shop__c> shops) {
        String result = '';
        for (Shop__c shop : shops) {
            result += shop.Name + ' ';
        }
        return result;
    }


    private static List<Shop__c> getShopsWithNewDirectors(Map<Id, Shop__c> newShops, Map<Id, Shop__c> oldShops) {
        List<Shop__c> shopsWithNewDirectors = new List<Shop__c>();
        for (Shop__c shop : newShops.values()) {
            if (shop.Director__c != oldShops.get(shop.Id).Director__c) {
                shopsWithNewDirectors.add(shop);
            }
        }
        return shopsWithNewDirectors;
    }

    public static void isShopsCanBeDeleted(List<Shop__c> shops) {
        for (Shop__c shop : shops) {
            if (shop.Is_Growing__c = true) {
                shop.addError('Shop marked "Is Growing" cannot be deleted from the system!');
            }
        }
    }

}