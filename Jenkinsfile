pipeline {
    agent any // Use any available Jenkins agent
    stages {
        stage('e2e-tests') {
            steps {
                script {
                    // Get the workspace directory dynamically
                     def workspaceDir = pwd().replaceAll('C:', '/c').replaceAll('\\\\', '/')

                    // Run the Docker container with the specified image
                    docker.image('mcr.microsoft.com/playwright:v1.47.2-noble').inside("-w ${workspaceDir} -v ${workspaceDir}:${workspaceDir}") {
                        // Inside the Docker container, run your commands
                        sh 'npm ci'
                        sh 'npx playwright test'
                    }
                }
            }
        }
    }
}
