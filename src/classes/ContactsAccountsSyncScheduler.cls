
public with sharing class ContactsAccountsSyncScheduler implements Schedulable{

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new AccountToContactAddressQuerySynchronizer());
    }
}