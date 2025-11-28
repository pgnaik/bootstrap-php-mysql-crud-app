pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pgnaik/php-mysql-crud-app.git'
            }
        }

        stage('PHP Syntax Check') {
            steps {
                bat 'php -l src/api.php'
                bat 'php -l src/db.php'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CRED',
                                                     usernameVariable: 'USER',
                                                     passwordVariable: 'PASS')]) {
                        // Login and push
                        bat '''
                          echo %PASS% | docker login -u %USER% --password-stdin
                          docker push %DOCKER_IMAGE%:%DOCKER_TAG%
                        '''
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // If your docker-compose.yml uses the same image:tag,
                    // you can just pull latest and recreate containers
                    bat "docker pull %DOCKER_IMAGE%:%DOCKER_TAG%"

                    // Stop old containers (ignore error if none)
                    bat 'docker compose down || exit 0'

                    // Start with new image (compose will use the pulled image)
                    bat 'docker compose up -d'
                }
            }
        }
    }

    post {
        success {
            echo "App deployed! Open: http://<jenkins-server-ip>:8080"
        }
        failure {
            echo "Build or deployment failed."
        }
    }
}
