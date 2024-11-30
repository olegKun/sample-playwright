// import {FullConfig} from "@playwright/test";
//
//  export default async function globalSetup(config: FullConfig) {
//     console.log("creating new database...");
// }

import { test as setup } from '@playwright/test';

setup('create new database', async ({ }) => {
    console.log('creating new database...');
    // Initialize the database
});

