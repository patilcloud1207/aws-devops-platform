

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
                        -p 127.0.0.1::80 \
                        aws-devops-platform:${BUILD_NUMBER}

                    PORT=$(docker port "$CONTAINER_NAME" 80/tcp | sed 's/.*://')

                    ATTEMPT=0
                    until docker exec "$CONTAINER_NAME" \
                        wget -q --spider http://127.0.0.1/; do
                        ATTEMPT=$((ATTEMPT + 1))
                        if [ "$ATTEMPT" -ge 15 ]; then
                            echo "FAIL: Website did not become healthy"
                            exit 1
                        fi
                        sleep 2
                    done

                    echo "PASS: Website responds inside the container"

                    ATTEMPT=0
                    until wget -q -O /dev/null "http://127.0.0.1:${PORT}/"; do
                        ATTEMPT=$((ATTEMPT + 1))
                        if [ "$ATTEMPT" -ge 15 ]; then
                            echo "FAIL: Website is not reachable through the published port"
                            exit 1
                        fi
                        sleep 2
                    done

                    echo "PASS: HTTP request through the published port succeeded"
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker image inspect aws-devops-platform:${BUILD_NUMBER} > /dev/null'
                echo 'PASS: Docker image verified'
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Build, website tests, and image verification passed!'
        }
        failure {
            echo 'FAILED: Check the console output for the error.'
        }
    }
}

