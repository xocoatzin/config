pipeline {
  agent any
  stages {
    stage('Setup') {
      steps {
        sh '''make testinstall'''
      }
    }
    stage('Verify Code Format') {
      steps {
        sh '''make lint'''
      }
    }
    stage('Report') {
      steps {
        junit(allowEmptyResults: true, testResults: 'flake8_junit.xml')
      }
    }
  }
}
