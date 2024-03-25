pipeline {
    agent any

    triggers {
        pollSCM 'H/5 * * * *'
    }

    environment {
        DOCKER_IMAGE = 'asixl/cli-resume'
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/r/asixl/cli-resume'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    def versionTag = "${DOCKER_IMAGE}:${gitCommit}"
                    def latestTag = "${DOCKER_IMAGE}:latest"

                    sh "docker build -t ${versionTag} -t ${latestTag} ."
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh "docker run --rm ${DOCKER_IMAGE}:latest /bin/sh -c 'echo \"Docker image test successful!\"'"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY_URL}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                        sh "docker push ${DOCKER_IMAGE}:${gitCommit}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
            script {
                sh "docker rmi ${DOCKER_IMAGE}:latest"
                sh "docker rmi ${DOCKER_IMAGE}:${gitCommit}"
            }
        }
    }
}
