pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/playwright:v1.47.2-noble'
            args '--dns=8.8.8.8 --dns=8.8.4.4'
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
