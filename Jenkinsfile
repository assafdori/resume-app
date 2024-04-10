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

        stage('Configure AWS Credentials') {
            steps {
                withCredentials([aws(credentialsId: 'AWS-CLI-KEY-JENKINS', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh "aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID"
                    sh "aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY"
                    sh "aws configure set region us-east-1"
                }
            }
        }

        stage('Deploy Infrastructure using Terraform') {
            steps {
                // Checkout IaC repository
                sh "git clone https://www.github.com/assafdori/resume-app-iac.git"
                
                // Navigate to Terraform directory
                dir('resume-app-iac') {
                    // Initialize Terraform
                    sh 'terraform init'
                    
                    // Apply Terraform changes
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Image to EC2') {
            steps {
                script {
                    // Retrieve the public IP address of the running EC2 instance
                    def instanceIp = sh(script: 'aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=resume-app-server --query "Reservations[*].Instances[*].PublicIpAddress" --output text', returnStdout: true).trim()

                    // Use sshagent to handle SSH authentication
                    sshagent(['aws-instance-key']) {
                        // SSH into the EC2 instance and deploy the Docker image
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'docker run -d -p 80:80 asixl/cli-resume:latest'"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker resources
            sh "docker rmi ${DOCKER_IMAGE}"
            sh "terraform destroy -auto-approve"
            cleanWs()
        }
        failure {
            // Destroy Terraform resources
            // sh "terraform destroy -auto-approve"
        }
    }
}
