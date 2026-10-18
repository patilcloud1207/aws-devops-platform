
pipeline {
    agent any

    stages {
        stage('Checkout Source') {
            steps {
                echo 'Source code checked out from GitHub'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t aws-devops-platform:${BUILD_NUMBER} .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker image inspect aws-devops-platform:${BUILD_NUMBER}'
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Docker image built and verified!'
        }
        failure {
            echo 'FAILED: Check the Jenkins console output.'
        }
    }
}
