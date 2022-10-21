properties([
    parameters([
        [
            $class: 'ChoiceParameter',
            choiceType: 'PT_SINGLE_SELECT',
            description: '',
            filterLength: 1,
            filterable: true,
            name: 'choosenTag',
            script: [
                $class: 'GroovyScript',
                fallbackScript: [
                classpath: [
                    
                ],
                sandbox: false,
                script: 'return["There is no branch name!"]'
                ],
                script: [
                classpath: [
                    
                ],
                sandbox: true,
                script: '''def fetchTagsCmd = "bash /var/lib/jenkins/bash-scripts/fetch-tag.sh springservice"  
def fetchTagsCmdStdout = fetchTagsCmd.execute() 
def strBufferFetchTags = new StringBuffer() 
fetchTagsCmdStdout.consumeProcessErrorStream(strBufferFetchTags)  
def fetchedTags = fetchTagsCmdStdout.text.readLines()  
return fetchedTags.sort().reverse()'''
                ]
            ]
        ]
    ])
])

String tag = "${choosenTag}"
if(!choosenTag){
    tag = "master"
}

String registry = "alicanuzun/springservice"
String chartPath = "applications"
String currentContext = "production"
String serviceName = "springservice"
String environment = "production"

timestamps() {
        node {
            stage('Git checkout'){
                checkout scm: [
                        $class: 'GitSCM', 
                        userRemoteConfigs: [
                            [
                                credentialsId: 'GitHub-Spring-Credential',
                                url: 'git@github.com:alican-uzun/springservice.git'
                            ]
                        ], 
                        branches: [
                            [
                                name: "${tag}"
                            ]
                        ]
                    ],poll: false
            }
            stage("Login to DockerHub"){
                withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]){
                    sh('docker login --username $DOCKERHUB_USERNAME --password $DOCKERHUB_PASSWORD')
                }
            }
            stage("Docker Build"){
                sh "docker build -t ${registry}/${serviceName}:${tag} ."
            }
            stage("Push Image to the Docker Hub"){
                sh """
                    docker push ${registry}/${serviceName}:${tag}
                """
            }
            stage('Helm Charts Git checkout'){
                git branch: "master",
                    credentialsId: 'GitHub-Helm-Charts-Credential',
                    url: 'git@github.com:alican-uzun/helm-charts.git'
            }
            stage("Change AppVersion in Helm Chart"){
                sh  "bash /var/lib/jenkins/bash-scripts/change-app-version.sh ${serviceName} ${tag}"
            }
            stage("Deploy on K8S Cluster"){
                sh  "helm upgrade --install " +
                    "${serviceName} ${chartPath}/${serviceName} -f ${chartPath}/${serviceName}/${environment}/values.yaml " + 
                    "--set image.tag=${tag} " +
                    "--set image.repository=${registry}/${serviceName} " +
                    "--namespace=${environment} " +
                    "--kube-context=${currentContext}"
        }
    }
}