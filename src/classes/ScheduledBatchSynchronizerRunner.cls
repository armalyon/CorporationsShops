
public with sharing class ScheduledBatchSynchronizerRunner {

    private final static String CRON_EXPRESSION_1 = '0 30 * * * ?';
    private final static String CRON_EXPRESSION_2 = '0 0 * * * ?';

    public static void runScheduledJobs(Schedulable schedulable) {
        System.schedule('Contacts to accounts synchronizing every 30th minute', CRON_EXPRESSION_1, schedulable);
        System.schedule('Contacts to accounts synchronizing every new hour', CRON_EXPRESSION_2, schedulable);
    }
}