// seedjob.groovy
pipelineJob('as3buffer') {
    definition {
        cps {
            sandbox(true)
            script("""

// this is an example declarative pipeline that says hello and goodbye
pipeline {
    agent any
    options { 
        disableConcurrentBuilds() 
        retry(3)
    }
    parameters {
        string(name: 'MGMT_URI', defaultValue: 'https://52.5.9.127/mgmt/shared/appsvcs/declare', description: 'Provide the URL where BIG-IP management endpoint can be accessed.')
        text(name: 'AS3_JSON', defaultValue: '', description: 'The AS3 declaration to post to the BIG-IP')
    }    
    stages {
        stage("Echo Request") {
            steps {
                echo "AS3 Declaration: " + params.AS3_JSON
            }
        }
        stage("Post the Declaration"){
            steps {
                script {
                    def response = httpRequest url: params.MGMT_URI, 
                                            httpMode: 'POST',
                                            authentication: 'bigip-creds',
                                            validResponseCodes: '200:302',
                                            ignoreSslErrors: true,
                                            consoleLogResponseBody: true,
                                            requestBody: params.AS3_JSON
                    println('Status: '+response.status)
                    println("Content: "+response.content)
                }
            }
        }
    }
}""")
        }
    }
}