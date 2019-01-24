pipeline {
  agent any
  stages {
    stage('TF Init') {
      steps {
        sh 'terraform init'
      }
    }
  }
  environment {
    aws_access_key_id = 'AKIAJT7AQD6XFQH2IIYQ'
    aws_secret_access_key = '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'
  }
}