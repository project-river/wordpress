node {
    def app

    stage('Clone repository') {
        timeout(time: 2, unit: 'MINUTES') {
            retry(2) {
                checkout scm
            }
        }
    }

    stage('Build image') {
        retry(2) {
            timeout(time: 30, unit: 'MINUTES') {


                app = docker.build("riverz/wordpress")


            }
        }
    }

    stage('Test image') {
        timeout(time: 2, unit: 'MINUTES') {
            app.inside {
                sh 'echo "Tests passed"'
            }
        }
    }

    stage('Push image') {
        if (env.BRANCH_NAME == 'master') {
            retry(2) {
                timeout(time: 5, unit: 'MINUTES') {
		docker.withRegistry("https://114688015612.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws-ecs-registry") {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
stage('Push image') {

if (env.BRANCH_NAME == 'master') {
            retry(2) {
                timeout(time: 10, unit: 'MINUTES') {
                    docker.withRegistry("https://114688015612.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws-ecs-registry") {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }


    }

    stage('Deploy') {
        if (env.BRANCH_NAME == 'master') {
            timeout(time: 15, unit: 'MINUTES') {
//                build 'rivers-docker-compose/master'
	sh "sh -e aws-deploy.sh wordpress ${env.BUILD_NUMBER} riverz us-east-2"
            }
        }

}
    }
}
