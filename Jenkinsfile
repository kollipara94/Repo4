pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
    environment{
        BUILD_SERVER='ec2-user@172.31.44.24'
        IMAGE_NAME='dattasai94/java-mvn-privaterepos'
    }
    stages {
        stage('Compile') {
        // agent {label "linux_slave"}
        agent any
            steps {
                script{
                    echo "COMPILING"
                    sh "mvn compile"

                } 
            } 
        }
        stage('test') {
            agent any
            steps {
                script{

                    echo "RUNNING THE TC"
                    sh "mvn test"
                } 
                }
             
        
        post{
            always{
                junit 'target/surefire-reports/*.xml'
            }
        }
        }
        stage('containerasize docker-hub') {
            agent any
            steps {
                script{
                    sshagent(['aws-key']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                    sh "ssh ${BUILD_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                    

                }
                }
                }  
        }
    }
}
}

