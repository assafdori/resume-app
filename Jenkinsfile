pipeline {
    agent any

    triggers {
        pollSCM 'H/5 * * * *'
    }
    
    environment {
        DOCKER_IMAGE = 'asixl/cli-resume:latest'
        REGISTRY_CREDENTIALS = 'docker-creds'
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/r/asixl/cli-resume'
    }

    stages {
        stage('Checkout Git Repository') {
            steps {
                // Checkout application repository
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                // Placeholder test stage. More advanced testing should be implemented.
                script {
                    sh "docker run --rm ${DOCKER_IMAGE} /bin/sh -c echo 'Docker image test successful!'"
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                // Push the Docker image to a registry
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy Image to EC2') {
            steps {
                script {
                    // Retrieve the public IP address of the running EC2 instance
                def instanceIp = sh(script: 'aws ec2 describe-instances --filters Name=resume-app-server,Values=running Name=tag:Name,Values=your-instance-tag --query Reservations[*].Instances[*].PublicIpAddress --output text', returnStdout: true).trim()
                    // SSH into the EC2 instance and deploy the Docker image
                sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'docker run -d -p 80:80 asixl/cli-resume:latest'"
                }
            }       
        }
    }

    post {
        always {
            // Clean up Docker resources
            cleanWs()
            sh "docker rmi ${DOCKER_IMAGE}"
        }
    }
}
