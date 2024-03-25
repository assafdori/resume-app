// pipeline {
//     agent any
    
//     environment {
//         DOCKER_IMAGE = 'asixl/cli-resume:latest'
//         REGISTRY_CREDENTIALS = 'docker-creds'
//         DOCKER_REGISTRY_URL = 'https://hub.docker.com/r/asixl/cli-resume'
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 // Checkout your code from GitHub
//                 checkout scm
//             }
//         }
        
//         stage('Build Docker Image') {
//             steps {
//                 // Build the Docker image
//                 script {
//                     sh "docker build -t asixl/cli-resume:latest ."
//                     // docker.build(DOCKER_IMAGE, '.')
//                 }
//             }
//         }
        
//         stage('Test') {
//             steps {
//                 // Add your test steps here
//                 script {
//                     docker.image(DOCKER_IMAGE).run("--rm", "/bin/sh", "-c", "echo 'Docker image test successful!'")
//                 }
//             }
//         }
        
//         stage('Push Docker Image') {
//             steps {
//                 // Push the Docker image to a registry
//                 script {
//                     docker.withRegistry(DOCKER_REGISTRY_URL, REGISTRY_CREDENTIALS) {
//                         docker.image(DOCKER_IMAGE).push()
//                     }
//                 }
//             }
//         }
//     }
    
//     post {
//         always {
//             // Clean up Docker resources after the build
//             cleanWs()
//                     sh "docker rmi ${DOCKER_IMAGE}"
//         }
//     }
// }

pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo "Building.."
                sh "docker build -t asixl/cli-resume:latest ."
            }
        }
        
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    docker push asixl/cli-resume:latest
                    '''
                }
            }
        }
    }
}

