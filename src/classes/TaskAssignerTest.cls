
@IsTest
private class TaskAssignerTest {
    private static TaskAssigner.AccountUpdateInput newInput;
    private static TaskAssigner.AccountUpdateInput updateInput;

    @IsTest
    static void proceedActionOnAccountCreatedOrUpdatedShouldCreateNewTaskIfAccountIsNew() {
        newInput = new TaskAssigner.AccountUpdateInput();
        newInput.isNew = true;
        newInput.account = new Account(Name = 'New Account Name', Rating = 'Warn');
        insert newInput.account;
        List<TaskAssigner.AccountUpdateInput> inputs = new List<TaskAssigner.AccountUpdateInput>();
        inputs.add(newInput);

        Test.startTest();
        TaskAssigner.proceedActionOnAccountCreatedOrUpdated(inputs);
        Test.stopTest();

        Task resultingTask = [SELECT Subject FROM Task WHERE WhatId = :newInput.account.Id].get(0);
        String expectedSubject = 'Negotiations with ' + newInput.account.Name;
        System.assertEquals(expectedSubject, resultingTask.Subject);
    }

    @IsTest
    static void proceedActionOnAccountCreatedOrUpdatedShouldAssignTasksToRandomUserIfTasksMoreThanThree() {
        updateInput = new TaskAssigner.AccountUpdateInput();
        updateInput.account = new Account(Name = 'Updated Account', Rating = 'Warn');
        updateInput.isNew = false;
        insert updateInput.account;
        Account updatedAcc = updateInput.account;
        List<TaskAssigner.AccountUpdateInput> inputs = new List<TaskAssigner.AccountUpdateInput>();
        inputs.add(updateInput);

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User user = new User(
                LastName = 'TestUser', IsActive = true, Username = 'User@u.a', Email = '1@q.ua', Alias = 'Hello',
                TimeZoneSidKey = 'Asia/Seoul', LocaleSidKey = 'af_ZA',
                EmailEncodingKey = 'UTF-8', ProfileId = profile.Id,
                LanguageLocaleKey = 'en_US');
        insert user;

        List<Task> tasks = new List<Task>();
        Task task1 = new Task(Subject = 'Task 1 subject', WhatId = updatedAcc.Id);
        Task task2 = new Task(Subject = 'Task 2 subject', WhatId = updatedAcc.Id);
        Task task3 = new Task(Subject = 'Task 3 subject', WhatId = updatedAcc.Id);
        tasks.add(task1);
        tasks.add(task2);
        tasks.add(task3);
        insert tasks;

        Test.startTest();
        TaskAssigner.proceedActionOnAccountCreatedOrUpdated(inputs);
        Test.stopTest();

        List<Task> actualTasks = [SELECT Subject, OwnerId FROM Task];
        System.assert(actualTasks.size() == 4);
    }

}