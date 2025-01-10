helm charts:

jenkins      	https://charts.jenkins.io                         
ingress-nginx	https://kubernetes.github.io/ingress-nginx        
sonarqube    	https://SonarSource.github.io/helm-chart-sonarqube



jenkins dashboard warning : looks like reverse proxy isnt properly setup

solution: 
    add http://af07b508e311f438a929f37772bedf77-43479c9585789266.elb.us-west-2.amazonaws.com/jenkins/  in dashboard > manage jenkins > system > Jenkins Location > Jenkins URL




java -jar jenkins-cli.jar -s http://af07b508e311f438a929f37772bedf77-43479c9585789266.elb.us-west-2.amazonaws.com/jenkins/ help



credentials
    xeni-admin-github-credentials
    username with password
    xeni-admin/***


plugins:
    clean workspace
    Go
        also add it in tools