pipeline {
   agent {
      docker {
         image 'mcr.microsoft.com/playwright:v1.47.2-noble'
         args '--network my_network'
      }
   }
   stages {
      stage('e2e-tests') {
         steps {
            sh 'npm ci'
            sh 'npx playwright test'
         }
      }
   }
}