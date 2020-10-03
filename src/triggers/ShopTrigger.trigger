trigger ShopTrigger on Shop__c (before insert, before update, before delete,
        after insert, after update, after delete) {
    if (Trigger.isInsert && Trigger.isBefore) {
        ShopTriggerHandler.handleBeforeInsert(Trigger.new);
    } else if (Trigger.isInsert && Trigger.isAfter) {
        ShopTriggerHandler.handleAfterInsert(Trigger.new);
    } else if (Trigger.isUpdate && Trigger.isBefore) {
        ShopTriggerHandler.handleBeforeUpdate(Trigger.oldMap,Trigger.newMap);
    } else if (Trigger.isUpdate && Trigger.isAfter) {
        ShopTriggerHandler.handleAfterUpdate(Trigger.oldMap,Trigger.newMap);
    } else if (Trigger.isDelete && Trigger.isBefore) {
        ShopTriggerHandler.handleBeforeDelete(Trigger.old);
    }

}