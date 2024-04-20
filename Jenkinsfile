pipeline {
    agent any

    triggers {
        pollSCM 'H/5 * * * *'
    }
    
    environment {
        DOCKER_IMAGE = 'asixl/cli-resume:latest'
        REGISTRY_CREDENTIALS = 'docker-creds'
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/r/asixl/cli-resume'
        DOCKER_COMPOSE_FILE = 'https://raw.githubusercontent.com/assafdori/resume-app/main/docker-compose.yml'
        PROMETHEUS_CONFIG_FILE = 'https://raw.githubusercontent.com/assafdori/resume-app-iac/main/prometheus.yml'
        ALERTMANAGER_CONFIG_FILE = 'https://raw.githubusercontent.com/assafdori/resume-app-iac/main/alertmanager.yml'
        ALERT_RULES_FILE = 'https://raw.githubusercontent.com/assafdori/resume-app-iac/main/alert.rules.yml'

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

        stage('Deploy Infrastructure using Terraform & Update Porkbun Nameservers') {
            steps {
                parallel (
                    "Deploy Terraform": {
                        // Checkout IaC repository
                        sh "git clone https://www.github.com/assafdori/resume-app-iac.git"
                        
                        // Navigate to Terraform directory
                        dir('resume-app-iac') {
                            // Initialize Terraform
                            sh 'terraform init'

                            // Apply Terraform changes
                            sh 'terraform apply -auto-approve'
                        }
                    },
                    "Update Porkbun NS to AWS generated NS": {
                        // Sleep and wait for Terraform to propagate
                        sleep time: 180, unit: 'SECONDS'
                        
                        // Download the Python script that updates nameservers
                        sh 'curl -o update-ns.py https://raw.githubusercontent.com/assafdori/resume-app-iac/main/update-ns.py'
                        
                        // Run the Python script that updates nameservers
                        sh 'python3 update-ns.py'
                    }
                )
            }
        }

        stage('Install Node Exporter') {
            steps {
                script {
                    // Retrieve the public IP address of the running EC2 instance
                    def instanceIp = sh(script: 'aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=resume-app-server --query "Reservations[*].Instances[*].PublicIpAddress" --output text', returnStdout: true).trim()

                    // Use sshagent to handle SSH authentication
                    sshagent(['aws-instance-key']) {
                        // SSH into the EC2 instance and install Node Exporter
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-arm64.tar.gz'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'tar -xzf node_exporter-1.7.0.linux-arm64.tar.gz'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'sudo mv node_exporter-1.7.0.linux-arm64/node_exporter /usr/local/bin/'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'sudo useradd -r -s /sbin/nologin -M node_exporter'"


                        // Create the systemd unit file for Node Exporter
                        def unitFile = '''
        [Unit]
        Description=Prometheus Node Exporter
        Wants=network-online.target
        After=network-online.target

        [Service]
        User=node_exporter
        Group=node_exporter
        Type=simple
        ExecStart=/usr/local/bin/node_exporter

        [Install]
        WantedBy=multi-user.target
        '''
                        sh "echo '${unitFile}' | ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'sudo tee /etc/systemd/system/node_exporter.service > /dev/null'"

                        // Start and enable the Node Exporter service
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'sudo systemctl daemon-reload'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'sudo systemctl start node_exporter'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'sudo systemctl enable node_exporter'"
                    }
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
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'curl -o docker-compose.yml ${DOCKER_COMPOSE_FILE}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'curl -o prometheus.yml ${PROMETHEUS_CONFIG_FILE}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'curl -o alertmanager.yml ${ALERTMANAGER_CONFIG_FILE}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'curl -o alert.rules.yml ${ALERT_RULES_FILE}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} 'docker-compose up -d'"
                    }
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
        failure {
            // Destroy Terraform resources
            sh "terraform destroy -auto-approve"
        }
    }
}

