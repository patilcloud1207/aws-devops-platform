

        stage('Test Website') {
            steps {
                sh '''
                    set -eu

                    CONTAINER_NAME="aws-devops-test-${BUILD_NUMBER}"
                    trap 'docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true' EXIT

                    docker run -d --name "$CONTAINER_NAME" \
                        -p 127.0.0.1::80 \
                        aws-devops-platform:${BUILD_NUMBER}

                    echo "Checking website inside the container..."

                    ATTEMPT=0
                    until docker exec "$CONTAINER_NAME" \
                        wget -q --spider http://127.0.0.1/; do
                        ATTEMPT=$((ATTEMPT + 1))
                        if [ "$ATTEMPT" -ge 15 ]; then
                            echo "FAIL: Website did not start"
                            exit 1
                        fi
                        sleep 2
                    done

                    echo "PASS: Website responds inside the container"

                    CONTAINER_IP=$(docker inspect \
                        -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
                        "$CONTAINER_NAME")

                    echo "Testing HTTP access from Jenkins..."

                    ATTEMPT=0
                    until curl -fsS \
                        "http://${CONTAINER_IP}:80/" \
                        -o /dev/null; do
                        ATTEMPT=$((ATTEMPT + 1))
                        if [ "$ATTEMPT" -ge 15 ]; then
                            echo "FAIL: Jenkins could not reach the website"
                            exit 1
                        fi
                        sleep 2
                    done

                    echo "PASS: HTTP test succeeded from Jenkins"
                    docker port "$CONTAINER_NAME" 80/tcp
                '''
            }
        }

