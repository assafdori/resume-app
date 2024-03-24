pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'cli-resume:latest'
        REGISTRY_CREDENTIALS = 'docker-creds'
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/r/asixl'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your code from GitHub
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                script {
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }
        
        stage('Test') {
            steps {
                // Add your test steps here
            }
        }
        
        stage('Push Docker Image') {
            steps {
                // Push the Docker image to a registry
                script {
                    docker.withRegistry(DOCKER_REGISTRY_URL, REGISTRY_CREDENTIALS) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Clean up Docker resources after the build
            cleanWs()
            docker.image(DOCKER_IMAGE).remove()
        }
    }
}
