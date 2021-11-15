node {
    
    def commit_id
    def ECRURL  = 'https://accountid.dkr.ecr.eu-west-1.amazonaws.com/guestbook-go/'
    def ECRCRED = 'ecr:eu-west-1:ecr'
    def VERSION = '${BUILD_NUMBER}'
    def IMAGE   = 'guestbook-go'
    
    stage('Prepare') {
        git 'https://github.com/coheneria/guestbook-go-for-deploy.git'
    }

    stage ('K8S Deploy') {
        
        kubernetesDeploy(
            configs: 'redis-master.yaml',
            kubeconfigId: 'kuber',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'redis-master-service.yaml',
            kubeconfigId: 'kuber',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'redis-slave.yaml',
            kubeconfigId: 'kuber',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'redis-slave-service.yaml',
            kubeconfigId: 'kuber',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'guestbook-controller.yaml',
            kubeconfigId: 'kuber',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'guestbook-service.yaml',
            kubeconfigId: 'kuber',
            enableConfigSubstitution: true
        )
    }
}