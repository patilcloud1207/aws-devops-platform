

pipeline {
    agent any

    stages {
        stage('Checkout Source') {
            steps {
                echo 'Checking out source code from GitHub'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t aws-devops-platform:${BUILD_NUMBER} .'
            }
        }

        stage('Test Website') {
            steps {
                sh '''
                    set -eu

                    CONTAINER_NAME="aws-devops-test-${BUILD_NUMBER}"
                    trap 'docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true' EXIT

                    docker run -d --name "$CONTAINER_NAME" \
                        aws-devops-platform:${BUILD_NUMBER}

                    ATTEMPT=0
                    until docker exec "$CONTAINER_NAME" \
                        wget -q --spider http://127.0.0.1/; do
                        ATTEMPT=$((ATTEMPT + 1))
                        if [ "$ATTEMPT" -ge 15 ]; then
                            echo "FAIL: Website test failed"
                            exit 1
                        fi
                        sleep 2
                    done

                    echo "PASS: Website test succeeded"
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker image inspect aws-devops-platform:${BUILD_NUMBER} > /dev/null'
                echo 'PASS: Docker image verified'
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                    set -eu

                    docker rm -f aws-devops-platform-app \
                        >/dev/null 2>&1 || true

                    docker run -d \
                        --name aws-devops-platform-app \
                        --restart unless-stopped \
                        -p 8082:80 \
                        aws-devops-platform:${BUILD_NUMBER}

                    ATTEMPT=0
                    until docker exec aws-devops-platform-app \
                        wget -q --spider http://127.0.0.1/; do
                        ATTEMPT=$((ATTEMPT + 1))
                        if [ "$ATTEMPT" -ge 15 ]; then
                            echo "FAIL: Deployment health check failed"
                            exit 1
                        fi
                        sleep 2
                    done

                    echo "PASS: Application deployed successfully"
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Build, tests, verification, and deployment passed!'
        }
        failure {
            echo 'FAILED: Check the Console Output.'
        }
    }
}
