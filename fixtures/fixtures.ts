import { test as base } from '@playwright/test';

export const test = base.extend<{}, { forEachWorker: void }>({
    forEachWorker: [async ({}, use) => {
        // This code runs before all the tests in the worker process.
        console.log(`Starting test worker ${test.info().workerIndex}`);
        await use();
        // This code runs after all the tests in the worker process.
        console.log(`Stopping test worker ${test.info().workerIndex}`);
    }, { scope: 'worker', auto: true }],  // automatically starts for every worker.
});

