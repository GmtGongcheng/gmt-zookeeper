apiVersion: v1
kind: Service
metadata:
  namespace: default 
  labels:
    component: zoo 
  name: zoo
spec:
  clusterIP: None 
  selector:
    component: zoo
  ports:
    - port: 2181
      targetPort: 2181
      name: cli
    - port: 2888
      targetPort: 2888
      name: peer
    - port: 3888
      targetPort: 3888
      name: leader-elect
