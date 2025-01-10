aws configure 



 aws eks update-kubeconfig --name xeni-argos-eks --region us-west-2 --alias argos
 hal config provider kubernetes enable

kubectl config use-context argos

CONTEXT=$(kubectl config current-context)

cd /home/spinnaker

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: spinnaker-role
rules:
  - apiGroups: ['*']
    resources: ['*']
    verbs: ['*']
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: spinnaker-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: spinnaker-role
subjects:
  - namespace: spinnaker
    kind: ServiceAccount
    name: spinnaker-service-account
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: spinnaker-service-account
  namespace: spinnaker


  kubectl apply --context $CONTEXT -f service-account.yaml

  kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: service-account-secret
  namespace: spinnaker
  annotations:
    kubernetes.io/service-account.name: spinnaker-service-account
type: kubernetes.io/service-account-token
EOF

kubectl describe secrets -n spinnaker

export TOKEN=

    kubectl config set-credentials ${CONTEXT}-token-user --token=$TOKEN

    kubectl config set-context $CONTEXT --user ${CONTEXT}-token-user

     hal config provider kubernetes account add argos --context $CONTEXT


hal config features edit --artifacts true

hal config deploy edit --type distributed --account-name argos


     export YOUR_ACCESS_KEY_ID=

        hal config storage s3 edit --access-key-id $YOUR_ACCESS_KEY_ID \
    --secret-access-key



       hal config storage edit --type s3


    hal version list

        export VERSION=1.35.4
    hal config version edit --version $VERSION


    sudo cp -r .kube /home/spinnaker/.kube
sudo chown -R spinnaker:spinnaker /home/spinnaker/.kube
sudo nano /home/spinnaker/.hal/config

    hal deploy apply