pipeline {
  agent any
  stages {
    stage('TF Init') {
      steps {
        sh 'terraform init'
      }
    }
    stage('TF Plan') {
      steps {
        sh 'terraform plan -out myplan'
      }
    }
    stage('TF Apply') {
      steps {
        sh 'terraform apply -input=false myplan'
      }
    }
  }
  environment {
    aws_access_key_id = 'AKIAJT7AQD6XFQH2IIYQ'
    aws_secret_access_key = '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'
  }
}