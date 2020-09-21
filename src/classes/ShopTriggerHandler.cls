
public with sharing class ShopTriggerHandler {
    public static void handleBeforeInsert(List<Shop__c> newShops) {
        ShopTriggerHandlerHelper.addDefaultLogoUrlIfEmpty(newShops);
    }

    public static void handleAfterInsert(List<Shop__c> newShops) {
        ShopTriggerHandlerHelper.sendEmailToShopDirector(newShops);
    }

    public static void handleBeforeUpdate(Map<Id, Shop__c> oldShopsRecords, Map<Id, Shop__c> updatedShopsRecords) {
        ShopTriggerHandlerHelper.checkIfShopIsGrowing(oldShopsRecords, updatedShopsRecords);
    }

    public static void handleAfterUpdate(Map<Id, Shop__c> newShops, Map<Id, Shop__c> oldShops) {
        ShopTriggerHandlerHelper.sendEmailToNewDirector(newShops, oldShops);
    }

    public static void handleBEforeDelete(List<Shop__c> shopsToDelete) {
        ShopTriggerHandlerHelper.isShopsCanBeDeleted(shopsToDelete);
    }

}