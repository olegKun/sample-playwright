import {test as base} from '@playwright/test';
import {TodoPage} from "../pages/todo-page";

const test = base.extend<{todoPage: TodoPage},{workerFixture: string, automaticWorkerFixture: string}>({
    todoPage: async ({page}, use) => {
        const todoPage = new TodoPage(page);
        await todoPage.goto();
        await todoPage.addToDo('item1');
        await todoPage.addToDo('item2');
        await use(todoPage);
        await todoPage.removeAll();
    },
    workerFixture: [async ({browser}, use, workerInfo) => {
        console.log('I am the worker that runs before each spec file');
        await use('Message form the worker')
    },{scope:'worker'}],
    automaticWorkerFixture: [async ({browser}, use, workerInfo) => {
        console.log('I am automated worker')
        await use('Automatic worker message');
    },{scope:'worker', auto: true} ]
})


// test.beforeEach(async ({todoPage}) => {
//     await todoPage.goto();
//     await todoPage.addToDo('item1');
//     await todoPage.addToDo('item2');
// });
//
// test.afterEach(async ({todoPage}) => {
//     await todoPage.removeAll();
// });

test('should add an item', async ({todoPage, workerFixture}) => {
    await todoPage.addToDo('my item');
    // console.log(workerFixture)
    // ...
});

test('should remove an item', async ({todoPage}) => {
    await todoPage.remove('item1');
    // ...
});
