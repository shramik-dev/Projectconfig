pipeline{
    agent {label 'node1'}
    environment {
        PATH = "$PATH:/opt/maven/bin"
        DOCKER_TAG = getVersion()
    }
    stages{
        stage('SCM'){
            steps{
                //git url: 'https://github.com/javahometech/dockeransiblejenkins.git'
                //git branch: 'shramik-dev-patch-1', url: 'https://github.com/shramik-dev/dockeransiblejenkins.git'
                git branch: 'main', url: 'https://github.com/shramik-dev/Projectconfig.git'
            }
        }
        stage('Maven Build'){
            steps{
                sh "mvn clean package"
            }
        }
    stage('SonarQube analysis') {
    //  def scannerHome = tool 'SonarScanner 4.0';
        steps{
        withSonarQubeEnv('Sonarqube') { 
        // If you have configured more than one global server connection, you can specify its name
//      sh "${scannerHome}/bin/sonar-scanner"
        sh "mvn sonar:sonar"
    }
        }
        }
    stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
       stage('Docker Build'){
            steps{
                sh "sudo docker build . -t shramik999/webapp:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
            steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh " sudo docker login -u shramik999 -p ${dockerHubPwd}"
                }
                
                sh "sudo docker push shramik999/webapp:${DOCKER_TAG} "
            }
        }
        stage('Docker Deploy'){
            steps{
        ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
             
            }      
        }
    }
}
def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
