apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: spin-ingress
  namespace: spinnaker
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /spinnaker(/.*)
        pathType: Prefix
        backend:
          service:
            name: spin-deck
            port:
              number: 9000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: spin-gate-ingress
  namespace: spinnaker
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: spin-gate
            port:
              number: 8084


hal config security api edit --override-base-url http://af07b508e311f438a929f37772bedf77-43479c9585789266.elb.us-west-2.amazonaws.com

hal config security ui edit --override-base-url http://af07b508e311f438a929f37772bedf77-43479c9585789266.elb.us-west-2.amazonaws.com

2 issues:
 http://af07b508e311f438a929f37772bedf77-43479c9585789266.elb.us-west-2.amazonaws.com/plugin-manifest.json  --- 404
 http://af07b508e311f438a929f37772bedf77-43479c9585789266.elb.us-west-2.amazonaws.com/spinnaker doesnt work               ->      wants /spinnaker/