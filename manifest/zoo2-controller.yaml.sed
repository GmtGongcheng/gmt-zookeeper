apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  namespace: {{.namespace}} 
  name: zoo2
spec:
  serviceName: "zoo2"
  podManagementPolicy: Parallel
  replicas: 1
  template:
    metadata:
      labels:
        component: zoo
        app: zoo2
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: zoo2
          image: {{.image}}
          imagePullPolicy: {{.image.pull.policy}}
          command: ["/usr/local/bin/entrypoint.sh"]
          args:
            - zkServer.sh
            - start-foreground
          env:
            - name: ZOO_MY_ID 
              value: "2"
            - name: ZOO_SERVERS 
              value: "server.1=zoo1:2888:3888 server.2=0.0.0.0:2888:3888 server.3=zoo3:2888:3888"
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          envFrom:
            - configMapRef:
                name: {{.env.cm}}
          ports:
            - containerPort: 2181 
            - containerPort: 2888
            - containerPort: 3888
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
            - name: runable
              mountPath: /usr/local/bin/entrypoint.sh
              subPath: entrypoint.sh
              readOnly: true
      volumes:
        - name: host-time
          hostPath:
            path: /etc/localtime
        - name: runable
          configMap:
            name: {{.scripts.cm}}
            defaultMode: 0755
