#!groovy
pipeline{
    agent any
    stages{
        stage("create docker image") {
            steps {
                echo "================= start building image ================="
                sh 'docker build . -t Task4:1 --no-cahe'
            }
        }
    }
}