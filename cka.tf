CORE CONCEPT:

To create a pod and a service in one go.
k run nginx --image=nginx --port=80 --expose=true

Command to delete a pod and recreates it.
k replace --force -f <filename.yam>


Certification Tip!

Here’s a tip!

As you might have seen already, it is a bit difficult to create and edit YAML files. Especially in the CLI. During the exam, you might find it difficult to copy and paste YAML files from browser to terminal. Using the kubectl run command can help in generating a YAML template. And sometimes, you can even get away with just the kubectl run command without having to create a YAML file at all. For example, if you were asked to create a pod or deployment with specific name and image you can simply run the kubectl run command.

Use the below set of commands and try the previous practice tests again, but this time try to use the below commands instead of YAML files. Try to use these as much as you can going forward in all exercises

Reference (Bookmark this page for exam. It will be very handy):

https://kubernetes.io/docs/reference/kubectl/conventions/

Create an NGINX Pod

kubectl run nginx --image=nginx

Generate POD Manifest YAML file (-o yaml). Don’t create it(–dry-run)

kubectl run nginx --image=nginx --dry-run=client -o yaml

Create a deployment

kubectl create deployment --image=nginx nginx

Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run)

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run) and save it to a file.

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

Make necessary changes to the file (for example, adding more replicas) and then create the deployment.

kubectl create -f nginx-deployment.yaml

OR

In k8s version 1.19+, we can specify the –replicas option to create a deployment with 4 replicas.

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml

..


ETCD – Commands (Optional)

(Optional) Additional information about ETCDCTL UtilityETCDCTL is the CLI tool used to interact with ETCD.ETCDCTL can interact with ETCD Server using 2 API versions – Version 2 and Version 3.  By default it’s set to use Version 2. Each version has different sets of commands.

For example, ETCDCTL version 2 supports the following commands:

etcdctl backup
etcdctl cluster-health
etcdctl mk
etcdctl mkdir
etcdctl set

Whereas the commands are different in version 3

etcdctl snapshot save
etcdctl endpoint health
etcdctl get
etcdctl put

To set the right version of API set the environment variable ETCDCTL_API command

export ETCDCTL_API=3

When the API version is not set, it is assumed to be set to version 2. And version 3 commands listed above don’t work. When API version is set to version 3, version 2 commands listed above don’t work.

Apart from that, you must also specify the path to certificate files so that ETCDCTL can authenticate to the ETCD API Server. The certificate files are available in the etcd-master at the following path. We discuss more about certificates in the security section of this course. So don’t worry if this looks complex:

--cacert /etc/kubernetes/pki/etcd/ca.crt
--cert /etc/kubernetes/pki/etcd/server.crt
--key /etc/kubernetes/pki/etcd/server.key

So for the commands, I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:

kubectl exec etcd-controlplane -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key"
..



Certification Tips – Imperative Commands with Kubectl

While you would be working mostly the declarative way – using definition files, imperative commands can help in getting one time tasks done quickly, as well as generate a definition template easily. This would help save considerable amount of time during your exams.

Before we begin, familiarize with the two options that can come in handy while working with the below commands:

--dry-run: By default as soon as the command is run, the resource will be created. If you simply want to test your command , use the --dry-run=client option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.

-o yaml: This will output the resource definition in YAML format on screen.

 

Use the above two in combination to generate a resource definition file quickly, that you can then modify and create resources as required, instead of creating the files from scratch.

 
POD

Create an NGINX Pod

kubectl run nginx --image=nginx

 

Generate POD Manifest YAML file (-o yaml). Don’t create it(–dry-run)

kubectl run nginx --image=nginx --dry-run=client -o yaml

 
Deployment

Create a deployment

kubectl create deployment --image=nginx nginx

 

Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run)

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

 

Generate Deployment with 4 Replicas

kubectl create deployment nginx --image=nginx --replicas=4

 

You can also scale a deployment using the kubectl scale command.

kubectl scale deployment nginx --replicas=4 

Another way to do this is to save the YAML definition to a file and modify

kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml

 

You can then update the YAML file with the replicas or any other field before creating the deployment.

 
Service

Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379

kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml

(This will automatically use the pod’s labels as selectors)

Or

kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml (This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

 

Create a Service named nginx of type NodePort to expose pod nginx’s port 80 on port 30080 on the nodes:

kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml

(This will automatically use the pod’s labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

Or

kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

(This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the `kubectl expose` command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.
Reference:

https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands

https://kubernetes.io/docs/reference/kubectl/conventions/


Scheduling:
.........



ISSUE:
When a pod is i pending state and you check the events and describe the pods and it shows nothing in it, know that the cluster in which that pod is created has no scheduler in it.

Solution:
assign the pod manually to run on a node.
k get nodes, this will display the avai nodes in the cluster.

edit the pods manifest and add nodeName property directly under spec section and give the nodename you want the pod to run on and the pod will be created.
..

commands:
k get pods --selector=app=APP1
This will list the pods with the specified selector.

Annotations: are used to record other details for informatory purpose.
You can also use service account with annotation to grant permission to services on aws cloud.
Then using the serviceAccountName option in the pod to grant that permission to the pod to execute actions.
annotations is a child of metadata and siblings of name, namespace and labels. in summary it is used for integration purpose or to record build version.

Labels:
k get pods --selector env=dev --no-headers | wc -l
OR
k get pods --selector=env=dev --no-headers | wc -l
This will get all the pod with the key env and value as dev.
the --no-headers is for the output not to include Name and other headers that comes up with the kubectl command is run.


Taints and tolerations:

Taints are set on nodes and toleartions are set on pods.
To taint a node: 
kubectl taint nodes node1 key1=value1:NoSchedule

The taint effect is what will happen to the pod, if they do not tolerate the taint on the node.
examples of taint effect.
noSchedule
preferNoSchedule
noExcute
.....
Tolerations: Tolerations are added to pods so they can tolerate the taint on the nodes.
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
  
  Note: Taint and toleration does not tell a pod to go to a particular node. It tells the node to only accept pods with certain toleration.
  if your goal is to schedule a pod on a particular node, this is acheived using affinity, nodename and nodeselector.
  commands:
  kubectl describe node kubemaster | grep -i taint
  https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
  
  
  NodeSelector:
  Lets say we have nodes with cpu resources of diff sizes or milicores.
  We would like our pod to end up in a specific node that is higher in cpu. With node selector we can acheive this.
  using node selector we must label the node with a key and value and use the nodeSelector property to assign this key and value to the pod.
  This will ensure the scheduler places the pod on the node with matching labels.
  How to label a node:
  k label nodes node01 key=value
  k label nodes <node-name> <label-key>=<label-value>
  
  Node Affinity and AntiAffinity:
  To indent the yaml file, press cap V and higlight the lines you want to indent. and hold shift and press the . key on your keyboard.
  eg.
  affinity:
  note: indent from the second after setting the first.
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: kubernetes.io/os
              operator: In
              values:
              - linux
			  
NOTE:
With taint and tolerations and node affinity rule, we are able to dedicated our node for a specific pod.

Resource Limit:
OOM kill, out of memory, this occurs when a container trys to consume more memory than stated or allowed.
A container can consume more memmory than allowed..



A quick note on editing PODs and Deployments
Edit a POD

Remember, you CANNOT edit specifications of an existing POD other than the below.

    spec.containers[*].image
    spec.initContainers[*].image
    spec.activeDeadlineSeconds
    spec.tolerations

For example you cannot edit the environment variables, service accounts, resource limits (all of which we will discuss later) of a running pod. But if you really want to, you have 2 options:

1. Run the kubectl edit pod <pod name> command.  This will open the pod specification in an editor (vi editor). Then edit the required properties. When you try to save it, you will be denied. This is because you are attempting to edit a field on the pod that is not editable.

A copy of the file with your changes is saved in a temporary location as shown above.

You can then delete the existing pod by running the command:

kubectl delete pod webapp

Then create a new pod with your changes using the temporary file

kubectl create -f /tmp/kubectl-edit-ccvrq.yaml

2. The second option is to extract the pod definition in YAML format to a file using the command

kubectl get pod webapp -o yaml > my-new-pod.yaml

Then make the changes to the exported file using an editor (vi editor). Save the changes

vi my-new-pod.yaml

Then delete the existing pod

kubectl delete pod webapp

Then create a new pod with the edited file

kubectl create -f my-new-pod.yaml
Edit Deployments

With Deployments you can easily edit any field/property of the POD template. Since the pod template is a child of the deployment specification,  with every change the deployment will automatically delete and create a new pod with the new changes. So if you are asked to edit a property of a POD part of a deployment you may do that simply by running the command

kubectl edit deployment my-deployment

DaemonSet:
This ensures a copy of the pod is always present in each node the cluster.


StaticPods:

These are pods created by the kubelet independent of the cluster components.
The template of the pods and saved in a directory and the path to the location of these pods definition files are passed in the kubelet configuration files.
The kubelet checks this path regularly to create pods placed in it. 
If the pods definition files are removed from that directory the pods will be deleted.
However, if these pods are not removed from the directory and are simply deleted, the kubelet will recreate the pod.

You can only create pods these way, you cant create ds,rs,deploy or svc this way..
The path is passed as options to the kubelet conf file (kubelet.service)
--pod-manifest-path=/etc/Kubernetes/manifests

The pods you see running the cluster controlplane component are created by the kubelet.
The kubelet also takes instruction from the kube-apiserver via an api http endpoint and creates other pods.
What you see when you run the kubectl get pods -n kube-system is just read only a mirror of the staticpods or controlplane component created by the kubelete.
You cannot be able to delete these pods or modify it.
When staticpods are created, the nodename running the pod is appended to the name of the pod.

USE CASE:
...
check staticpod config.yaml file for path where the static pod files are or are created.
/var/lib/kubelet/config.yaml
look for staticPodPath or --pod-manifest-path=/etc/Kubernetes/manifests


Multiple Schedulers:
https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/
Read configuring scheduler..

Logging and monitoring:
k logs webapp-2 -c simple-webapp
where webapp-2 --> pod
simple-webapp --> container
the -c option is used when you have multiple container in a pod.


Monitor cluster components: Metrics of pods and nodes
Managing application logs.
command:
kubectl top nodes will list you the nodes in the cluster and there mem and cpu consumption.
kubectl top pod will do the same for pods.



Application Lifecycle Management:
k set image deployment.apps/frontend simple-webapp=kodekloud/webapp-color:v2
k rollout history deployment.apps/frontend
k rollout status deployment.apps/frontend

kubectl set resources deployment/nginx-deployment -c=nginx --limits=cpu=200m,memory=512Mi
kubectl rollout pause deployment/nginx-deployment
kubectl rollout resume deployment/nginx-deployment
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#pausing-and-resuming-a-deployment


Configure Applications
Configuring applications comprises of understanding the following concepts:

    Configuring Command and Arguments on applications
    Configuring Environment Variables
    Configuring Secrets
	
	Commands at the container levels runs first b4 the one in the Dockerfile.
	
  Create a pod with the given specifications. By default it displays a blue background. Set the given command line arguments to change it to green.
  Pod Name: webapp-green

  Image: kodekloud/webapp-color

  Command line arguments: --color=green
  you can use args or command
  options:
  
  args: ["sleep","5000"] overrides cmd
  args:
  - sleep
  - "5000"
  command: ["sleep", "5000"] this command will override the  entrypoint coomand in the dockerfile when added to the container.
  
  command:
  - sleep
  - "5000"
  
  command: ["sleep"]
  args: ["5000"]
  
  command:
  - "sleep"
  - "5000"

  ENV
  webapp-config-map
  k create cm webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard
  
  .
  Update the environment variable on the POD to use only the APP_COLOR key from the newly created ConfigMap.

  Note: Delete and recreate the POD. Only make the necessary changes. Do not modify the name of the Pod.
  ..
  - env:
        - name: APP_COLOR
          valueFrom:
            configMapKeyRef:
              name: webapp-config-map           # The ConfigMap this value comes from.
              key: APP_COLOR # The key to fetch.
			  
			  ..


		      Pod Name: webapp-color

		      ConfigMap Name: webapp-config-map
https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/


Screts:
https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data
https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/#decoding-secret

Decode the password data:

1. echo "UyFCXCpkJHpEc2I9" | base64 --decode
2. echo -n "DB_Host" | base64 --> DB_Host value in encoded format
3. k get secret <nameofsecret> -oyaml --> shows all value of the secret in encode.


kubectl create secret generic --help


Encrypting secret at rest in etcd cluster
https://kodekloud.com/topic/demo-encrypting-secret-data-at-rest-2/
https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/


Multi-container pod:

They share the same lifecycle, network space and storage volume.
example, a log agent and a webserver..
They comm bw each using localhost.

 https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/
 
 
 InitContainers:

 In a multi-container pod, each container is expected to run a process that stays alive as long as the POD’s lifecycle. For example in the multi-container pod that we talked about earlier that has a web application and logging agent, both the containers are expected to stay alive at all times. The process running in the log agent container is expected to stay alive as long as the web application is running. If any of them fails, the POD restarts.

 

 But at times you may want to run a process that runs to completion in a container. For example a process that pulls a code or binary from a repository that will be used by the main web application. That is a task that will be run only one time when the pod is first created. Or a process that waits for an external service or database to be up before the actual application starts. That’s where initContainers comes in.

 

 An initContainer is configured in a pod like all other containers, except that it is specified inside a initContainers section, like this:
 
 apiVersion: v1
 kind: Pod
 metadata:
   name: myapp-pod
   labels:
     app: myapp
 spec:
   containers:
   - name: myapp-container
     image: busybox:1.28
     command: ['sh', '-c', 'echo The app is running! && sleep 3600']
   initContainers:
   - name: init-myservice
     image: busybox
     command: ['sh', '-c', 'git clone <some-repository-that-will-be-used-by-application> ;']
 
	 When a POD is first created the initContainer is run, and the process in the initContainer must run to a completion before the real container hosting the application starts.

	 You can configure multiple such initContainers as well, like how we did for multi-containers pod. In that case, each init container is run one at a time in sequential order.

	 If any of the initContainers fail to complete, Kubernetes restarts the Pod repeatedly until the Init Container succeeds.

	 apiVersion: v1
	 kind: Pod
	 metadata:
	   name: myapp-pod
	   labels:
	     app: myapp
	 spec:
	   containers:
	   - name: myapp-container
	     image: busybox:1.28
	     command: ['sh', '-c', 'echo The app is running! && sleep 3600']
	   initContainers:
	   - name: init-myservice
	     image: busybox:1.28
	     command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
	   - name: init-mydb
	     image: busybox:1.28
	     command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']

 

	 Read more about initContainers here. And try out the upcoming practice test.

	 https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
	 
	 ISSUES:
	 Crashloop:
	 Check the command in the init container, add initcontainer where neccessary.
	 
	 You can check the logs of a specific container in a pod with other container by running.
	 k logs <pod-name> -c <container-name>
	 
	 

	 Self Healing Applications

	 Kubernetes supports self-healing applications through ReplicaSets and Replication Controllers. The replication controller helps in ensuring that a POD is re-created automatically when the application within the POD crashes. It helps in ensuring enough replicas of the application are running at all times.

	 Kubernetes provides additional support to check the health of applications running within PODs and take necessary actions through Liveness and Readiness Probes. However these are not required for the CKA exam and as such they are not covered here. These are topics for the Certified Kubernetes Application Developers (CKAD) exam and are covered in the CKAD course.
	 
	 

	 Cluster Maintenance:
	 OS-Upgrade
	 Cluster-Upgrade
	 ETCD backup and restore.
	 
	 
	 Draining:
	 When you drain a node, the pods on that nodes and gracefully terminated and re created on another node if theyre pods of a replicaset.
	 kubectl drain <nodename>.
	 When you drain a node, the nodes are marked unschedulable and  cordoned. 
	 This means no pod will be scheduled on that node till you remove the restrictions.
	 Run:
	 kubectl uncordon node-0 to make the node available to receive pods on it, however pods running on that node b4 it was drained dont automatically fallback. only new workloads can now be scheduled on the node.
	 
	 Important:
	 kubectl cordon node-1
	 This command alone marks a node unchedulable and dont evict pods running in the node but drain will evict pods in a node and also cordon the node.
	 
	 Therefor drain = evict pods + cordon
	 
	 whereas cordon = marks unschedulable only.
	 
	 k drain node01 --ignore-daemonsets
	 
	 
	 Important:
	 when you try to drain a node that has a pod running on it that is not part of a replicaset or not controlled by a replicaset with this command:
	 kubectl drain node01 --ignore-daemonsets 
	 
	 ERROR:
	 

	 controlplane ~ ➜  kubectl drain node01 --ignore-daemonsets
	 node/node01 cordoned
	 error: unable to drain node "node01" due to error:cannot delete Pods declare no controller (use --force to override): default/hr-app, continuing command...
	 There are pending nodes to be drained:
	  node01
	 cannot delete Pods declare no controller (use --force to override): default/hr-app.
	 
	 Note: This is b/c once the node is drainned that pod that is not controlled by replicaset will be deleted and not com back.
	 so k8s impliments that restrictions and to continue youll have to use the --force options.
	  kubectl drain node01 --ignore-daemonsets --force
	  
	  
	  Kubernetes software versions:
	  
	  K8s follows semantic versioning in releases,
	  The major,minor and patch.
	  Every few months, the minor version is upgraded and bug fixes are often done on the patch version.
	  
	  1  It release first goes into the alpha stages where the code has bugs and are fixed and improved, features are disbaled and buggy here---- testing and not ready for prod env.
	  2 it goes into beta stages here the code is well tested and features are enabled by default..
	  3 main stable--used in production env..
	  
	  Important:
	  
	  The ETCD and CoreDNS has their diff versions as theyre diff projects..
	  


	  https://kubernetes.io/docs/concepts/overview/kubernetes-api/

	  Here is a link to kubernetes documentation if you want to learn more about this topic (You don’t need it for the exam though):

	  https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md

	  https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api_changes.md
	  
	  
	  Cluster Upgrade:

	  Cluster Upgrade Introduction
	  
	  K8s component versions:
	  Non of the components should have a version higher than the kube-apiserver.
	  If the kube-apiserver is at X V1.10
	  
	  where X is the kube-apiserver.
	  
	  The kube-controller-manager and the kube-scheduler can be at X-1 .ie V1.9 or it can be at the same version as the apiserver V1.10, it shouldnt be above it.
	  
	  The kubelet and the kube-proxy can be at X-2 or it can be at the same version as the apiserver V1.10, it shouldnt be above it.
	  
	  The kubectl client should can be at X+1 > X-1 i.e  V1.11 a version higher than the kube-apiserver or V1.10 the same version with the apiserver or V1.9 a version lower than the apiserver.
	  
	  How do we upgrade:
	  Say k8s has version V1.10, V1.11, V1.12, V1.13.
	  Lets assume our k8s cluster is running on V1.10 can we upgrade directly to V1.13? NO
	  we have to first upgrade to V1.11,...V1.nth
	  
	  UPGRADE PROCESS:
	  This is dependent on how your cluster is setup..
	  If your cluster was created using managed services like eks,aks etc..
	  They provide you an easy way of upgrading your cluster.
	  
	  In a kubeadm setup:
	  
	  You have to plan the upgrade:
	  RUN:
	  kubeadm upgrade plan
	  kubeadm upgrade apply
	  
	  Steps:
	  1. You upgrade the masternode once completed then,
	  The controlplan components like the scheduler,apiserver,the node-controller-manager, go down temporarily.
	  This does not impact your application running in the worker node however, all management functions are down, making an api call via the kubectl client wont be possible, till the apiserver is up.
	  You cannot deploy new applications, delete or update existing ones..
	  The controller managers wont fxn as well, if a pod where to fail, a new pod wont be created automatically...
	  
	  Important: Running kubectl get nodes command will show you that the controlplan components has been upgraded and its now time to upgrade the worker nodes....
	  
	  
	  2. You upgrade the worker nodes
	  
	  There are diff strategies to upgrading the worker nodes:
	  
	  1. Upgrading all of the worker nodes at once.... 
	  Using this strategy, all your pods will be down and users will no longer be able to access your application.
	  Users will be impacted, you obviously dont want this....
	  
	  2.  Strategy 2 upgrading one node at a time...
	   
	  3 strategy 3 will be to add new nodes to the cluster:
	  
	   Add nodes with newer software versions, this approach is good if you are in a cloud env where you can commission new nodes and decommission old nodes.
	   move the workerloads to the new nodes and decommsion old nodes..
	   
	   Practically implimenting this:
	   
	   Run:
	   kubeadm upgrade plan
	   This will show you the version of your kubeadm, the versions of your controlplan and worker nodes component in use.
	   It will also show you the latest/current available stable version you can upgrade to for these individual components...
	   
	   Important:
	   The kubeadm does not install/upgrade the kubelet, you must ssh into each worker node and install/upgrade the kubelet in each node..
	   
	   The kubeadm tool shows you the command to upgrade the cluster, when you run kubeadm upgrade plan. (kubeadm upgrade apply V1.13.4)
	  
	   B4 Proceeding to upgrade the cluster, you must first upgrade the kubeadm tool itself..
	   The kubeadm tool follows the same k8s semantic versioning concepts.
	   Say we are running version V1.11 and wants to upgrade to V1.12
	   First:
	   Upgrade the kubeadm tool itself by running.
	   
	   sudo apt-get upgrade -y kubeadm=1.12.0-00
	   
	   Then upgrade the cluster using the command from the kubeadm upgrade plan output.
	   
	   Important: 
	   Clusters deployed using kubeadm tool has kubelet running on the master nodes.
	   Running kubectl get nodes, will show you the old version of k8s.
	   You have to upgrade the kubelet on the master node and on worker to show the actual version of the newly upgraded k8s release.
	   
	   NB: After upgrading and it still shows you the old version of k8s do not panic, simply upgrade the kubelet by running.
	   
	   sudo apt-get upgrade -y kubelet=1.12.0-00
	   once done restart the kubelet by running..
	   
	   sudo systemctl restart kubelet and running.. kubectl get nodes command will now show that the kubelet has been upgraded on the master or controlplan.
	   The controlplane has been completly upgraded.
	   
	   NOW THE WORKER NODES:
	   
	   Move the workloads from one worker node to the other and upgrade the nodes individually..
	   
	   kubectl drain node-01 --ignore-daemonsets
	   sudo apt-get upgrade -y kubeadm=1.12.0-00
	   sudo apt-get upgrade -y kubelet=1.12.0-00
	   kubeadm upgrade node config --kubelet-version V1.12.0 ---> This upgrades the nodes configuration for the new kubelet version.
	   sudo systemctl restart kubelet --> restarts the kubelet
	   kubectl uncordon node-01 -->to mark the node ready and schedulable again
	   
	   Reference:
	   https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
	   https://v1-27.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/upgrading-linux-nodes/
	   
	   

	   Backup and Restore Methods:
	   Backup etcd cluster:
	   

	   Working with ETCDCTL

	   WORKING WITH ETCDCTL

 

	   etcdctl is a command line client for etcd.

 

	   In all our Kubernetes Hands-on labs, the ETCD key-value database is deployed as a static pod on the master. The version used is v3.

	   To make use of etcdctl for tasks such as back up and restore, make sure that you set the ETCDCTL_API to 3.

 

	   You can do this by exporting the variable ETCDCTL_API prior to using the etcdctl client. This can be done as follows:

	   export ETCDCTL_API=3

	   On the Master Node:

 

	   To see all the options for a specific sub-command, make use of the -h or –help flag.

 

	   For example, if you want to take a snapshot of etcd, use:

	   etcdctl snapshot save -h and keep a note of the mandatory global options.

	   Since our ETCD database is TLS-Enabled, the following options are mandatory:

	   –cacert                verify certificates of TLS-enabled secure servers using this CA bundle

	   –cert                    identify secure client using this TLS certificate file

	   –endpoints=[127.0.0.1:2379] This is the default as ETCD is running on master node and exposed on localhost 2379.

	   –key                  identify secure client using this TLS key file

 

	   For a detailed explanation on how to make use of the etcdctl command line tool and work with the -h flags, check out the solution video for the Backup and Restore Lab.

	   ---
	   Taking a backup of your etcd cluster is a good approach to securing and making your k8s cluster and recovering it in case of disaster.
	   Back of some of the resources in your cluster can be done by querying the kube-apiserver by running
	   
	   kubectl get all --all -namespaces -o yaml > all-deploy-service.yaml
	   
	   But the above is limited to few resources..
	   
	   There are certain tools that can also help us in taking backup of the etcd cluster such as Velero formally called ARK by HepTio.
	   
	   Alternatively using the etcd client utility...
	   
	   Important: etcd data dir is the directory that will be configured by the backup tool where etcd data are stored... It is passed as option in the etcd configuration..
	   --data-dir=/var/lib/etcd
	   
	   Taking the etcd cluster backup:
	   
	   Run:
	   
	   export ETCDCTL_API=3
	   
	   etcdctl snapshot save snapshot.db  \
	    -–endpoints=https://127.0.0.1:2379 \
		 --cert=/etc/kubernetes/pki/etcd/server.crt \
		  --key=/etc/kubernetes/pki/etcd/server.key \
		  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
	    
		 Run ls to see the snapshot. If you do not want the snapshot saved in the pwd, specify a location you want it saved.
		 
		 etcdctl snapshot status <snapshotname> --> This displays the status of the snapshot.
		 
		 RESTORING ETCD CLUSTER USING THE SNAPSHOT CREATED.
		 
		 Run
		 1. Stop the kube-apiserver b4 restoring etcd cluster using the snapshot. This is b/c the etcd cluster depends on it and will need to be restarted.
		 You'll restart it afterwards.
		 service kube-apiserver stop
		 
		 etcdctl snapshot restore <snapshot_name> \
		 --data-dir /var/lib/etcd-from-backup
		 
		 
		 NB:
		 
		 When restoring an etcd cluster using `etcdctl snapshot restore`, you generally do not need to specify the `--cert`, `--key`, and `--cacert` options because the etcd server is typically not running when you are performing a snapshot restore. The `--endpoints` option is also not necessary in this context because the etcd server is not running.

		 Here is a simplified version of the `etcdctl snapshot restore` command:

		 ```bash
		 etcdctl snapshot restore <snapshot_name> --data-dir /var/lib/etcd-from-backup
		 ```

		 This command is usually sufficient for restoring from an etcd snapshot because the etcdctl tool should be able to locate and use the TLS configuration from the etcd configuration file (`etcd.conf`) stored in `/etc/etcd/`.

		 If you have a custom etcd configuration file or if the etcdctl tool cannot locate the necessary TLS configuration, you might need to specify the TLS-related options (`--cert`, `--key`, and `--cacert`) to ensure secure communication with etcd during the restore process.

		 However, in a typical disaster recovery scenario, when you are restoring from a snapshot due to cluster issues, the etcd server is not running, so specifying these TLS options is often unnecessary.

		 It's essential to refer to your specific etcd setup and documentation for any unique requirements or configurations related to your cluster. Additionally, make sure to back up your TLS certificates and keys securely as part of your backup strategy.
		  
	   
		 Important: When etcd restores from a backup, it initializes a new cluster configuration and configures members of etcd as new members to a new cluster,
		  this is to prevent a new member from accidently joining an existing cluster.
		  
		  In running the above command, a new data dir is created at /var/lib/etcd-from-back.
		  We then configure the etcd configuration file to use the new data dir..
		  
		  Finally: reload the service daemon, restart the etcd and kube-apiserver.
		  run:
		  sudo systemctl daemon-reload
		  sudo service etcd restart
		  service kube-apiserver start
		  
		  
		  REF: https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/
	   
	   
		  example:
		  
		 ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
		    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
			--cert=/etc/kubernetes/pki/etcd/server.crt \
			--key=/etc/kubernetes/pki/etcd/server.key \
		    snapshot save /opt/cluster1.db
  
  
		    etcdctl snapshot restore --data-dir /var/lib/etcd-from-backup
	 
	 
			You dont necessarily need to restart the etcd or the kube-apiserver if it fails to restart.
			wait for a few min for the kube-apiserver to come up after mounting the new data dir in the volume and in the other required places.
			if it etcd pod fails to come up, delete the pod and it will be re created..
			
			

			Certification Exam Tip!

			Here’s a quick tip. In the exam, you won’t know if what you did is correct or not as in the practice tests in this course. 
			You must verify your work yourself. For example, if the question is to create a pod with a specific image, 
			you must run the the kubectl describe pod command to verify the pod is created with the correct name and correct image.
			
			


			https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster

			https://github.com/etcd-io/website/blob/main/content/en/docs/v3.5/op-guide/recovery.md

			https://www.youtube.com/watch?v=qRPNuT080Hk
			
			
			Delete a pod stocked in terminating mode:
			
			kubectl delete pod <pod_name> --force --grace-period=0
			
			Important:
			Once you mounth the --data-dir for the etcd cluster, save and wait for the pods to come up both the kube-api..
			You can delete the etcd pod and it will be re created...
			
			
			.......
			Practice Test Backup and Restore Methods 2
			
			kubectl config  get-clusters -->Display clusters defined in the kubeconfig
			kubectl config  -h
			 kubectl config current-context --> Display the current-context
			 
			 kubectl config use-context cluster2 --> Set the current-context in a kubeconfig file
			 
			 
			 What is the default data directory used the for ETCD datastore used in cluster1?
			 Remember, this cluster uses a Stacked ETCD topology.
			 Meaning runs in a pod..
			
			 1. How many nodes are part of the ETCD cluster that the etcd-server is a part of???
			 
			 Answer:
			 
			 ETCDCTL_API=3 etcdctl \
			 --endpoints=https://127.0.0.1:2379 \
			 		    --cacert=<enter the path to the CA cert of the etcd> \
			 			--cert=<enter the path to the server cert of the etcd> \
			 			--key=<enter the path to the key file of the etcd> \
						member list
						
						This will list the members of the etcd..
						
						
						COPY FROM ONE SERVER TO ANOTHER.
						YOU HAVE TO BE IN THE DESTINATION SERVER.
						
						scp cluster1-controlplane:/opt/snapshot.db /opt
						or
						to copy from pwd to another server
						
						scp /opt/snapshot.db     etcd-server:/root
						locationofsnapshot            <destination-server/node>:<path to save it>
						
						Secure copy from where or which server cluster1-controlplane
						from what source or path to the file? :/opt/snapshot.db
						to what destination? /opt
						
						
						2. How does the api-server communicate with the etcd?
						It uses the etcd server url https://127.0.0.1:2379 in a stacked etcd but for external etcd, the ip will change, it will be the ip of the external etcd server.
						
						Important:
						Youll always save snapshot in a safe location, so if workloads goes down in a specific server, you scp the snapshot to the server and restore the server using the backup file..
						
						
						Security:
						
						Kubernetes priv=mitives..
						Network Policies..
						The Kube-apiserver being at the center of k8s. Every other component in the cluster talks to the apiserver.
						Our goal would be start with it as our first line of defense, securing the kube-apiserver. How can we do this? This is defined by:
						
						1. Who can access the k8s cluster (Authentication)
						2. What can they do (Authorization)
						
						Authentications:
						The various authentication mechanism are:
						1 Certificates 2. ServiceAcccounts 3. External Authentication providers -LDAP 3. Files- Username and Password 5. Files Username and Tokens...
						
						Authorization:
						The various Authorization mechanism are:
						1. RBACK -- Role based access control
						2. ABACK --
						3. Node Authorization
						4 Webhook mode
						
						Communication between the various components in the kubernetes cluster is secured using TLS-CERTIFICATE.
						
						Important: By default all pods can talk to any pods in the cluster..
						How can limit/restrict communication between pods in the cluster?, we use network policy to do this.
						
						
						
						Authentications:

						Article on Setting up Basic Authentication
						Setup basic authentication on Kubernetes (Deprecated in 1.19)

						    Note: This is not recommended in a production environment. This is only for learning purposes. Also note that this approach is deprecated in Kubernetes version 1.19 and is no longer available in later releases

						Follow the below instructions to configure basic authentication in a kubeadm setup.

						Create a file with user details locally at /tmp/users/user-details.csv

						    # User File Contents
						    password123,user1,u0001
						    password123,user2,u0002
						    password123,user3,u0003
						    password123,user4,u0004
						    password123,user5,u0005

						Edit the kube-apiserver static pod configured by kubeadm to pass in the user details. The file is located at /etc/kubernetes/manifests/kube-apiserver.yaml

						    apiVersion: v1
						    kind: Pod
						    metadata:
						      name: kube-apiserver
						      namespace: kube-system
						    spec:
						      containers:
						      - command:
						        - kube-apiserver
						          <content-hidden>
						        image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
						        name: kube-apiserver
						        volumeMounts:
						        - mountPath: /tmp/users
						          name: usr-details
						          readOnly: true
						      volumes:
						      - hostPath:
						          path: /tmp/users
						          type: DirectoryOrCreate
						        name: usr-details

						Modify the kube-apiserver startup options to include the basic-auth file

						    apiVersion: v1
						    kind: Pod
						    metadata:
						      creationTimestamp: null
						      name: kube-apiserver
						      namespace: kube-system
						    spec:
						      containers:
						      - command:
						        - kube-apiserver
						        - --authorization-mode=Node,RBAC
						          <content-hidden>
						        - --basic-auth-file=/tmp/users/user-details.csv

						Create the necessary roles and role bindings for these users:

						    ---
						    kind: Role
						    apiVersion: rbac.authorization.k8s.io/v1
						    metadata:
						      namespace: default
						      name: pod-reader
						    rules:
						    - apiGroups: [""] # "" indicates the core API group
						      resources: ["pods"]
						      verbs: ["get", "watch", "list"]

						    ---
						    # This role binding allows "jane" to read pods in the "default" namespace.
						    kind: RoleBinding
						    apiVersion: rbac.authorization.k8s.io/v1
						    metadata:
						      name: read-pods
						      namespace: default
						    subjects:
						    - kind: User
						      name: user1 # Name is case sensitive
						      apiGroup: rbac.authorization.k8s.io
						    roleRef:
						      kind: Role #this must be Role or ClusterRole
						      name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
						      apiGroup: rbac.authorization.k8s.io

						Once created, you may authenticate into the kube-api server using the users credentials

						curl -v -k https://localhost:6443/api/v1/pods -u "user1:password123"
						
						

						TLS Introduction:
						Goals:
						What are TLS Certificates?
						How does Kubernetes use Certificates?
						How to generate them?
						How to configure them?
						How to view them?
						How to troubleshoot issues related to certificates.
						
						TLS-BASICS:
						Encryption...
						How can we secure our communications over the internet? 
						How can a client (a user or her browser) securly communicate with a web-server?
						
						We have 2 ways of securing communication from the client to the server and vice versa..
						1. By the use of Symmetric encryption and asymmetric Encryption.
						Symmetric encryption uses one key to encrypt data and the same key to decrypt data.
						Asymmetric encryption uses a pair of keys, a public key and a private key.. 
						if it uses a private key to encrypt, it will use a public key to decrypt the data and also if it uses a public key to encrypt a data it will use a private key to decrypt the data.
						
						Lets picture a senario where we have a hacker acting as a middle man in our communication. i.e, a communication bw a client and a server.
						I the client sends a packet unencrypted over a http connection to a server, the hacker receives this data and the server receives that data also.
						My data is compromised and im hacked...
						
						I look for new measures to impliment security and secure communication to my server.. I then think of encryption and then, i encrypt the data being sent to the server using
						symmetric encryption mechanism... 
						I send the encrypted data to the server, the hacker receives the data and the same goes for the server but b/c its encrypted with symmetric key 
						they both cant do anything with the data. 
						
						I will have to also send the symmetric key that i used to encrypt the data to the server for it to be able to decrypt and retrive/use the data. 
						If i do this the hacker will also get the key and decrypt the data.
						
						How can i ensure the hacker do not have access to the key or even if he has access to the key he will not be able to use it????
						
						We will acheive this using Asymmetric encryption.
						We think of ways to secure the web-server and this is done by generating a pair of keys using Asymmetric encryption.
						
						we use the openssl command to generate a private and public key at the server level and make it secure..
						
						RUN:
						openssl genrsa -out my-bank.key 1024 ---> this will generate a private key called my-bank.key
						we then use the private key to generate a public key by running
						
						openssl rsa -in my-bank.key -pubout > mybank.pem --> This will generate a public key called mybank.pem
						
						With this we have secured the server..
						
						NOW COMMUNICATION:
						
						When the client first accesses the server over an https communication, the clients retreives a public key and since the hacker is in between the client and the server, the 
						hacker also gets hold of the public key.
						
						Then client main goal is to securly send the symmetric key to the server so they can use it for all future communication..
						
						The client then uses the public key it got from the server to encrypt the symmetric key and sends it back to the server.
						The hacker then receives the encrypted data that has (The public key and the symmetric key) from the client, the server also receives the same and since the encryption
						was done using the public key of the server, the server has the private key it will use to decrypt the data. The server then uses its private key to decrypt the data and retrives 
						the symmetric key.
						
						The hacker is then left with the encrypted data since it does not have the private key to decrypted the data.
						
						Remember: The key that was used to encrypt the data and decrypt it was the Asymmetric key generated at the web server.
						
						We have successfully secured communication between a client and a server...
						All future communication can then be done using the Symmetric keys.
						
						The server can then encrypt data with the symmetric key and sends to the client and the client can then decrypt the data with symmetric keys he has also.
						The same goes for the client, it can then encrypt data with his symmetric key and send to the server and the server decrypts it.. 
						
						The hacker will be left with only encrypted messages...
						
						Important:
						
						The hacker seeing that he has been bypassed and that the  server and the client are able to communicate securly leaving him with encrypted data. 
						He then searches for new ways to trick/tweak the client server/network.
						The hacker then clones the clients bank websites, builds a replica of the site, or the site the client is accessing..
						He creates a server and hosts the site and also generates his sets of Asymmetric keys on the server to secure a https communication, making his server secured...
						
						The Hacker then tweaks the clients server to route outing going requests from the clients on (https://alpha-bank.com) to his own server (the cloned site).
						
						The client is now presented with similar websites as that of his original bank..
						The client in this case the clients browser receives a public key from the hackers server when he accesses the site..
						The client uses the public key sent by the hackers server to encrypt his symmetric key and sends it back to the hackers server.
						The hacker decrypts the symmetric key and retreives it. 
						
						The hacker and the clients can now securly communicate with each other using the symmetric key...
						The client then types in his credentials, a username and password of his bank account.
						
						He is then presented with a dashboard different from that of his bank that says he has been hacked...
						
						
						QUESTION:
						What if you can look at the key from the servers be it the hackers server or any other server to determine its from the actual bank server?
						When the server sends the public key, it does not send that alone. The server sends a certificate along with the key in it. 
						When you view the certificates you'll be able to tell if the certifcate is legitmate or not. 
						You will be able to tell the issuer of that certificate.
						
						Informations found in the certificates:
						
						Serial No --> cert NO
						Issuer --> The CA that issued the certificate
						Validity --> expiration
						Subject --> CN=alpha-bank.com
						Subject Alternative Name --> The sub domains for the bank or other dns names that users can use to reach your bank.
						e.g. DNS:my-bank.com DNS:i-bank.com DNS:we-bank.com
						Subject Public Key Info: The public key of the server.
						
					 
						If You look closely at the certificate sent by the hackers server, you'll notice that its a fake certificate and it was signed by the hacker himself..
						The browsers has an inbuilt function that warns you about fake certifcates mimiking public available sites like banks,govt etc..
						
						How do you get your your certificate signed by someone with authority?
						That is where the CA comes in...
						
						1. You generate a certificate signing request using the <my-bank.key> which is the private key you generated for the server when you ran, 
						openssl genrsa -out my-bank.key 1024 ---> this will generate a private key called my-bank.key
						
						You then use this private key to create a certificate signing request..
						
						by running:
						openssl genrsa -out myuser.key 2048
						openssl req -new -key myuser.key -out myuser.csr..
						
						
						SUMMARILY:
						An admin user generate a pair of keys to secure ssh connection to the server.
						The server generates Asymmetric keys to secure https communication with the client. But b4 this is done, the server generates a csr and sends to the CA.
						The CA uses their private key to sign the certificate and sends it back to the server.
						When the client accesses the server, it retrives the servers certificate which has the servers public in it and which was signed by The CA.
						The clients browser, which has the public keys of the CA, validates the certificate sent by the server and retrives the public key of the server.
						
						The client then generate Symmetric key and uses the public key of the server to sign the symmetric key and sends this symmetric key to the server.
						The server receives the symmetric key and uses his private key to decrypt the key sent by the client and retrievs the symmetric key.
						
						Going forward all communication bw the client and the server are now going to be done using the symmetric key.
						
						As part of trust building the client once establishes trust with the server. It then authenticates to the server/website using his username and password..
						
						
						PROBLEM:
						
						With the servers key pairs the client is able to determine that the server is who they say they are but, the server does not know for sure if the client is who they say they are.
						To the server, it might be a hacker who gained access to the clients credentials obvioulsy not over the network since we have secured with TLS it but maybe via other means..
						
						What can the server do to validate that the client is who they say they are?
						
						For this the client has to generate a certificate signed by a trusted CA and send to the server for the server to validate that the client is who they say they are.
						
						This whole infrastructure, include the CA, the server, the people, the process of generating and maintaining the certificate is called PKI (public key infrastructure)
						
						Naming convention:
						Certificate with public keys are named:
						*.crt *.pem
						server.pem
						server.crt
						client.pem
						client.crt
						
						Certificate with private keys are named:
						
						*.key *-key.pem
						server.key
						server-key.pem
						client.key
						client-key.pem
						.......................................
						
						Important, private keys has .key as their extension or it has -key.pem in them...
						Public keys has .pem as keys and .crt as certificates...
						

						TLS in Kubernetes
						
						The various component in the k8s cluster communicates with each other using TLS certificate..
						We identify who the servers and clients are in the kubernetes cluster..
						
						Servers:
						
						1. The apiserver
						2. The etcd
						3. The kubelet
						
						The kube-apiserver is a server that all component in the clusters communicates with. The kube-apiserver is the primary component that all others talks to in the cluster.
						The kube-apiserver is the only component that talks to the etcd-server.
						
						Communications.
						
						1. Since all components interacts with the kube-apiserver, we will generate a certificate called.
						apiserver.crt and apiserver.crt
						
						i. Also the apiserver is a client to the kubelet b/c it interacts with the kubelet with instructions to create a pod.
						so we generate a set of certificate for it communicate with the kubelet.
						apiserver-kubelet-client.crt and apiserver-kubelet-client.key
						
						ii. Also the kube-apiserver is a client to the etcd cluster, b/c it interacts with the etcd to persist and retrive data.
						so we generate a set of certificate for it communicate with etcd.
						apiserver-etcd-client.crt and apiserver-etcd-client.key
						
						2. The etcd cluster is a server also, so we generate a set of certificate for it.
						etcd.crt etcd.key
						
						3. The kubelet on the worker node is a server b/c the kube-apiserver communicates with the kubelet with instructions to schedule a pod on it node. so we generate a set of certificate for it.
						kubelet.crt and kubelet.key
						Also the kubelet is a client to the kube-apiserver b/c it interacts with the kube-apiserver with the information on the created pods on it node.
						so we generate a set of certificate for it communicate with kube-apiserver.
						kubelet-client.crt and kubelet-client.key
						
						4. The scheduler communicates with the kube-apiserver to check for pod object that needs to be scheduled on a node.
						Therefore the scheduler is a client to the kube-apiserver. so we generate a set of certificate for it communicate with the apiserver.
						scheduler.crt and scheduler.key
						
						5. The kube-controller-manager is a client to the kube-apiserver, it interacts with the kube-apiserver to monitor and manage the clusters resources, ensuring they conform to 
						the desired configuration and state.
						so we generate a set of certificate for it communicate with the apiserver.
						controller-manager.crt and controller-manager.key
						
						6. The kube-proxy is another component who's a client to the kube-apiserver, it interacts with the kube-apiserver to get updates to changes in service configurations, kube proxy needs to be aware
						when services are created, updated, or deleted, kube proxy needs to update its network rules accordingly to ensure that traffic is properly routed to the correct service endpoints. 
						To acheive this it watches the kubernetes API SERVER for changes in configuration.
						so we generate a set of certificate for it to communicate with the apiserver.
						kube-proxy.crt and kube-proxy.key
						
						
						7. The admin user who will be accessing the cluster using the kubectl utility tool, needs a pair of certificate to interacts with the kube-apiserver.
						  so we generate a set of certificate for it communicate with the apiserver.
						  admin.crt and admin.key
						  
						 8.  These various Certificates needs to be signed by the CA.So we generate a set of certificate for CA.
						 We called root certificate, ca.crt and ca.key
						 
						 
						 Important: You can you a diff CA which is not the one used for the other k8s component to sign the etcd certificates. 
						 If you do, it means that same CA will have to sign the certificate that the kube-apiserver will use to authenticate with the etcd.
						 
						 However, of all the other components in the cluster we use one CA to sign their certificates....
						
						

						 TLS in Kubernetes – Certificate Creation:
						 Creating certificate using OPENSSL:
						1. First we create/Generate the CA certificate using the openssl command:
						openssl genrsa -out ca.key 2048 --> Generates the Certificate authority key..
						This will output ca.key
						
						2. Create a certificate signing Request.
						We use the openssl command along with the key we created to generate a certificate signing request.
						openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
						This will output ca.csr
						
						3. Sign the certificate using the x509 command.
						Here you specify the csr and the signkey to be used in signing the cert.
						
						openssl x509 req -in ca.csr -signkey ca.key -out ca.crt
						This will output ca.crt
						
						The above is the CA key and Root certifciate file, the CA used its key to sign its certifciate.
						
						Going further, we will use the CA key to sign the rest of the certifcate signing request by the cluster components.
						-----
						
						Lets say we want to create to create a certificate for the admin user to authenticate via the kubectl utility to the cluster..
						
						1. We generate key for the admin user.
						openssl genrsa -out admin.key 2048
						output admin.key
						
						2. We Create a CSR.
						openssl req -new -key admin.key -subj "CN/=KUBE-ADMIN" -out admin.csr
						output admin.csr
						
						3. We sign the CSR using the CA KEY AND THE CA CERTIFICATE and generate a certificate:
						
						openssl x509 req -in admin.csr -CAkey ca.key -CA ca.cert -out admin.crt
						output admin.crt
						
						Important: You have signed the certificate using the CA key and Cert files and that makes it a valid certificate..
						The certicate is what the admin user will use to authenticate to the kubernetes cluster..
						This whole process is similar to creating a username name and password.
						The certificate is like a userid/username and the key is like a password.
						The only different from those is that the key and certificate is much more secured..
						
						This certificate admin.crt is for the admin user, how do you differenciate this user from any other user in the cluster?
						
						A group named system:masters exists in kubernetes with administrative privileges.
						add this system:masters using the OU parameter when creating the csr for the admin user.
						
						therefore in creating the csr, it will be:
						openssl req -new -key admin.key -subj "CN/=kube-admin/O=system:masters" -out admin.csr
						output admin.csr
						
						Important, we follow the same process to create certificate for all other clients that access the kube-apiserver.
						
						2. Create a certificate for the kube-scheduler
						The kube-scheduler is a system componet its name should be prefixed with the key word system.
						1. We generate key for the admin user.
						openssl genrsa -out scheduler.key 2048
						output scheduler.key
						
						2. We Create a CSR.
						openssl req -new -key scheduler.key -subj "CN/=system:kube-scheduler" -out scheduler.csr
						output scheduler.csr
						
						
						3. We sign the CSR using the CA KEY AND THE CA CERTIFICATE and generate a certificate:
						
						openssl x509 req -in scheduler.csr -CAkey ca.key -CA ca.cert -out scheduler.crt
						output scheduler.crt
						
						Note: Follow the same process to create a certificate for the kube-controller-manager,kube-proxy and other client certificates.
						Such as the apiserver-kubelet-client.crt, apiserver-kubelet-client.key and apiserver-etcd-client.crt, apiserver-etcd-client.crt
						kubelet-client.crt, kubelet-client.key
						
						They do not require the OU parameters..
						
						
						Making an api call using the created certificate such as the admin user cert and key.
						
						curl https://kube-apiserver:6443/api/v1/pods \
						--key admin.key \
						--cert admin.crt \
						--cacert ca.crt
						
						Break down:
						
						The `curl` command you provided is attempting to access the Kubernetes API server to retrieve a list of pods using client certificates 
						and the cluster's CA certificate for authentication and secure communication. 
						This command should work if the certificates are correctly configured and valid. Here's a breakdown of the command:

						- `https://kube-apiserver:6443/api/v1/pods`: This is the URL of the Kubernetes API server endpoint for retrieving pod information.

						- `--key admin.key`: This option specifies the client's private key (`admin.key`) for authentication.

						- `--cert admin.crt`: This option specifies the client's certificate (`admin.crt`) for authentication.

						- `--cacert ca.crt`: This option specifies the cluster's CA certificate (`ca.crt`) for verifying the authenticity of the Kubernetes API server's certificate.

						Before using this command, make sure the following is in place:

						1. **Certificate Files**: Ensure that the `admin.key`, `admin.crt`, and `ca.crt` files exist and are correctly configured.

						2. **Client Certificate and Key**: The `admin.key` and `admin.crt` files should match a valid client certificate and key pair that have the necessary permissions to access the Kubernetes API server.

						3. **CA Certificate**: The `ca.crt` file should be the CA certificate used by your Kubernetes cluster for server certificate verification.

						4. **Kubernetes API Server**: The URL `https://kube-apiserver:6443` should point to the correct Kubernetes API server and be accessible from the machine where you are running `curl`.

						5. **Network Access**: Ensure that your machine has network access to the Kubernetes API server on port 6443.

						6. **Authorization**: Depending on your Kubernetes cluster's RBAC configuration, you may need the appropriate permissions to access the `/api/v1/pods` endpoint.

						If everything is set up correctly, the `curl` command should be able to communicate with the Kubernetes API server and retrieve information about pods in your cluster.
						
						
						NOW HAVE CREATE CERTIFICATE FOR THE KUBE-APISERVER.
						The kube-apiserver is the most popular component in the kubernetes cluster.
						Everyone talks to the kube-apiserver, every operations goes through the kube-apiserver, anything moving in the cluster the apiserver knows about it.
						You need information, you talk to the apiserver.
						Therefore, it goes by many names and aliases, its known as the kube-apiserver, many call it kubernetes.
						For alot of people who dont know what goes on under the hood in kubernetes, the apiserver is kubernetes. 
						some call it kubernetes.default, some kubernetes.default.svc, some kubernetes.default.svc.cluster.local
						
						In most cases, it is also refferred to as by the IP.. i.e The IP address of the host or the pod running the kube-apiserver.
						
						All these names most be present in the certificate generated for the kube-apiserver.
						This names should be passed in the  common Name (CN) "/CN=kube-apiserver" while generating the csr. So anyone connecting to the kube-apiserver using these known names can reach it
						or establish a valid connection.
						NB: The csr is a certificate without a signature.
						
						Important: These names cannot be passed via the command line, Youll have to create an openssl.cnf configuration file 
						OR alternate names file where the names will be entered and passed as an option while creating the csr.
						
						Example. The openssl.cnf file for the apiserver that should be passed as options while creating the csr for the apiserver certificate.
						openssl.cnf

						[ req ]
						req_extensions = v3_req
						distinguished_name = req_distinguished_name

						[ v3_req ]
						basicConstraints=CA:FALSE
						keyUsage=nonRepudiation,
						subjectAltName=@alt_names

						[ alt_names ]
						DNS.1 = kubernetes
						DNS.2 = kubernetes.default
						DNS.3 = kubernetes.default.svc
						DNS.4 = kubernetes.default.svc.cluster
						DNS.5 = kubernetes.default.svc.cluster.local
						IP.1 = <MASTER_IP>
						IP.2 = <MASTER_CLUSTER_IP>
						
						
						
					https://kubernetes.io/docs/tasks/administer-cluster/certificates/
					
					RUN:
					
					1. We generate key for the admin user.
					openssl genrsa -out apiserver.key 2048
					output apiserver.key
					
					2. We Create a CSR.
					openssl req -new -key apiserver.key -subj "CN/kube-apiserver" -config openssl.cnf -out apiserver.csr
					output apiserver.csr
					
					3. We sign the CSR using the CA KEY AND THE CA CERTIFICATE and generate a certificate for the apiserver:
					
					openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key \
					    -CAcreateserial -out apiserver.crt -days 1000 \
					    -extensions v3_req -extfile openssl.cnf 
	     
						output apiserver.csr
					
						Important:
						While configuring the kube-apiserver executable, Youll have to pass all the certificate and the CA certificate at each aspect in the configuration that it uses to communicate
						with the kubelet as a client, the etcd as a client and its tls certificate as a server.
						
						Example:
						 
						
						Describe the kube-apiserver pod for the configurations on how the 3 diff certificates where passed.
						
						NOW WE HAVE THE KUBELET SERVER CERTIFICATE...
						Create a certificate for the kubelet server, depending on the number of nodes in the cluster say node01 to 10th node.
						You must name the certificate with the node prefix to diffrenciate it with the other cert in other nodes.
						eg
						1. We generate key for the admin user.
						openssl genrsa -out kubelet-node01.key 2048
						output kubelet-node01.key
				       
						2. We Create a CSR.
					    openssl req -new -key kubelet-node01.key -subj "CN/kubelet-node01" -out kubelet-node01.csr
					     output kubelet-node01.csr
						
						
 						3. We sign the CSR using the CA KEY AND THE CA CERTIFICATE and generate a certificate:
						
 						openssl x509 req -in kubelet-node01.csr -CAkey ca.key -CA ca.cert -out kubelet-node01.crt
 						output kubelet-node01.crt
						
						Important: Once the certificate has been created, use the kubelet-node01.crt, the ca.crt and kubelet-node01.key to configure the kubelet config.yaml file. 
						Youll have to pass the cert options..
						You must do this in all the nodes in the cluster...
						
						
						THE KUBELET NODES CLIENT CERTIFICATE:
						The kubelet uses this to authenticate with the kube-apiserver.
						What do we name these certificates????
						The apiserver needs to know which node is authenticated and gives it the rigt permission..
						the apiserver requires the nodes to have the right names in the right format.. Since the nodes are system components like the scheduler, the controller manager.
						The format or naming convention starts with the keyword system.
						example.
						system:node:node01 ---> This is the naming convention and should be in the CN.
						How will the apiserver give it the right permission like we did for the admin user??????????
						
						AS WE DID FOR THE ADMIN USERS.. WHILE GENERATING THE CERTIFICATE, WE WILL HAVE TO USE THE OU OPTIONS TO ADD THE GROUP DETAILS OF SYSTEM:NODES 
						WHEN CREATING CSR for the kubelet nodes client certificate.
						
						therefore in creating the csr, it will be:
						openssl req -new -key kubelet-client-node01.key -subj "CN/=system:node:node01/O=system:nodes" -out kubelet-client-node01.csr
						output kubelet-client-node01.csr
						
						
						
						
						
						
	 

 
