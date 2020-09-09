global with sharing class TaskAssigner {
    private static final Integer TASKS_NUMBER_FOR_ASSIGN = 3;
    private static final String NEGOTIATION_WITH = 'Negotiations with ';

    @InvocableMethod(label= 'Task assigning if account is created or updated')
    global static void proceedActionOnAccountCreatedOrUpdated(List<AccountUpdateInput> accountInputs) {
        List<Account> accountsToUpdate = new List<Account>();
        List<Task> tasksToUpdate = new List<Task>();
        List<Task> tasksToInsert = new List<Task>();

        for (AccountUpdateInput input : accountInputs) {
            if (input.isNew) {
                tasksToInsert.add(createTaskOnAccount(input.account));
            } else {
                Account account = input.account;
                tasksToUpdate.addAll(assignTasksIfAccountHasMoreThan3Tasks(account));
            }
            accountsToUpdate.add(input.account);
        }
        insert tasksToInsert;
        update tasksToUpdate;
        update accountsToUpdate;

    }

    private static Task createTaskOnAccount(Account acc) {
        Task newTask = new Task();
        newTask.WhatId = acc.Id;
        newTask.Subject = NEGOTIATION_WITH + acc.Name;
        return newTask;
    }

    private static List<Task> assignTasksIfAccountHasMoreThan3Tasks(Account acc) {
        Integer taskCount = [SELECT Count() FROM Task WHERE WhatId = :acc.Id];
        List<Task> tasks = new List<Task>();
        if (taskCount > TASKS_NUMBER_FOR_ASSIGN) {
            tasks.addAll(getAssignedToRandomUserTasks(acc));
        }
        return tasks;
    }

    private static List<Task> getAssignedToRandomUserTasks(Account account) {
        List<User> activeUsers = [SELECT Id FROM User WHERE IsActive = TRUE];
        Integer randomIndex = (Integer) (Math.random() * activeUsers.size());
        User userToAssign = activeUsers.get(randomIndex);

        List<Task> tasksForUser = [SELECT Id, OwnerId FROM Task WHERE WhatId = :account.Id];
        for (Task task : tasksForUser) {
                task.OwnerId = userToAssign.Id;
        }
        return tasksForUser;
    }

    global class AccountUpdateInput {
        @InvocableVariable(Required=true)
        public Account account;
        @InvocableVariable(Required=true)
        public Boolean isNew;
    }

}