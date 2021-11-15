// This pipeline creates Docker image and push it to ECR.

pipeline {
    agent any
    environment {
        registry = "accountid.dkr.ecr.eu-west-1.amazonaws.com/redis"
    }
   
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/coheneria/redis']]])     
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh 'aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin accountid.dkr.ecr.eu-west-1.amazonaws.com'
                sh 'docker push accountid.dkr.ecr.eu-west-1.amazonaws.com/redis'
         }
        }
    }
}
}