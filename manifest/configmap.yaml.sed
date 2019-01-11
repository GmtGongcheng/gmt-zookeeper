apiVersion: v1
kind: ConfigMap
metadata:
  name: {{.env.cm}} 
  namespace: {{.namespace}} 
data:
  N_ZOOKEEPER: "3"
