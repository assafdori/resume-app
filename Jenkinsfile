pipeline {

    agent any
    
    environment {
        DOCKER_IMAGE = 'asixl/cli-resume:latest'
        REGISTRY_CREDENTIALS = 'docker-creds'
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/r/asixl/cli-resume'
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
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Test') {
            steps {
                // Add your test steps here
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
    }
    
    post {
        always {
            // Clean up Docker resources after the build
            cleanWs()
                    sh "docker rmi ${DOCKER_IMAGE}"
        }
    }
}



// pipeline {
//     agent any
    
//  triggers {
//     pollSCM 'H/5 * * * *'
// }

//     stages {
//         stage('Build') {
//             steps {
//                 echo "Building.."
//                 sh "docker build -t asixl/cli-resume:latest ."
//             }
//         }
        
//         stage('Deliver') {
//             steps {
//                 echo 'Deliver....'
//                 withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
//                     sh '''
//                     echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
//                     docker push asixl/cli-resume:latest
//                     '''
//                 }
//             }
//         }
//     }
// }