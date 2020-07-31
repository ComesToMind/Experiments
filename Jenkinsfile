#!groovy
pipeline{
    agent any
    stages{
        stage("create docker image") {
            steps {
                echo "================= start building image ================="
                sh 'docker build . -t task4:1'
            }
        }
        stage("copying simplephp files from docker image") {
            steps {
                echo "================= start container ================="
                sh 'docker create -it --name tempor task4:1 bash'
                sh 'docker cp tempor:/var/www/html $(pwd)'
                sh 'docker rm -f tempor'
                sh 'ls -lah ./temp' 

            }
        }
        }
    }
