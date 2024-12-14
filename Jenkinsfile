pipeline {
//    agent {
//       docker {
//          image 'mcr.microsoft.com/playwright:v1.47.2-noble'
//          args '--network my_network'
//       }
//    }

   stages {
      stage('e2e-tests') {
         steps {
            sh 'npm ci'
            // Ensure the HTML report is generated with --reporter=html
            sh 'npx playwright test --reporter=html'
         }
      }

      stage('Publish HTML Report') {
         steps {
            publishHTML(target: [
               allowMissing: false,
               alwaysLinkToLastBuild: true,
               keepAll: true,
               // Ensure this path matches where the HTML report is generated
               reportDir: 'playwright-report',  // Default folder for Playwright reports
               reportFiles: 'index.html',
               reportName: 'Playwright Test Report'
            ])
         }
      }
   }
}