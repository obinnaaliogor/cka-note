CORE CONCEPT:

To create a pod and a service in one go.
k run nginx --image=nginx --port=80 --expose=true

Command to delete a pod and recreates it.
k replace --force -f <filename.yam>


Certification Tip!

Here’s a tip!

As you might have seen already, it is a bit difficult to create and edit YAML files. 
Especially in the CLI. During the exam, you might find it difficult to copy and paste YAML files from browser to terminal.
 Using the kubectl run command can help in generating a YAML template. 
 And sometimes, you can even get away with just the kubectl run command without having to create a YAML file at all.
  For example, if you were asked to create a pod or deployment with specific name and image you can simply run the kubectl run command.

Use the below set of commands and try the previous practice tests again, but this time try to use the below commands instead of YAML files. 
Try to use these as much as you can going forward in all exercises

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

(Optional) Additional information about ETCDCTL Utility. ETCDCTL is the CLI tool used to interact with ETCD. ETCDCTL can interact with ETCD Server using 2 API versions – Version 2 and Version 3.  
By default it’s set to use Version 2. Each version has different sets of commands.

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

When the API version is not set, it is assumed to be set to version 2. And version 3 commands listed above don’t work. 
When API version is set to version 3, version 2 commands listed above don’t work.

Apart from that, you must also specify the path to certificate files so that ETCDCTL can authenticate to the ETCD API Server. 
The certificate files are available in the etcd-master at the following path. We discuss more about certificates in the security section of this course. So don’t worry if this looks complex:

--cacert /etc/kubernetes/pki/etcd/ca.crt
--cert /etc/kubernetes/pki/etcd/server.crt
--key /etc/kubernetes/pki/etcd/server.key

So for the commands, I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:

kubectl exec etcd-controlplane -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key"
..



Certification Tips – Imperative Commands with Kubectl

While you would be working mostly the declarative way – using definition files, imperative commands can help in getting one time tasks done quickly, as well as generate a definition template easily. 
This would help save considerable amount of time during your exams.

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

(This will automatically use the pod’s labels as selectors, but you cannot specify the node port. 
You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

Or

kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

(This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the `kubectl expose` command. 
If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.
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
With taint and tolerations and node affinity rule, we are able to dedicate our node for a specific pod.

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

For example you cannot edit the environment variables, service accounts, resource limits (all of which we will discuss later) of a running pod.
 But if you really want to, you have 2 options:

1. Run the kubectl edit pod <pod name> command.  This will open the pod specification in an editor (vi editor). Then edit the required properties. 
When you try to save it, you will be denied. This is because you are attempting to edit a field on the pod that is not editable.

A copy of the file with your changes is saved in a temporary location as shown below.

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

With Deployments you can easily edit any field/property of the POD template. 
Since the pod template is a child of the deployment specification,  with every change the deployment will automatically delete and create a new pod with the new changes. 
So if you are asked to edit a property of a POD part of a deployment you may do that simply by running the command

kubectl edit deployment my-deployment

DaemonSet:
This ensures a copy of the pod is always present in each node the cluster.


StaticPods:

These are pods created by the kubelet independent of the cluster components.
The template of the pods are saved in a directory and the path to the location of these pods definition files are passed in the kubelet configuration files.
The kubelet checks this path regularly to create pods placed in it. 
If the pods definition files are removed from that directory the pods will be deleted.
However, if these pods are not removed from the directory and are simply deleted, the kubelet will recreate the pod.

You can only create pods these way, you cant create ds,rs,deploy or svc this way..
The path is passed as options to the kubelet conf file (kubelet.service)
--pod-manifest-path=/etc/Kubernetes/manifests

The pods you see running the cluster controlplane component are created by the kubelet.
The kubelet also takes instruction from the kube-apiserver via an api http endpoint and creates other pods.
What you see when you run the kubectl get pods -n kube-system is just read only mirror of the staticpods or controlplane component created by the kubelet.
You cannot be able to delete these pods or modify it.
When staticpods are created, the nodename running the pod is appended to the name of the pod.

USE CASE:
...
check kubelet config.yaml file for path where the staticpod files are or are created.
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

 In a multi-container pod, each container is expected to run a process that stays alive as long as the POD’s lifecycle. 
 For example in the multi-container pod that we talked about earlier that has a web application and logging agent, both the containers are expected to stay alive at all times. 
 The process running in the log agent container is expected to stay alive as long as the web application is running. If any of them fails, the POD restarts.

 

 But at times you may want to run a process that runs to completion in a container. For example a process that pulls a code or binary from a repository that will be used by the main web application. 
 That is a task that will be run only one time when the pod is first created. Or a process that waits for an external service or database to be up before the actual application starts. 
 That’s where initContainers comes in.

 

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

	 Kubernetes supports self-healing applications through ReplicaSets and Replication Controllers.
	  The replication controller helps in ensuring that a POD is re-created automatically when the application within the POD crashes. 
	  It helps in ensuring enough replicas of the application are running at all times.

	 Kubernetes provides additional support to check the health of applications running within PODs and take necessary actions through Liveness and Readiness Probes.
	  However these are not required for the CKA exam and as such they are not covered here. 
	  
	  These are topics for the Certified Kubernetes Application Developers (CKAD) exam and are covered in the CKAD course.
	 
	 

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
	 kubectl uncordon node-01 to make the node available to receive pods on it, however pods running on that node b4 it was drained dont automatically fallback. 
	 only new workloads can now be scheduled on the node.
	 
	 Important:
	 kubectl cordon node-1
	 This command alone marks a node unchedulable and dont evict pods running in the node but drain will evict pods in a node and also cordon the node.
	 
	 Therefor drain = evict pods + cordon
	 
	 whereas cordon = marks unschedulable only.
	 
	 k drain node01 --ignore-daemonsets
	 
	 
	 Important:
	 when you try to drain a node that has a pod running on it that is not part of a replicaset or not controlled by a replication controller, youll have error till you use --force which is force:
	 kubectl drain node01 --ignore-daemonsets 
	 
	 ERROR:
	 

	 controlplane ~ ➜  kubectl drain node01 --ignore-daemonsets
	 node/node01 cordoned
	 error: unable to drain node "node01" due to error:cannot delete Pods declare no controller (use --force to override): default/hr-app, continuing command...
	 There are pending nodes to be drained:
	  node01
	 cannot delete Pods declare no controller (use --force to override): default/hr-app.
	 
	 Note: This is b/c once the node is drainned that pod that is not controlled by replicaset will be deleted and not come back.
	 so k8s impliments that restrictions and to continue you'll have to use the --force options.
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
	   Backup of the resources in your cluster can be done by querying the kube-apiserver by running
	   
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
		 
		 When restoring an etcd cluster using `etcdctl snapshot restore`, you generally do not need to specify the `--cert`, `--key`, and `--cacert` options 
		 because the etcd server is typically not running when you are performing a snapshot restore. The `--endpoints` option is also not necessary 
		 in this context because the etcd server is not running.

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
			 
			 
			 What is the default data directory used in the ETCD datastore used in cluster1?
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
						
						IMPORTANT:
						COPY FROM ONE SERVER TO ANOTHER.
						YOU HAVE TO BE IN THE DESTINATION SERVER.
						1. Take a backup in the specified context, move back to the student node and run an scp command frm there..
						2. When you want to restore, you copy the back from the student node to the context u want to restore and ssh to the context and run the restore..
						
						scp cluster1-controlplane:/opt/snapshot.db /opt
						or
						to copy from pwd to another server
						
						scp /opt/snapshot.db     etcd-server:/root
						locationofsnapshot            <destination-server/node>:<path to save it>
						
						Secure copy from where or which server cluster1-controlplane
						from what source or path to the file? :/opt/snapshot.db
						to what destination? /opt
						
						IMPORTANT:
						2. How does the api-server communicate with the etcd?
						It uses the etcd server url https://127.0.0.1:2379 in a stacked etcd but for external etcd, the ip will change, it will be the ip of the external etcd server.
						
						Important:
						Youll always save snapshot in a safe location, so if workloads goes down in a specific server, you scp the snapshot to the server and restore the server using the backup file..
						
						
						
						
						
						Security:
						-----------------------
						
						Kubernetes primitives..
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
						How can we limit/restrict communication between pods in the cluster?, we use network policy to do this.
						
						
						
						Authentications:

						Article on Setting up Basic Authentication
						Setup basic authentication on Kubernetes (Deprecated in 1.19)

						    Note: This is not recommended in a production environment. This is only for learning purposes.
							Also note that this approach is deprecated in Kubernetes version 1.19 and is no longer available in later releases

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
						apiserver.crt and apiserver.key
						
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
						
						6. The kube-proxy is another component who's a client to the kube-apiserver, it interacts with the kube-apiserver to get updates to changes in service configurations, 
						kube proxy needs to be aware
						when services are created, updated, or deleted, 
						kube proxy needs to update its network rules accordingly to ensure that traffic is properly routed to the correct service endpoints. 
						To acheive this it watches the kubernetes API SERVER for changes in configuration.
						so we generate a set of certificate for it to communicate with the apiserver.
						kube-proxy.crt and kube-proxy.key
						
						
						7. The admin user who will be accessing the cluster using the kubectl utility tool, needs a pair of certificate to interacts with the kube-apiserver.
						  so we generate a set of certificate for it communicate with the apiserver.
						  admin.crt and admin.key
						  
						 8.  These various Certificates needs to be signed by the CA.So we generate a set of certificate for CA.
						 We called root certificate, ca.crt and ca.key
						 
						 
						 Important: You can have a diff CA which is not the one used for the other k8s component to sign the etcd certificates. 
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
						1. We generate key for the scheduler.
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
						
						
						NOW WE HAVE CREATED CERTIFICATE FOR THE KUBE-APISERVER.
						The kube-apiserver is the most popular component in the kubernetes cluster.
						Everyone talks to the kube-apiserver, every operations goes through the kube-apiserver, anything moving in the cluster the apiserver knows about it.
						You need information, you talk to the apiserver.
						Therefore, it goes by many names and aliases, its known as the kube-apiserver, many call it kubernetes.
						For alot of people who dont know what goes on under the hood in kubernetes, the apiserver is kubernetes. 
						some call it kubernetes.default, some kubernetes.default.svc, some kubernetes.default.svc.cluster.local
						
						In most cases, it is also refferred to as by the IP.. i.e The IP address of the host or the pod running the kube-apiserver.
						
						All these names most be present in the certificate generated for the kube-apiserver.
						This names should be passed in the  common Name (CN) "/CN=kube-apiserver" while generating the csr. 
						So anyone connecting to the kube-apiserver using these known names can reach it or establish a valid connection.
						
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
					
					1. We generate key for the kube-apiserver.
					openssl genrsa -out apiserver.key 2048
					output apiserver.key
					
					2. We Create a CSR.
					openssl req -new -key apiserver.key -subj "CN/kube-apiserver" -config openssl.cnf -out apiserver.csr
					output apiserver.csr
					
					3. We sign the CSR using the CA KEY AND THE CA CERTIFICATE and generate a certificate for the apiserver:
					
					openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key \
					    -CAcreateserial -out apiserver.crt -days 1000 \
					    -extensions v3_req -extfile openssl.cnf 
	     
						output apiserver.crt
					
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
						
						
						
						

						View Certificate Details::::
						https://kubernetes.io/docs/tasks/administer-cluster/certificates/
						
						command:
						  openssl req  -noout -text -in ./server.csr
						  
						  This will be dependent on how your cluster was setup.
						  If you deployed your cluster the hardway then you will have to create the entire certificate by yourself.
						  If the cluster was deployed using the kubeadm tool, kubeadm sets up the entire certificates for you as they run in pods.
						  Its important to know this in other to determine where to look for the certificates.
						  
						  Viewing the kube-apiserver certificates...
						  
						  cat /etc/kubernetes/manifests/kube-apiserver.yaml
						  
						  Check the command option, it has the commands used to start the kube-apiserver.
						  Identify the individual certificates used by the apiserver. View it and understand it in details...
						  RUN:
						  
						  openssl X509  -in <pathto the crt file> -noout -text
  						View Certificate Details::::
  						https://kubernetes.io/docs/tasks/administer-cluster/certificates/
						
  						command:
  						  openssl req  -noout -text -in ./server.csr
						  
						  
						  Toubleshooting:
						  
						  Inspect service logs:
						  
						  journalctl -u etcd-service -l ---> Use this to view system logs if you configured your certificate using native services.
						  
						  If your cluster is deployed using kubeadm tool.
						  RUN:
						  kubectl logs <pod-name>
						  
						  Sometimes if the kube-apiserver is down, the kubectl command will not work.
						  You have to go one level down to troubleshoot using (docker ps -a or crictl ps -a) depending on the CNI installed in the cluster.
						  docker container ls
						  docker container logs <containerID>
						  crictl logs <containerID>
						  https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/#example-crictl-commands
						  
						  
						  
						  ISSUE:
						  k get pods
						  Error from server (Timeout): the server was unable to return a response in the time allotted, but may still be processing the request (get pods)
						  
						  PROBLEM:
						  The kubectl command stopped working, someone modified the /etc/kubernetes/manifests/etcd.yaml file.
						  
						  the cert file was modified..
						  
						  ISSUE:

						  controlplane ~ ➜  k get pods
						  Get "https://controlplane:6443/api/v1/namespaces/default/pods?limit=500": dial tcp 192.23.158.9:6443: 
						  connect: connection refused - error from a previous attempt: read tcp 192.23.158.9:43784->192.23.158.9:6443: read: connection reset by peer
						  
						  Solution:
						  Run 
						  crictl ps -a ---> check the exited container, the apiserver container and check the logs.
						  crictl logs <containerid>
						  
						  LOGs output:

						  "Type": 0,
						  "Metadata": null
						}. Err: connection error: desc = "transport: authentication handshake failed: tls: failed to verify certificate: x509: certificate signed by unknown authority"
						E0927 22:58:45.113664       1 run.go:74] "command failed" err="context deadline exceeded"
						  
						 
						  
						  

						
						CERTIFICATE API:
						Lets say as the only admin in the cluster, someone joins my organization. Iam tasked with granting the user access to the cluster.
						I ask the user to generate a key using the openssl genrsa -out jane.key 2048
						
						The user also generates a certificate signing request, 
						2. We Create a CSR.
					    openssl req -new -key jane.key -subj "CN/=jane" -out jane.csr
					     output jane.csr
						 
						 She then sends me this CSR, as the only one with access to the cluster where the CA KEY AND CA cert are i use these to sign the users CSR and send back the certificate to her
						 for an access to the cluster. This certificate has a validity period, i keep rotating the certificate each time it expires by asking her to generate a new one and i sign it with the CA
						 
						 Each time a new user joins again, the process is repeated and when the number of users increases this becomes a tidious job..
						 
						 The Certificate API, allows us to automate the process of certificate approval and deny.
						 It allows us to secure the CA servers which is a safe storage of the CAkey and CA cert used in signing the csr.
						 There4 the CA server is nothing but a server where we safe store the CAkey and CA certificates.. 
						 Anyone with access to this server can create as many users as they want and with any permission they want.
						 

This is why we need to secure the CA server..
						 
						
Automating CERTIFICATE SIGNING:
------------------------------ 
Kubernetes has a certificate API, with certificate api you can send csr to the CA server and all administrator will see this as pending csr in the cluster.
						 
Process: 
The new user generates a set of keys, create a csr and send the csr to me the admin user.
The admin user creates a CertificateSingingRequest object. In this CSR object, the details of the new users csr is entered into it.
Things like the encoded csr.
						 
 Example:
			             apiVersion: certificates.k8s.io/v1
						 kind: CertificateSigningRequest
						 metadata:
						   name: jane-csr
						 spec:
						   request: <base64_encoded_csr>
						   signerName: kubernetes.io/kube-apiserver-client
						   usages:
						   - client auth
						   
						   ---
						   apiVersion: certificates.k8s.io/v1
						   kind: CertificateSigningRequest
						   metadata:
						     name: jane-csr
						   spec:
						     request: <base64_encoded_csr>
						     signerName: kubernetes.io/kube-apiserver-client
						     usages:
						     - client auth
						   subject:
						     commonName: jane
						     organization:
						     - system:masters
						     - my-group
						   
						 
						 
						  Important: The admin user creates this using the kubectl commands, the requests can be reviewed, approved, deny using the kubectl commands.
						  The certificate is then extracted and shared with the user for authenticating into the k8s cluster....
						  
						  
						  HOW IS IT DONE?????
						  
						  1. user generates key:
						  openssl genrsa -out jane.key 2048
						  
						  2. user creates a csr using openssl command
						  openssl req -new -key jane.key -sub "/CN=jane" -out jane.csr
						  
						  She sends the csr to the admin user.
						  
						  3. The admin user creates a csr api object as shown below.
						  
 						 apiVersion: certificates.k8s.io/v1
 						 kind: CertificateSigningRequest
 						 metadata:
 						   name: jane
 						 spec:
 						   request: <base64_encoded_csr>
 						   groups: <The group the user belongs to in linux eg system:masters or system:authenticated, theyre all list and should have -
 						   usages:  ---> The use of the certificate, just for auth or gital signature or key encipherment. They all list and should have -, ?
 						   - client auth
						
				
						https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#certificate-signing-requests
						
						Some points to note:

						    usages has to be 'client auth'

						    expirationSeconds could be made longer (i.e. 864000 for ten days) or shorter (i.e. 3600 for one hour)

						    request is the base64 encoded value of the CSR file content. You can get the content using this command:
							
							cat jane.csr | base64 | tr -d "\n"
							The command you provided is used to encode a Certificate Signing Request (CSR) in base64 format and remove newline characters from the resulting encoded string. 
							Here's how it works step by step:

							1. `cat jane.csr`: This part of the command reads the contents of the file `jane.csr` and outputs it to the standard output.

							2. `|`: This pipe character takes the output from the previous command and passes it as input to the next command.

							3. `base64`: This command encodes the input data in base64 format, making it suitable for use in various data transmission and storage purposes.

							4. `|`: Another pipe character to pass the base64-encoded data to the next command.

							5. `tr -d "\n"`: This `tr` command is used to delete (remove) newline characters (`\n`) from the input data.

							When you run this entire command, it will read the contents of the `jane.csr` file, encode it in base64, 
							and then remove any newline characters from the base64-encoded output. The result will be a single, continuous base64-encoded string without line breaks.
							
							
						
							Approve the CertificateSigningRequest

							Use kubectl to create a CSR and approve it.

							Get the list of CSRs:
							
							Commands:
							kubectl get csr
							

							Approve the CSR:

							kubectl certificate approve jane

							Get the certificate

							Retrieve the certificate from the CSR:

							kubectl get csr/jane -o yaml
							
							Important:

							The certificate value is in Base64-encoded format under status.certificate.
							
							Important:

							Export the issued certificate from the CertificateSigningRequest.

							kubectl get csr jane -o jsonpath='{.status.certificate}'| base64 -d > jane.crt
							...
							https://kubernetes.io/docs/tasks/administer-cluster/certificates/
							
							
							WHO DOES ALL OF THESE FOR US???
							All of the certificate signing operations are done by the kube-controller-manager.
							It uses controllers like CSR approving CSR signing to do all of these for us.
							
							We know that for anyone to sign certificate, they need the CA server root certificate and key.
							Does the controller manager have these keys?
							
							If you cat /etc/kubernetes/manifests/kube-controller-manager youll notice an option in the kube-controller-manager called 
							--cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
							--cluster-signing-key-file==/etc/kubernetes/pki/ca.key
							
							This options also enables the contoller-manager to sign/approve/deny a csr.. thus automating the certificate creation process.
							
							
							LAB:
							KubeConfig
							
							The admin user makes an api call using the curl command.
							
							curl https://my-kube-playgroud:6443/api/v1/pods \
							--cert amdin.crt \
							--key admin.key \
							--cacert ca.key 
							
							HOW CAN YOU DO THIS USING THE kubectl utility?
							
							You can specify it using kubectl utility by running..
							
							kubectl get pods \
							--server my-kube-playgroud:6443 \
							--client-certificate amdin.crt \
							--client-key admin.key \
							--certificate-authority ca.key 
							
							Important:
							Typing this each time you want to make an api call to the apiserver is a tidious tasks.
							You then move this into a file called kubeconfig file..
							
							Create a file called config: 
							
							--server my-kube-playgroud:6443 \
							--client-certificate amdin.crt \
							--client-key admin.key \
							--certificate-authority ca.key 
						
							In the users home directory which is $HOME/.kube/config
							
							This is the default place where the kubectl command line utility goes first to check for the kubeconfig file b4 performing your actions.
							
							Important:
							You have not been specifying the cacert,key,cert options when calling the kubernetes api b/c theyre already in the .kube folder and kubectl check that folder 
							and uses the file in there.
							
							The config file or the kubeconfig file is in a specific format:
							
							https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
							
							Example:
							Define clusters, users, and contexts
							
							kubeconfig or config file has 3 top fields that are required.
							
							clusters, contexts and users. This top fields are arrays or lists. 
							
							Suppose you have two clusters, one for development work and one for test work. In the development cluster, 
							your frontend developers work in a namespace called frontend, and your storage developers work in a namespace called storage. In your test cluster, 
							developers work in the default namespace, or they create auxiliary namespaces as they see fit. Access to the development cluster requires authentication by certificate.
							 Access to the test cluster requires authentication by username and password.

							Create a directory named config-exercise. In your config-exercise directory, create a file named config-demo with this content:
							
Important: To see only the configuration information associated with the current context, use the --minify flag.

kubectl config --kubeconfig=config-demo view --minify

This link tells you all you need about the kubeconfig --; https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
							
							
							

							API Groups:
							https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/
							https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/
							The kubernetes api are divided into 2 groups, the core api and the named api.
							The core api inlcudes the pods,cm,secrets,volume,job,
							For the named apis we have metrics,logs,healthz etc and theyre futher divided into deplyments which are resources etc
							
							
							Example
							
							curl https://my-kube-playgroud:6443/api/v1/pods \
							--cert amdin.crt \
							--key admin.key \
							--cacert ca.key 
							
							we are intrested in the /api and /v1 which is the /api and /version we also have /metrics /logs /healthz /apis
							
							The version api is for viewing the version of the cluster.
							The metrics api is for the metrics of the cluster, the logs for integrating third party apps, the healthz is for the healthz.
							
							The apis responsible for the functionality of the cluster are the /api /apis
							
							Authorization:
							So far we have talked about authentication..
							What is authorization? 
							Once you have been authenticated, what you can do defines authorization...
							As an admin of the cluster, you're able to create and delete resources in the kubernetes cluster.
							As the workloads grows, and new users join your org.. You wont give them the same access to yours, youll limit their access based on their tasks in the cluster.
							
							SAY FOR A:
							Developer, Bot or serviceaccount you will not grant these entities the access to delete nodes and modify certain resources in the cluster.
							Authorization granted to them, defines the actions they can take in the k8s cluster. 
							You might decide to limit them to a certain namespace as that is where their operation is needed.
							Authorization enables you do all of these......
							
							Authorization Mechanism:
							There are diff authorization mechanism, RBAC,ABAC, NODE, WEBHOOK.
							RBAC: This is the more better way of granting authorization to users of your cluster.
							With RBAC, you define a role for groups say "developers" and associate all the developer to that role.
							Similarly, you can create a role for security users <security1> give it the right permission and associate the security users into it.
							Important: Whenever theres a change to be made in the users permissions or role, we modify the role and the changes will reflect on all users..
							 
							You can also define a role to a specific user and add the user to that policy and each time you need to make a modification on the users permission, you update the policy and it ref
							
							DEEPDIVE INTO RBAC:
							
							We create a sample Role.
							example:
							
							apiVersion: rbac.authorization.k8s.io/v1
							kind: Role
							metadata:
							  namespace: default
							  name: pod-reader
							rules:
							- apiGroups: [""] # "" indicates the core API group
							  resources: ["pods"]
							  verbs: ["create", "get", "watch", "list"]
  							- apiGroups: [""] # "" indicates the core API group
  							  resources: ["configmaps"]
  							  verbs: ["create"]
							  
							  each rules has 3 sections: remember rules is a list.
							  apiGroups --> name of apiGroups you want to grant it access granted to users/groups
							  resources --> Resources you want to give access to eg ["pods"]
							  verbs --> Actions to be permformed by the users/groups
							  
							  Important: 
							  For the core apiGroups you leave the apiGroups section as empty/blank [""]
							  For the named apiGroups provide the name of their apiGroups.
							  
							  We create the role, by running kubectl create -f <path-to-the-file>
							  
							  NEXT:
							  We link the user/users/groups/sa to that role we have created.. To do this we create another object called RoleBinding...
							  
							  example: 
							  apiVersion: rbac.authorization.k8s.io/v1
							  # This role binding allows "jane" to read pods in the "default" namespace.
							  # You need to already have a Role named "pod-reader" in that namespace.
							  kind: RoleBinding
							  metadata:
							    name: read-pods
							    namespace: default
							  subjects:
							  # You can specify more than one "subject"
							  - kind: User
							    name: dev-user # "name" is case sensitive
							    apiGroup: rbac.authorization.k8s.io
							  roleRef:
							    # "roleRef" specifies the binding to a Role / ClusterRole
							    kind: Role #this must be Role or ClusterRole
							    name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
							    apiGroup: rbac.authorization.k8s.io
							 
								Important:
								The subjects, is a list or array and its on the subject we provide the User the role we created is for, 
								this is how u link the role to a user/group/sa. You can specify multiple users by using:
								
  							  subjects:
  							  # You can specify more than one "subject"
  							  - kind: User
  							    name: first-user # "name" is case sensitive
  							    apiGroup: rbac.authorization.k8s.io
    						  - kind: User
    							name: second-user # "name" is case sensitive
    							apiGroup: rbac.authorization.k8s.io
      						  - kind: User
      							name: third-user # "name" is case sensitive
      							apiGroup: rbac.authorization.k8s.io
								
								......................
								Also in the kind section instead of User, you can provide Group, ServiceAccount
								
								Important:
								the roleRef section is where we provide the details of the role we created earlier...
								
								Very Important:
								The role and role binding objects falls under namespaces..
								If you dont specify a namespace in the role and rolebinding objects, it will use the default namespace.
								Which means the users associated to that role will only manage resources in the default namesapce.
								Under the metadata section you can specify you can specify a namespace to grant the users access to a defined namespace.
								
								AS A USER IN THE CLUSTER HOW CAN I KNOW IF I CAN MANAGE CERTAIN RESOURCES???
								----------------------------------------------------------------------------
								
								RUN:
								
								kubectl auth can-i create deployments
								kubectl auth can-i create pods
								kubectl auth can-i delete nodes
								
								This will tell you if you have the permission or not..
							  
								AS AN ADMIN, YOU WOULD LIKE TO TEST IF THE PERMISSION YOU GRANTED ON A USER IS OK WITHOUT AUTHENTICATING WITH THE USER CERT FILE,KEY AND CACERT.
								
								Lets say the user is dev-user.
								
								RUN:
								
							  kubectl auth can-i create deployments --as dev-user
							  Youll receive no b/c dev-user does not have the permission.
							  The permission is only to create pods
							  
							   kubectl auth can-i create pods --as dev-user
							   output: yes
							   
							   kubectl auth can-i create pods --as dev-user --namespace test
							   output: no, b/c the permission is for default namespace...
							   
							   
							   NOTE: You limit users access to a specific resource in the cluster.
							   Say we have orange pods and blue pods running in the cluster in the defined namespace and you want to limit a user access to a specific pod.
							   In the role definition file, add a filed called.
							   resourceNames under the rules and give the value or name of the pod or resource.
							   eg.
							   
							   resourceNames: ["blue", "black"]
							   
							   
							   ---sample role
 # Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
 # reopened with the relevant failures.
							   #
							   apiVersion: rbac.authorization.k8s.io/v1
							   kind: Role
							   metadata:
							     creationTimestamp: "2023-09-30T15:40:58Z"
							     name: developer
							     namespace: blue
							     resourceVersion: "2865"
							     uid: a612c6ea-dd90-4734-b0d4-51e5006a6770
							   rules:
							   - apiGroups:
							     - ""
							     resourceNames:
							     - blue-app
							     - dark-blue-app
							     resources:
							     - pods
							     verbs:
							     - get
							     - watch
							     - create
							     - delete
								 
								 Important: Roles and Rolebindings are namespace scoped. If you dont specify a namespace on them, they will use the default namespace..
								 Resources like nodes cant be categorized as namespaced scopped, theyre cluster scope resources.
								 
								 There4 we can categorize resources as namespace scoped resources and clusterwide resources..
								 
								 namespaced scoped resources are:
								 Services, pvc,deployments,rs,rc,endpoints,events,configmaps,pods,jobs,secrets, roles and rolebindings
								 
								 Cluster Wide Resources:
								 clusterRole,ClusterRoleBinding,CertificateSigningRequest,pv,namespaces,nodes
								 
								 To get the full lists of namespace scoped resources and cluster wide resources RUN:
								 kubectl api-resources --namespaced=true  ---> Lists namespace scoped Resources
								  kubectl api-resources --namespaced=false ---> lists ClusterWide Resources
								  
								  ALSO RUN TO GET THE apiGroups of a resource run:
								   kubectl api-resources --namespaced=true
								    kubectl api-resources --namespaced=false
									
									Check the APIVERSION FILED:
									The core groups has v1 remove the v1 and use [""] which means empty or blank.
									The named Groups eg. deployments has  apps/v1  remove the /v1 and use the first part which is ["apps"]
									The same goes for others in the list..
									
									command to list without headers:
									k get clusterrole -A --no-headers | wc -l
									
									
									Examples:
								    cat michelle.yaml 
									
									
								   apiVersion: rbac.authorization.k8s.io/v1
								   kind: ClusterRole
								   metadata:
								     name: storage-admin
								   rules:
								   - apiGroups: [""]
								     #
								     # at the HTTP level, the name of the resource for accessing ConfigMap
								     # objects is "configmaps"
								     resources: ["persistentvolumes"]
								     verbs: [ "get", "create", "delete"]
								   - apiGroups: [storage.k8s.io]
								     #
								     # at the HTTP level, the name of the resource for accessing ConfigMap
								     # objects is "configmaps"
								     resources: ["storageclasses"]
								     verbs: [ "get", "create", "delete"]
								   ---
								   apiVersion: rbac.authorization.k8s.io/v1
								   # This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
								   kind: ClusterRoleBinding
								   metadata:
								     name: michelle-storage-admin
								   subjects:
								   - kind: User
								     name: michelle # Name is case sensitive
								     apiGroup: rbac.authorization.k8s.io
								   roleRef:
								     kind: ClusterRole
								     name: storage-admin
								     apiGroup: rbac.authorization.k8s.io
									 
									 

									 VERY VERY IMPORTANT:
As you know, there are certain groups that exists in the kubernetes cluster and examples of such groups include system:masters.
Note that once you create a key and csr for a user and sign that CSR using the CA key and CAcert to get the user authenticated to the cluster.
If in creating the csr you added the user to OU system:masters, and when granting authorization to the user using RBAC, 
you create a clusterrole say to create, delete, get pods and deployments
and binds its using clusterrolebinding and in the subject you specify kind as Group and name as system:masters b/c 
that user was added to the group system:masters when generating the 
csr will he/she inherite the clusterrole associated to that group system:masters???
									 
Can we also add a user to a non existing OU in kubernetes when generating CSR for authentication and use that group while creating RBAC to grant permission?? 
The answer is YES..
									 
									 
 SOLUTION:
									 
In Kubernetes, adding a user to the `system:masters` group during the creation of a certificate signing request (CSR) and then binding that group to a ClusterRole using
a ClusterRoleBinding will grant the user the permissions associated with that ClusterRole. So, in your scenario:

 1. You create a user and generate a CSR.
2. During CSR creation, you add the user to the `OU system:masters`.
3. You sign the CSR using the CA key and CA certificate to authenticate the user to the cluster.
4. You create a ClusterRole that allows actions like creating, deleting, getting pods and deployments.
5. You create a ClusterRoleBinding that binds the `system:masters` group to the ClusterRole.

In this case, the user, because they are part of the `system:masters` group, will inherit the permissions associated with the ClusterRole. 
This is because Kubernetes RBAC allows you to grant permissions to groups just like you would to individual users. By binding the `system:masters` group to the ClusterRole, 
any user who is part of that group will have the permissions defined in the ClusterRole.

Here's an example of what the ClusterRole and ClusterRoleBinding might look like in YAML:

									 ```yaml
									 apiVersion: rbac.authorization.k8s.io/v1
									 kind: ClusterRole
									 metadata:
									   name: my-cluster-role
									 rules:
									 - apiGroups: [""]
									   resources: ["pods", "deployments"]
									   verbs: ["create", "delete", "get"]

									 ---

									 apiVersion: rbac.authorization.k8s.io/v1
									 kind: ClusterRoleBinding
									 metadata:
									   name: my-cluster-role-binding
									 subjects:
									 - kind: Group
									   name: system:masters
									   apiGroup: rbac.authorization.k8s.io
									 roleRef:
									   kind: ClusterRole
									   name: my-cluster-role
									   apiGroup: rbac.authorization.k8s.io
									 ```

									 In this example, the `my-cluster-role` grants permissions for creating, deleting, and getting pods and deployments within the cluster. The `my-cluster-role-binding` 
									 binds the `system:masters` group to the `my-cluster-role`, so any user who is part of the `system:masters` group will inherit these permissions.
									 
									 Important: 
									 Always use help. e.g
									 kubectl create clusterrole --help
									 
									 

									 Service Accounts:
									 https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
									 
									 ServiceAccounts are used for authenticating machines,pods or external application into the kubernetes cluster.
									 You create a service account and use the TokenRequest API to create a token with time bound for the service account.
									 When that Service account or Token gets associated to a resource,machine or external apps that requires it they get authenticated into the cluster..
									 
									 NB: Authentication is differnt from authorization... You get authenticate first and then your role in the cluster gets defined using authorization mechanism.
									 
									 To create a Kubernetes ServiceAccount and generate a token with an expiration using the TokenRequest API, you can follow these steps:

									   1. Create a ServiceAccount:
										 
										 apiVersion: v1
										 kind: ServiceAccount
										 metadata:
			   						   name: my-serviceaccount
									   
										   Save this YAML to a file, e.g., serviceaccount.yaml, and apply it using kubectl apply -f serviceaccount.yaml.

									2. Create a TokenRequest with an expiration time. You can specify the expiration time in seconds from the current time. 
											For example, to generate a token that expires in 1 hour (3600 seconds):
									
											apiVersion: authentication.k8s.io/v1
											kind: TokenRequest
											metadata:
											  name: my-tokenrequest
											spec:
											  audience: "api"
											  expirationSeconds: 3600
											  token: "" # Leave this empty
											  
							3. Create a TokenRequest and specify the serviceAccountName in the spec section to associate it with the desired ServiceAccount:
							apiVersion: authentication.k8s.io/v1
							kind: TokenRequest
							metadata:
							  name: my-tokenrequest
							spec:
							  audience: "api"
							  expirationSeconds: 3600
							  serviceAccountName: my-serviceaccount # Associate with the desired ServiceAccount
							  token: "" # Leave this empty
							
							  This way the tokenRequest API gets associated to a service account.
							  
							  -------------------------------------------
							  
							  Doing this imperatively:
							  1. kubectl create serviceaccount my-serviceaccount
							  2. kubectl create token my-serviceaccount <tokenname>
							  you can ignore token name
							  
							  This creates a sa and a token for that sa
											  
											  Save this YAML to a file, e.g., tokenrequest.yaml, and apply it using kubectl apply -f tokenrequest.yaml.

											      Wait for a few moments to let the TokenRequest create a TokenRequest object in your cluster.
												  
						Retrieve the generated token using kubectl:
						
						kubectl get tokenrequests.authentication.k8s.io my-tokenrequest -o jsonpath='{.status.token}'
						
						This command will output the generated token, which will expire after the specified duration (in this example, 1 hour).
						
						
				4. To mount a token from a ServiceAccount as a projected volume in a Kubernetes pod, you can follow these steps:
				
				apiVersion: v1
				kind: Pod
				metadata:
				  name: my-pod
				spec:
				  serviceAccountName: my-serviceaccount  # Replace with your ServiceAccount name
				  volumes:
				    - name: token-volume
				      projected:
				        sources:
				          - serviceAccountToken:
				              path: my-token   # Path within the pod where the token will be mounted
				              expirationSeconds: 3600  # Set this to the same value you used for token expiration
				  containers:
				    - name: my-container
				      image: your-image
				      volumeMounts:
				        - name: token-volume
				          mountPath: /var/run/secrets/kubernetes.io/serviceaccount
						  
						  
						  
						  In the above YAML:

						      Replace my-serviceaccount with the name of the ServiceAccount from which you want to mount the token.
						      Adjust the path and expirationSeconds as needed.
						      Ensure the mountPath in volumeMounts matches the path specified in the projected volume.

						      Save the Pod YAML to a file, e.g., pod-with-token.yaml.

						      Apply the Pod YAML to create the pod:
							  kubectl apply -f pod-with-token.yaml
					
							  IMPORTANT:
							 
		This pod will be created with a volume named token-volume that contains the projected token from the specified ServiceAccount. 
		The token will be mounted at the path /var/run/secrets/kubernetes.io/serviceaccount/my-token within the pod.

	   Make sure to configure your application within the pod to use this token for any Kubernetes API requests. 
	   The token will automatically be refreshed when it's close to expiration, thanks to Kubernetes' built-in token rotation mechanism.
	   
	   Ensure the mountPath in volumeMounts matches the path specified in the projected volume.
	   Does that mean the volumes path which is my-token should be the same as the VolumeMounts /var/run/secrets/kubernetes.io/serviceaccount ???????
	   
	   
	   Yes, that's correct. The `mountPath` in `volumeMounts` should match the path specified in the projected volume, which is the `path` within the `serviceAccountToken` source. In your case, both should be the same.

	   In your YAML:

	   ```yaml
	   volumes:
	     - name: token-volume
	       projected:
	         sources:
	           - serviceAccountToken:
	               path: my-token   # Path within the pod where the token will be mounted
	   ```

	   You've specified `path: my-token` in the `serviceAccountToken` source. Therefore, the corresponding `mountPath` in `volumeMounts` should be the same:

	   ```yaml
	   volumeMounts:
	     - name: token-volume
	       mountPath: /var/run/secrets/kubernetes.io/serviceaccount/my-token
	   ```

	   This configuration ensures that the token from the ServiceAccount is correctly mounted at the specified path within the pod, 
	   making it accessible to applications running inside the pod for authentication and Kubernetes API access.


	   You've specified path: my-token in the serviceAccountToken source. Therefore, the corresponding mountPath in volumeMounts should be the same:

	   yaml

	   volumeMounts:
	     - name: token-volume
	       mountPath: /var/run/secrets/kubernetes.io/serviceaccount/my-token

	   This configuration ensures that the token from the ServiceAccount is correctly mounted at the specified path within the pod, 
	   making it accessible to applications running inside the pod for authentication and Kubernetes API access.
	   
	   so both can be /var/run/secrets/kubernetes.io/serviceaccount/my-token ????
	   
	   Yes, both the `path` specified in the `projected` volume and the `mountPath` in `volumeMounts` can be set to `/var/run/secrets/kubernetes.io/serviceaccount/my-token`. 
	   In fact, this is a common and recommended practice when mounting a service account token.

	   Here's how it should look in your YAML:

	   ```yaml
	   volumes:
	     - name: token-volume
	       projected:
	         sources:
	           - serviceAccountToken:
	               path: /var/run/secrets/kubernetes.io/serviceaccount/my-token
	   ```

	   And in the `volumeMounts` section:

	   ```yaml
	   volumeMounts:
	     - name: token-volume
	       mountPath: /var/run/secrets/kubernetes.io/serviceaccount/my-token
	   ```

	   This configuration ensures consistency and clarity, making it clear that the service account token is being mounted to the standard path used for service account tokens within Kubernetes pods.
	   
	   
	   ............................................................
	   So we can then create a pod object, associate the service account and mount the token as a projected volume ???
	   
	   
	   Exactly, that's the workflow. Once you've created the `TokenRequest` associated with a specific ServiceAccount, you can create a pod object, specify the ServiceAccount you want to use  
	   for that pod, and mount the token as a projected volume in the pod. Here's a step-by-step breakdown:

	   1. Create a `TokenRequest` associated with a ServiceAccount as shown earlier.

	   2. Create a Pod YAML that uses the ServiceAccount you want and mounts the projected token volume:

	   ```yaml
	   apiVersion: v1
	   kind: Pod
	   metadata:
	     name: my-pod
	   spec:
	     serviceAccountName: my-serviceaccount # Use the desired ServiceAccount
	     volumes:
	       - name: token-volume
	         projected:
	           sources:
	             - serviceAccountToken:
	                 path: my-token # Path within the pod where the token will be mounted
	     containers:
	       - name: my-container
	         image: your-image
	         volumeMounts:
	           - name: token-volume
	             mountPath: /var/run/secrets/kubernetes.io/serviceaccount
	   ```

	   3. Apply the Pod YAML using `kubectl apply -f pod.yaml`.

	   With this setup, the pod will use the specified ServiceAccount, and the token from the associated `TokenRequest` will be mounted as a volume inside the pod.
	    You can then use this token for authentication and authorization within the cluster.

	   Ensure that the ServiceAccount used in the pod (`my-serviceaccount` in this example) has the necessary RBAC permissions to perform the actions you intend to use the token for.
	   
	   Refference:
	   ----
	   https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/#bound-service-account-token-volume
	   https://kubernetes.io/docs/concepts/storage/projected-volumes/
	   search token as a projected volume
	   the default duration for a token is 3600 but you can use --duration flag to increase the time.
	   
	   
	   Important:

	   pods is forbidden: User "system:serviceaccount:default:default" cannot list resource "pods" in API group "" in the namespace "default" 
	   
	   explain IN RBAC
	   this is in the default namespace
	   subjects:
	   - kind: system:serviceaccount
	     name: default # Name is case sensitive
		 namespace: default
	   
	   
 
 

	   Image Security:
	   ==========================
	   
	   https://kubernetes.io/docs/concepts/containers/images/
	   https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
	   
	   apiVersion: v1
	   kind: Pod
	   metadata:
	     name: private-reg
	   spec:
	     containers:
	     - name: private-reg-container
	       image: <your-private-image>
	     imagePullSecrets:
	     - name: regcred

		 kubectl create secret docker-registry <name> \
		   --docker-server=DOCKER_REGISTRY_SERVER \
		   --docker-username=DOCKER_USER \
		   --docker-password=DOCKER_PASSWORD \
		   --docker-email=DOCKER_EMAIL
		   
		   OR
		   
		   kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
		   
		   

Pre-requisite – Security in Docker
Configure a Security Context for a Pod or Container
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/


apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  volumes:
  - name: sec-ctx-vol
    emptyDir: {}
  containers:
  - name: sec-ctx-demo
    image: busybox:1.28
    command: [ "sh", "-c", "sleep 1h" ]
    volumeMounts:
    - name: sec-ctx-vol
      mountPath: /data/demo
    securityContext:
      allowPrivilegeEscalation: false

kubectl exec -it security-context-demo-2 -- sh

Important:
By default, the process in a container runs as a root user.
Also if you set a securitycontext of runAsUser: 0, the processes in the container also runs as a root user.
You can also use the capabilities options to add more capability..




Network Policies:

Note that Ingress or Egress isolations comes into effect if you have Ingress or Egress in the PolicyTypes:
If You do not specify Ingress or Egress in the policytypes there wont be any isolation of traffic.

Example:

We have 3 pods, a webserver serving the frontend on port 80, an api pod running on 5000 at the backend and a db pod on 3306.
The web app pods talks to the api pod and the api pod talks to the db pod and fetches data from the DB pod and retruns it back to the user.
Now: We want to ensure that the traffic from the enduser on 80 via the web application do not go directly to the db pod..

We want a situation whereby our db pod can only accept Ingress traffic from the api pod on port 3306 only.

We will use labels and selector concept..
We will use NetworkPolicy

We create a networkPolicy with policytypes Ingress..
First we specify the podSelector and matchLabels options and add the label of the pod traffic will go to.
The policyTypes we specify Ingress or Egress and enter the label of the pod we want traffic to come from.

example:

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
spec:
  podSelector:
    matchLabels:
      app: db
  policyTypes:
  - Ingress   # Specify the policy type as Ingress.. This means you are isolating Ingress traffic, you are allowing ingress traffic only from pods that has labels app: api
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
    ports:
    - protocol: TCP
      port: 3306
	  Important, not all network solutions supports NetworkPolicy, this is dependent on the network solutions you are using in your cluster.
	  
	  supports networkpolicy:
	  Romana
	  Weave-net
	  Calico
	  kube router
	  
	  non support:
	  Flannel
	  NB: Even with a solution that does not support networkpolicy, you can still create the object, but the networkpolicy cant be enforced...
	  Also note that youll not get an error msg saying that the solution does not not support network policy.
	  
https://kubernetes.io/docs/concepts/services-networking/network-policies/

....

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - ipBlock:
            cidr: 172.17.0.0/16
            except:
              - 172.17.1.0/24
        - namespaceSelector:
            matchLabels:
              project: myproject
        - podSelector:
            matchLabels:
              role: frontend
      ports:
        - protocol: TCP
          port: 6379
  egress:
    - to:
        - ipBlock:
            cidr: 10.0.0.0/24
      ports:
        - protocol: TCP
          port: 5978

		  ...

So, the example NetworkPolicy:

    isolates role=db pods in the default namespace for both ingress and egress traffic (if they weren't already isolated)

    (Ingress rules) allows connections to all pods in the default namespace with the label role=db on TCP port 6379 from:
        any pod in the default namespace with the label role=frontend
        any pod in a namespace with the label project=myproject
        IP addresses in the ranges 172.17.0.0–172.17.0.255 and 172.17.2.0–172.17.255.255 (ie, all of 172.17.0.0/16 except 172.17.1.0/24)

    (Egress rules) allows connections from any pod in the default namespace with the label role=db to CIDR 10.0.0.0/24 on TCP port 5978
	
	NB: The namespaceselector when used in a networkpolicy determines which namespace traffic is allowed to reach a pod...
	When use for instance as:
	
1. example, This uses AND operator concept. This means a pod in a namespace labled user:alice and pods with labels role:client
    ...
     ingress:
     - from:
       - namespaceSelector:
           matchLabels:
             user: alice
         podSelector:
           matchLabels:
             role: client
This policy contains a single from element allowing connections from Pods with the label role=client in namespaces with the label user=alice. 
...
Yes, you are correct. The example you provided uses the AND operator concept in Kubernetes NetworkPolicy.

In this example, the NetworkPolicy is specifying that it allows Ingress traffic to pods with a particular set of labels:

- The Ingress rule allows traffic from pods that meet both of the following conditions:
  1. They are in a namespace labeled `user: alice`.
  2. They have labels with `role: client`.

Both conditions must be met for traffic to be allowed. This is effectively using the AND operator, meaning that both conditions need to be true for the rule to permit traffic.

So, only pods in namespaces with the label `user: alice` AND having the labels `role: client` will be allowed to send Ingress traffic according to this NetworkPolicy.




2. example: This uses OR operator, this or that.. any one of the rules that matches works

...
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        user: alice
  - podSelector:
      matchLabels:
        role: client
...

It contains two elements in the from array, and allows connections from Pods in the local Namespace with the label role=client, or from any Pod in any namespace with the label user=alice.

When in doubt, use kubectl describe to see how Kubernetes has interpreted the policy.
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
    - Egress
  egress:
    - to:
      - podSelector:
          matchLabels:
            name: payroll
        podSelector:
          matchLabels:
            name: mysql
      ports:
        - protocol: TCP
          port: 8080
        - protocol: TCP
          port: 3306
		  
This corrected NetworkPolicy allows egress traffic from pods labeled name: internal to pods labeled name: payroll and name: mysql on ports 8080 and 3306.




EXTRA:
......

Kubectx and Kubens – Command line Utilities


Throughout the course, you have had to work on several different namespaces in the practice lab environments. In some labs, you also had to switch between several contexts.

While this is excellent for hands-on practice, in a real “live” kubernetes cluster implemented for production, there could be a possibility of often switching between a large number of namespaces and clusters.

This can quickly become and confusing and overwhelming task if you had to rely on kubectl alone.

This is where command line tools such as kubectx and kubens come in to picture.

Reference: https://github.com/ahmetb/kubectx

Kubectx:

With this tool, you don’t have to make use of lengthy “kubectl config” commands to switch between contexts. This tool is particularly useful to switch context between clusters in a multi-cluster environment.

Installation:

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx

Syntax:

To list all contexts:

kubectx

To switch to a new context:

kubectx

To switch back to the previous context:

kubectx –

To see the current context:

kubectx -c

Kubens:

This tool allows users to switch between namespaces quickly with a simple command.

Installation:

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

Syntax:

To switch to a new namespace:

kubens

To switch back to previous namespace:

kubens –


alias k=kubectl



NEW TOPIC:
Storage – Section Introduction:

https://kubernetes.io/docs/concepts/storage/


Let’s talk about CNI,CRI and CSI in Kubernetes 

Certainly! In Kubernetes, CNI, CRI, and CSI are essential components that play distinct roles in container orchestration. Let me explain each of them:

1. **CNI (Container Network Interface):**
   - CNI is responsible for configuring network connectivity for containers within a Kubernetes cluster.
   - It defines a standardized interface that network plugins can use to set up and manage networking for pods.
   - Various CNI plugins, such as Calico, Flannel, and Weave, can be used to provide networking solutions tailored to specific use cases and requirements.

2. **CRI (Container Runtime Interface):**
   - CRI acts as an abstraction layer between Kubernetes and container runtimes (e.g., Docker, containerd).
   - It allows Kubernetes to work with different container runtimes without needing code changes in the Kubernetes core.
   - Popular CRI implementations include Docker's CRI plugin and containerd.

3. **CSI (Container Storage Interface):**
   - CSI is responsible for provisioning and managing storage volumes for containers and pods in a Kubernetes cluster.
   - It enables the use of various storage drivers and backends, including cloud storage, NAS, and local volumes.
   - CSI allows for dynamic provisioning of storage, snapshot management, and attaching/detaching volumes from pods.

In summary, CNI manages container networking, CRI handles communication between Kubernetes and container runtimes,
 and CSI manages storage for containers. These components work together to provide a flexible and extensible platform for deploying and managing containers in Kubernetes clusters.
 
 
 The CSI is a universal standard that all storage vendors or storage solutions must follow to be able to work with any container orchestrator? 
 
 Yes, the Container Storage Interface (CSI) is designed to be a universal standard that storage vendors and solutions can follow to work with any container orchestrator, not just Kubernetes. 
 While CSI was initially developed with Kubernetes in mind, it has since gained widespread adoption in the container ecosystem, making it a de facto standard.

 The key advantages of CSI as a universal standard are:

 1. **Portability:** CSI allows storage vendors to create plugins that work across different container orchestrators, including Kubernetes, Docker Swarm, and others. 
 This portability enables users to choose the orchestrator that best suits their needs while still using their preferred storage solutions.

 2. **Flexibility:** CSI provides a consistent way to interact with storage systems, making it easier to integrate various storage solutions into containerized environments. 
 This flexibility is crucial for enterprises with diverse storage requirements.

 3. **Ecosystem Support:** The adoption of CSI by a wide range of storage providers and the container community has led to a thriving ecosystem of CSI-compliant plugins. 
 This means users have access to a variety of storage options that adhere to the same interface.

 4. **Standardization:** CSI's standardization helps prevent vendor lock-in and promotes interoperability. 
 It allows organizations to mix and match storage solutions based on their needs without worrying about compatibility issues.

 In summary, CSI serves as a universal standard for container storage, making it easier for storage vendors to support multiple container orchestrators and enabling users to select the most suitable storage solutions for their specific use cases.


Meaning that any storage plugins that follows the CSI standard will be allowed to work with the support container orchestrator...



Yes, that's correct! Any storage plugin that follows the CSI (Container Storage Interface) standard should be compatible with container orchestrators that support CSI. 
Container orchestrators like Kubernetes are designed to work with CSI-compliant plugins, and they provide the necessary interfaces and mechanisms for these plugins to interact with the orchestrator.

By adhering to the CSI standard, storage vendors can ensure that their storage solutions are compatible not only with Kubernetes but also with other container orchestrators that support CSI. 
This compatibility allows users to seamlessly integrate different storage solutions into their containerized environments without worrying about vendor-specific APIs or compatibility issues.

In essence, CSI acts as a bridge between container orchestrators and storage providers, promoting interoperability and making it easier for users to leverage a wide range of storage options within their containerized applications.


Now about CNI, it’s a set of standards that must be adhered by network solutions in other for it to work with Kubernetes without having to modify or change the k8s source code right? 


Yes, that's correct! The Container Network Interface (CNI) is a set of standards and specifications that network solutions must adhere to in order to work with Kubernetes seamlessly, without needing to modify or change the Kubernetes source code. 
CNI provides a standardized way for network plugins to configure and manage networking for pods within a Kubernetes cluster.

Key points about CNI:

1. **Standardized Interface:** CNI defines a standardized interface and set of conventions that network plugins can follow. This standardization ensures that network solutions can be used interchangeably with Kubernetes, as long as they adhere to the CNI specification.

2. **Flexibility:** Because Kubernetes relies on the CNI interface, it can work with a wide range of network plugins. 
Different plugins, such as Calico, Flannel, Weave, and more, can be used to meet specific networking requirements without altering Kubernetes itself.

3. **No Kubernetes Source Code Changes:** Kubernetes does not need to be modified to support different network solutions, thanks to CNI. 
This separation of concerns allows for easier integration and maintenance of Kubernetes clusters with diverse networking needs.

In summary, CNI serves as a standardized bridge between Kubernetes and network plugins, enabling Kubernetes to remain agnostic about the specific networking technology being used while allowing users to choose the network solution that best fits their requirements.
This design philosophy promotes interoperability and simplifies the management of networking in Kubernetes clusters.


About CRI, this is also I set of standards that must be followed by container runtime engines or solutions to be able to work with Kubernetes without modification of k8s source code. 
Examples of such that adheres to this standard are containerD, crio, rkt.

Yes, that's correct! The Container Runtime Interface (CRI) is indeed a set of standards and specifications that container runtime engines or solutions must adhere to in order to work seamlessly with Kubernetes, without requiring modifications to the Kubernetes source code. 
Kubernetes uses CRI as an abstraction layer to communicate with container runtimes, allowing for flexibility in choosing different runtimes. Some examples of container runtimes that adhere to the CRI standard include:

1. **containerd:** containerd is an industry-standard core container runtime that complies with the CRI interface. It is widely used in Kubernetes environments, especially as Kubernetes has shifted towards using containerd as its default runtime.

2. **CRI-O:** CRI-O is another CRI-compliant container runtime designed specifically for Kubernetes. It provides a lightweight and secure runtime that integrates seamlessly with Kubernetes.

3. **rkt (pronounced "Rocket"):** While rkt was one of the early CRI-compliant runtimes, it's worth noting that its development has slowed down, and containerd and CRI-O have become more popular choices in Kubernetes environments.

4. **Docker:** Docker, did not natively adhere to the CRI standard. 
Kubernetes used to communicate with Docker through a different interface (Docker's own CRI plugin). 
However, Kubernetes started deprecating Docker as a runtime in favor of containerd due to the shift in industry trends.

Explain to me about RPC which is remote procedure call that a CSI supported container orchestrator must make and what is expected of the csi complaint storage vendor or solution’s must do. 


Remote Procedure Call (RPC) is a mechanism used in computing to allow a program to cause a procedure (subroutine) to execute on another address space (commonly on another machine). 
In the context of the Container Storage Interface (CSI), RPCs are used to facilitate communication between a CSI-supported container orchestrator (like Kubernetes) and a CSI-compliant storage vendor or solution.

Here's a simplified explanation of how RPCs work in the context of CSI:

**For a CSI-Supported Container Orchestrator (e.g., Kubernetes):**
1. When a pod in Kubernetes requires storage operations (e.g., provisioning a new volume, attaching it to a pod, or taking a snapshot), the Kubernetes control plane sends a request to the CSI driver. This request is typically an RPC.

2. Kubernetes uses the CSI RPC to communicate its intentions and requirements to the CSI driver. The RPC includes details about the storage operation to be performed, such as volume creation specifications or pod attachment requests.

3. The Kubernetes control plane waits for a response from the CSI driver, which contains the outcome of the requested operation. This response is also typically sent using RPC.

**For a CSI-Compliant Storage Vendor or Solution:**
1. The CSI-compliant storage vendor or solution has implemented a CSI driver that adheres to the CSI specification and provides the necessary RPC endpoints.

2. When the CSI driver receives an RPC request from the container orchestrator (e.g., Kubernetes), it processes the request based on the provided parameters and performs the required storage operations.

3. Once the operation is completed, the CSI driver sends an RPC response back to the container orchestrator, informing it of the outcome (e.g., success, failure).

In essence, RPCs in CSI enable Kubernetes (or any CSI-supported container orchestrator) to communicate with external storage systems via standardized requests and responses. 
This standardization ensures interoperability between the orchestrator and various storage solutions, allowing for the dynamic provisioning, attachment, and management of storage volumes in a consistent manner, regardless of the underlying storage technology or vendor.


REFERENCE:
https://kubernetes.io/docs/concepts/storage/



Volumes:

https://kubernetes.io/docs/concepts/storage/volumes/

https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
When we create a pod with container running inside of the pods, when the pods are destroyed the data or logs generated by those containers are destroyed..
We use volumes to persist data inside/outside the container.. So when the containers are deleted, the data processed by the container remains..


Implimentation:

apiVersion: v1
kind: Pod
metadata:
  name: random-number-generator
spec:
  containers:
  - name: generator-container
    image: busybox
    command: ["/bin/sh", "-c"]
    args: ["while true; do echo $((RANDOM % 100)) >> /opt/numbers.txt; sleep 1; done"]
    volumeMounts:
    - name: data-volume
      mountPath: /opt
  volumes:
  - name: data-volume
    hostPath:
      path: /path/on/host
To create a Kubernetes Pod that runs a command to generate random numbers and saves them in /opt/numbers.txt within the container, you can define a Pod manifest file like this:
If you want this random numbers stored in the host, youll use a storage solutions, lets say hostPath volume..
This will persist the data generated by the container/application into the specified dir on the host and in the container... However, when the pods gets deleted, the data is persisted on the host..

This is not a recommended options, b/c when you deployed the pods.. Theyll create the specified volume/storage dir on each host and results in inconsistent data..

Kubernetes supports external storage solutions such as:
amazon ebs, nfs, ceph, glusterfs,flocker,google persistent disk etc...

emptyDir:

apiVersion: v1
kind: Pod
metadata:
  name: random-number-generator
spec:
  containers:
  - name: generator-container
    image: busybox
    command: ["/bin/sh", "-c"]
    args: ["while true; do echo $((RANDOM % 100)) >> /opt/numbers.txt; sleep 1; done"]
    volumeMounts:
    - name: data-volume
      mountPath: /opt
  volumes:
  - name: data-volume
    emptyDir: {}



Persistent Volumes:
https://kubernetes.io/docs/concepts/storage/persistent-volumes/

Managing storage is a distinct problem from managing compute instances.
 The PersistentVolume subsystem provides an API for users and administrators that abstracts details of how storage is provided from how it is consumed. 
 To do this, we introduce two new API resources: PersistentVolume and PersistentVolumeClaim.

A PersistentVolume (PV) is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. 
It is a resource in the cluster just like a node is a cluster resource. PVs are volume plugins like Volumes, but have a lifecycle independent of any individual Pod that uses the PV. 
This API object captures the details of the implementation of the storage, be that NFS, iSCSI, or a cloud-provider-specific storage system.

A PersistentVolumeClaim (PVC) is a request for storage by a user. It is similar to a Pod. Pods consume node resources and PVCs consume PV resources. 
Pods can request specific levels of resources (CPU and Memory). Claims can request specific size and access modes (e.g., they can be mounted ReadWriteOnce, ReadOnlyMany or ReadWriteMany, see AccessModes).

While PersistentVolumeClaims allow a user to consume abstract storage resources, it is common that users need PersistentVolumes with varying properties, such as performance, for different problems. 
Cluster administrators need to be able to offer a variety of PersistentVolumes that differ in more ways than size and access modes, without exposing users to the details of how those volumes are implemented. For these needs, there is the StorageClass resource.


IN MY UNDERSTANDING:

A pv is a kubernetes api object that enables you inpliment persistent storage volumes for your application that requires it.
The Pv object is associated a choice storage solutions such as hostpath,ebs,nfs etc.
This is configured by the administrator via dynamic provisiong or statically creating the pv..

The User that requires this pv to use in his application then claims the pv using pvc.

In this pvc you specify the storage size you need for your application and the access mode and if that matches the manually provisioned pv the pvc will then bound with the PV.
Then You can then use this in your pod definition file by passion the field PersistentVolumeClaim and the claimName at the volume section to make it available for your application..


CHATGPT VIEW:

Your understanding of Kubernetes Persistent Volumes (PVs) and Persistent Volume Claims (PVCs) is mostly correct. I'll provide a breakdown and some clarifications:

1. **Persistent Volume (PV)**:
   - A PV is indeed a Kubernetes API object that represents a piece of networked storage in the cluster.
   - It's associated with physical storage solutions like hostPath, EBS (Elastic Block Store), NFS (Network File System), etc.
   - The administrator is responsible for provisioning PVs. They can provision them statically or dynamically, depending on the cluster's configuration and requirements.

2. **Persistent Volume Claim (PVC)**:
   - A PVC is also a Kubernetes API object, but it's used by application developers (users) to request a specific amount of storage with specific access modes.
   - In the PVC, users specify the storage size needed, access mode (e.g., ReadWriteOnce, ReadOnlyMany, ReadWriteMany), and potentially other storage-related settings.
   - When a PVC is created, Kubernetes attempts to find a matching PV that satisfies the PVC's requirements (size, access mode, etc.). If a suitable PV is available, the PVC is bound to it.

3. **Binding PVs and PVCs**:
   - As you correctly mentioned, binding happens when the PVC's requirements (size, access mode) match the specifications of an available PV.
   - Once a PVC is bound to a PV, it means that the PV is reserved for the PVC, and the PVC can now use the storage defined by the PV.

4. **Using PVCs in Pods**:
   - To make the storage defined by a PVC available to a pod, you specify the PVC's name in the pod's volume definition.
   - Pods can use these volumes as if they were regular directories within their containers.

5. **Clarification on "Passion the field PersistentVolumeClaim"**:
   - It seems there might be a typo in your statement. You should specify the PVC's name using the `persistentVolumeClaim` field within the volume definition of a pod, not "passion."
   - Example usage in a pod definition:
     ```yaml
     apiVersion: v1
     kind: Pod
     metadata:
       name: my-pod
     spec:
       containers:
       - name: my-container
         image: my-image
         volumeMounts:
         - name: my-volume
           mountPath: /path/in/container
       volumes:
       - name: my-volume
         persistentVolumeClaim:
           claimName: my-pvc
     ```

In summary, your understanding is quite accurate. PVs and PVCs are essential components in Kubernetes for managing and provisioning storage resources for applications in a flexible and abstracted manner. 
Users request storage via PVCs, administrators provision storage via PVs, and pods use these PVCs to access the persistent storage they need.

REF:

https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes



Using PVC in Pods

Once you create a PVC use it in a POD definition file by specifying the PVC Claim name under persistentVolumeClaim section in the volumes section like this:

 

apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim

 

The same is true for ReplicaSets or Deployments. Add this to the pod template section of a Deployment on ReplicaSet.

 

Reference URL: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes
https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/



Storage Class::

https://kubernetes.io/docs/concepts/storage/storage-classes/

Important:
Once your storage class binding mode is Waitforfirstconsumer...
Once you create a pvc, your pvc will not be able to bind with the pv untill a pod gets configured with that pvc that requested the pv.
The Storage Class called local-storage makes use of VolumeBindingMode set to WaitForFirstConsumer. 
This will delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created.

Thank you for providing additional context. The `VolumeBindingMode` set to `WaitForFirstConsumer` 
in your StorageClass configuration means that the binding and provisioning of a PersistentVolume (PV) will be delayed until a Pod that uses the associated PersistentVolumeClaim (PVC) is created. 
This mode is particularly useful in scenarios where you want to ensure that storage resources are only provisioned when they are actually needed by a Pod.

Here's how it works:

1. **PVC Creation**: When you create a PVC with this StorageClass, the PV provisioning doesn't happen immediately. The PVC goes into a "Pending" state.

2. **Pod Creation**: Once you create a Pod that references the PVC, the Kubernetes control plane observes that there's a Pod waiting for this PVC to be bound to a PV.

3. **Binding**: Kubernetes then initiates the binding process. It looks for an available PV that matches the requirements specified in the PVC (e.g., capacity, access modes, node affinity).

4. **Provisioning (if needed)**: If there is no existing PV that matches the PVC, Kubernetes may dynamically provision a new PV to meet the PVC's requirements. 
This newly provisioned PV is then bound to the PVC.

This approach has some advantages:

- Resource Efficiency: Resources are provisioned on-demand, reducing potential wastage.

- Flexibility: You can create PVCs in advance without worrying about immediate resource allocation. Resources are allocated when the Pods that need them are created.

- Simplified Administration: You don't need to pre-create a large number of PVs, making storage management more straightforward.

Keep in mind the following considerations:

- The delay in provisioning can lead to slightly longer PVC creation times, as the provisioning step occurs when a Pod is created.

- It relies on the ability to dynamically provision PVs. Ensure that the StorageClass is correctly configured for dynamic provisioning, 
and there are no issues with your underlying storage infrastructure.

- In some cases, it may lead to a slight delay when Pods are scheduled because the PV provisioning process must complete before the Pod can start.

Overall, `WaitForFirstConsumer` can be an efficient and flexible choice for managing storage resources in a Kubernetes cluster, especially when you want to optimize resource allocation.

...............



Networking:

Prerequisite Switching, Routing, Gateways CNI in kubernetes
We have 2 computers system A and B.
How does A reach B?
We connect them to a switch and the switch creates a network connecting the 2 systems..
To connect them to a switch, we need an interface on each host, pysical/virtual...

SOLUTION:
To view or modify an interface on the host for connectivity of the systems. We run the ip link command on the hosts..
RUN
ip link. This will output an interface called eth0 This is what will be used to connect to the switch on the hosts.

Lets assign the network the IP 192.168.1.0/24
We then assign an IP for host with ip range of the same network say  192.168.1.10 for host A and Host B 192.168.1.11

We assign this IPs to each host using the below command.
Host A:  ip addr add 192.168.1.10/24 dev eth0
Host B:  ip addr add 192.168.1.11/24 dev eth0

Explainning the command:


In the command `ip addr add 192.168.1.10/24 dev eth0`, the "dev" stands for "device." It is used to specify the network device (or interface) to which you want to assign the IP address.

Here's a breakdown of the command:

- `ip addr add`: This part of the command is telling the system that you want to add an IP address.

- `192.168.1.10/24`: This is the IP address you want to assign, along with its subnet mask (/24 indicates a subnet mask of 255.255.255.0).

- `dev eth0`: Here, "dev" is followed by the name of the network interface, which is `eth0` in this case. 
This part of the command specifies the network interface to which the IP address should be assigned.

So, the command is instructing the system to add the IP address 192.168.1.10 with a subnet mask of 255.255.255.0 to the network interface `eth0`. 
This is how you configure the network interface with a specific IP address in Linux.

With this we have created an interface on the hosts and assigned cidr to the hosts and established a connection bw 2 systems


TEST THE CONNECTION:

From Host A ping host B
ping 192.168.1.11

You'll get a parket sent....


2 SAY WE HAVE ANOTHER SYSTEM C AND D.
 network is of the IP 192.168.2.0/24, a network address and subnet mask

 SOLUTION:
 To list/modify interface on the host for connectivity of the systems. We run the ip link command on the hosts..
 RUN
 ip link. This will output an interface called eth0 .
 This is what will be used to connect to the switch on the hosts.

 Lets assign the network the IP 192.168.2.0/24
 We then assign an IP for host with ip range of the same network say  192.168.2.10 for host C and Host D 192.168.2.11

 We assign this IPs to each host using the below command.
 Host C:  ip addr add 192.168.2.10/24 dev eth0
 Host D:  ip addr add 192.168.2.11/24 dev eth0

 With this we have added an IP address to the  interface on the hosts or assigned IP to the hosts and established a connection bw 2 systems
 
 TEST THE CONNECTION:

 From Host C ping host D
 ping 192.168.2.11

 You'll get a parket sent....
 
 
 THE QUESTION IS HOW CAN WE MAKE THE NETWORK A,B TO COMMUNICATE WITH C,D NETWORK.
 How can the Host B talk to host C?
 
 This is where a Router comes in. A router helps to connect diff networks together.
 Devices on different subnets: If you have devices on different subnets, you would typically need a router or a layer 3 switch to route traffic between these subnets. 
 The router or layer 3 switch will have interfaces in each subnet, and it knows how to forward packets between them.
 
 To establish connectivity bw the network of A,B and C,D we use  a Router to link the two networks.
 The router will be assigned 2 ips one for each side of the network.
 
 Therefore Router linking network A,B gets assigned 192.168.1.1 and The same router linking network C,D gets assigned 192.168.2.1
 Summarily, A router with 2 ips one ip handling A,B and the other C,D.
 The Router is in between the networks to ensure the connections happens.
 
 Important:
 When system B trys to send a packet to system C on the network.
 How does it know where the router is on the network to send a packet through? Since the router is just another device on the network...
 There could be many other such devices..
 That is where we configure the network with a gateway..
 
 If the network was a room and the router was a rope joining diff networks together, the gateway is like a door to meeting other networks outside or to the internet.
 
 The systems or hosts needs to know where that door/route/gateway is in other to pass through it.
 
 To see the existing routing configurations on a system.
 Run:
 route --> This will display the kernels routing tables. If there are routing configurations, youll see it in the output..
 If no output of ips from the route command, it simply means that system B cant be able to reach system C b/c there are no routing configuration.
 System B can only reach A because theyre on the same network.
 
 Its important to note that using a router alone to link the 2 networks doesnt guranteed connectivity or transfer of data bw the 2 networks but a step that must be followed to acheieve your gaol.
 
 How can we add a door or route to be able to reach the network of host C,D from A,B
 How can we add a door/route/gateway to reach the network of hosts A,B from C,D
 
 Important:
 Remember when we used a router to link network  of host A,B and C,D, we had 2 ips for the router... 
 Network of host A,B ----> had 192.168.1.1 on the router and Network of host C,D ----> had 192.168.2.1 on the router.
 
 Therefore 
 1. For host A,B to reach Hosts C,D 
 
 RUN:
 ip route add 192.168.2.0/24 via 192.168.1.1
 where 192.168.2.0/24 ip of network of host C,D
 where 192.168.1.1 is the IP of the router on A,B side of the connectivity.
 
 2.  For host C,D to reach Hosts  A,B
 RUN:

 ip route add 192.168.1.0/24 via 192.168.2.1
 where 192.168.1.0/24 ip or network of host A,B
 where 192.168.2.1 is the IP of the router on C,D side of the connectivity.
 
 
3. What if these systems Needs access to the internet???
 
 Say the network of hosts C,D needs access to the internet on 172.217.194.0/24, we connect the router to the internet.
 RUN:
 ip route add 172.217.194.0/24 via 192.168.2.1
 where 172.... is the internet IP
 where 192.168.2.1 the router ip for network of hosts C,D
 
 When you have too many ips to access on the internet. You can dedicate a particular router as a default gateway.
 This way you dont have to add a route/door/gateway for every internet ip.
 Therefore for any network that you dont kwn over the internet.
 Run:
 
 ip route add default via 192.168.2.1
 or
 
 ip route add 0.0.0.0 via 192.168.2.1 --> This way any ip on the internet will be reached and you have dedicated the router of hosts C,D Network as the default for internet connectivity.
 
 In the future if no internet in the network, youll kwn where to start with troubleshooting...
 
 You can also decide to have 2 routers linking the 2 networks..
 Then dedicate one for internal connectivity and one for route/gateway to the internet.
 
 
 
 SUMMARY BY CHAT GPT:::::::::::::::::
 Your explanation provides a good overview of networking concepts, including how to set up connectivity between different network segments using a router or gateway. 
 Here's a summary of your explanation:

 1. **Setting Up Hosts A and B**:
    - Connect both hosts to a switch.
    - Assign IP addresses within the same subnet (e.g., 192.168.1.10 for Host A and 192.168.1.11 for Host B) with the same CIDR notation.
    - Verify connectivity by pinging one host from the other.

 2. **Setting Up Hosts C and D**:
    - Connect these hosts to another switch.
    - Assign IP addresses within the same subnet (e.g., 192.168.2.10 for Host C and 192.168.2.11 for Host D) with the same CIDR notation.
    - Verify connectivity within this network by pinging one host from the other.

 3. **Introducing a Router**:
    - Use a router to connect the two networks (A/B and C/D).
    - Assign the router an IP address in each network segment (e.g., 192.168.1.1 for A/B and 192.168.2.1 for C/D).
    - This router acts as the gateway between the two networks.

 4. **Configuring Routes**:
    - To enable communication between the networks:
      - On Host A/B: `ip route add 192.168.2.0/24 via 192.168.1.1`
      - On Host C/D: `ip route add 192.168.1.0/24 via 192.168.2.1`
    - These routes tell each host how to reach the other network through the router.

 5. **Internet Connectivity**:
    - To provide internet access to the network of Hosts C/D:
      - Connect the router to the internet.
      - Add a route for the internet IP range: `ip route add 172.217.194.0/24 via 192.168.2.1`
    - You can also set a default route to the router for general internet access: `ip route add default via 192.168.2.1`

 6. **Using Multiple Routers**:
    - You can use multiple routers for different purposes, such as internal connectivity and internet routing.

 Your explanation covers the fundamentals of setting up networks, routers, and routing configurations effectively. 
 It's important to understand these concepts when dealing with network segmentation and interconnectivity.
 
 
 HOW TO SETUP A LINUX HOST AS A ROUTER
 
 When we use a linux machines say B to setup interconnectivity between 2 vms A and C, One of the machines say B will act as a router between the 2 vms A and C which are in 
 a different network of diff subnets.
 When we configure a route/gateway/door for the vm of A to send a packet to vm of C and vice versa.
 With Your configuration, you have succesfully established connectivity b/c youv'e added routes for the hosts to send packets to eachother.
 But by default in linux, packets are not forwarded from one interface to another..
 packets received on eth0 on host B are not forwarded to elsewhere through eth1 on same host B which is acting as a router.
 
 Weather a host can forward packets between interfaces is governed by the settings at cat /proc/sys/net/ipv4/ip_forward file.
 by default it is set at 0, change it to 1 and see the pings go through.
 
 
 You're absolutely correct, and I appreciate your clarification. Enabling IP packet forwarding in Linux is a crucial step when configuring a Linux host to act as a router.

 To enable IP packet forwarding in Linux, you can set the value in the `/proc/sys/net/ipv4/ip_forward` file to `1`. You can do this using the `echo` command or by modifying the file directly.
  Here's how:

 ```bash
 # Enable IP packet forwarding temporarily
 echo 1 > /proc/sys/net/ipv4/ip_forward

 # Enable IP packet forwarding persistently (across reboots)
 echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
 sysctl -p
 ```

 By setting the value to `1`, you tell the Linux kernel to forward packets between interfaces, allowing the Linux host (machine B) to act as a router for VMs A and C, as you described.

 Thank you for highlighting this important step, as enabling IP packet forwarding is essential for the routing functionality of the Linux host.
 
 
 
 
 
 MY SUMMARY:
 
 
 ip link --> List and modify interfaces on the host
 ip addr ---> List ip addresses assigned to the interfaces
 ip addr add 192.168.1.10/24 dev eth0 --> Used Assign or set ip address on the interfaces
 ip route or route ---> Used to view the door/routing table
 ip route add 192.168.1.0/24 via 192.168.2.1  --> Used to add entries to the routing tables or create a door 4 packets to travel
 cat /proc/sys/net/ipv4/ip_forward --> This file must be set to one when using linux hosts as routers to enable packets to be sent through interfaces.
 
 
 # Enable IP packet forwarding temporarily
 echo 1 > /proc/sys/net/ipv4/ip_forward

 # Enable IP packet forwarding persistently (across reboots)
 echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
 sysctl -p
 
 
 Changes made by this changes are only valid till reboot, if you want it to persist, you must set them in the /etc/network/interfaces file
 
 
 
 FROM GPT:
 Your summary is mostly accurate, but there's a small detail to clarify. In Linux, network interface configurations can be done using various methods, 
 and the specific method might vary based on the Linux distribution. The commands you mentioned are commonly used, 
 but they are not typically used to set configurations in the `/etc/network/interfaces` file.

 Here's a more detailed explanation:

 1. **`ip link`**: This command is used to display and manage network interfaces on the host. 
 It can be used to list interfaces and change their state (e.g., bring them up or down). It doesn't directly configure IP addresses.

 2. **`ip addr`**: This command is used to display and manage IP addresses assigned to network interfaces. 
 You can use it to view the currently assigned IP addresses and also to add or remove IP addresses from interfaces.

 3. **`ip addr add 192.168.1.10/24 dev eth0`**: This command assigns the IP address 192.168.1.10 with a subnet mask of /24 (255.255.255.0) to the `eth0` network interface. 
 It sets the IP address temporarily, and these changes are not persistent across reboots.

 To make network configuration changes persistent across reboots, you typically need to configure the network settings in the appropriate configuration files.
  The `/etc/network/interfaces` file is commonly used in Debian-based distributions like Ubuntu for configuring network interfaces.

 For example, to make the IP address assignment persistent, you would edit the `/etc/network/interfaces` file and add configuration lines like:

 ```
 auto eth0
 iface eth0 inet static
     address 192.168.1.10
     netmask 255.255.255.0
 ```

 This configuration will ensure that the IP address for `eth0` is set to 192.168.1.10 with a subnet mask of 255.255.255.0 every time the system boots.

 Keep in mind that the specific configuration files and methods may vary depending on the Linux distribution you are using.
 
 
 
 
 extra read mine above explains it all though..
 ............................................

 IMPORTANT:

 Your description of how to connect two computer systems (A and B) using a switch and configuring network interfaces is mostly correct. However, there are a few minor points to clarify and correct:

 1. You mentioned running the "ip link" command to create an interface on the host, which is not entirely accurate. The "ip link" command is typically used to manage existing network interfaces, not to create new ones. 
 To create a new virtual network interface, you might use commands like "ifconfig" or "ip link add."

 2. Instead of assuming the network is of the IP 192.168.1.0, you should specify a network address and subnet mask. For example, if you're using a /24 subnet mask, you can say the network is 192.168.1.0/24.

 3. When assigning IP addresses to Host A and Host B, you correctly used the "ip addr add" command, but it's also a good practice to specify the network mask explicitly. So, the commands would look like this:

    Host A: `ip addr add 192.168.1.10/24 dev eth0`
    Host B: `ip addr add 192.168.1.11/24 dev eth0`

 4. You mentioned that with these steps, you have created an interface on the hosts and assigned CIDR to the hosts, which is correct. 
 However, you may want to emphasize that these IP addresses must be unique within the network to avoid conflicts.

 Overall, your explanation is on the right track, but it could benefit from a few clarifications and corrections as mentioned above.


 MORE:

 Yes, choosing an IP address for a host within the range of the network's IP address (within the same subnet) is a key step in enabling interconnectivity. 
 When devices are on the same subnet and have IP addresses within the same range, they can communicate directly with each other without needing a router to reach devices on different subnets.

 Here's a simplified breakdown of how it works:

 1. Devices within the same subnet: Devices with IP addresses within the same subnet can communicate with each other directly because they share the same network address and subnet mask. 
 They can send packets to each other without the need for routing through a gateway or router.

 2. Devices on different subnets: If you have devices on different subnets, you would typically need a router or a layer 3 switch to route traffic between these subnets. 
 The router or layer 3 switch will have interfaces in each subnet, and it knows how to forward packets between them.

 So, when you choose IP addresses within the same subnet range for your hosts, they should be able to communicate directly on that subnet, 
 assuming there are no other network configuration issues.
 
 

 Prerequisite DNS:
 
 What’s the difference bw hostname and domain name?
 
 A "hostname" and a "domain name" are two related but distinct concepts in the context of computer networking and the Domain Name System (DNS):

 1. **Hostname**:
    - A hostname is the name assigned to a specific device or computer on a network.
    - It's typically a single word or a short, human-readable label used to identify that particular device within a local network.
    - Hostnames are used for internal network communication and may not be globally unique.
	 For example, on a home network, you might have multiple devices with hostnames like "laptop," "printer," or "smartphone."

 2. **Domain Name**:
    - A domain name is a hierarchical, human-readable address used to identify resources on the internet.
    - It consists of multiple parts, separated by periods (dots), with the top-level domain (TLD) being the rightmost part.
	 Examples of TLDs include ".com," ".org," and ".net."
    - A domain name represents a location or an organization on the internet and can be used for websites, email servers, and other online services.
    - Domain names are globally unique and registered through domain registrars to ensure there are no conflicts.

 Here's an example to illustrate the difference:
 - **Hostname**: On your local network, you might have a computer with the hostname "my-laptop." This hostname is used to identify your laptop within your home network.
 - **Domain Name**: On the internet, a website might have the domain name "www.example.com." 
 This domain name represents a specific website on the worldwide web and is used to access that website from anywhere on the internet.

 In summary, hostnames are used for local network identification and may not be unique globally, 
 while domain names are used for internet resources and must be globally unique to ensure proper routing and identification on the web.
 
 Illustration:
 
 network---> 192.168.1.0/24
 We have 2 computers on the same network, we call it system A <192.168.1.10> and system B <192.168.1.11>.
 The 2 hosts can communicate with each since theyre on the same network.
 You can ping system B from A using its IP address and vice versa.
 
 Lets assume that system B has a DB application running in it and we would like to call system B db.
 Going further, we would like to ping system B using the name db instead of it IP address.
 
 We run: ping db and get an error message indicating that host A doesnt know any system by the name db.
 
 How do we resolve this?
 
 We have to tell system A that when i say db, that i mean system B IP 192.168.1.11
 We do this by adding an entry in the cat >> /etc/hosts file in system A.
 e.g:
cat >> /etc/hosts
192.168.1.11 db

Now when you ping db, the ping goes through..

The /etc/hosts file becomes the only source of truth for host A.
But is it trully the only source of truth?? When you run hostname command on system B you get the result of node-02 but to system A its known as db.
We can even trick system A to think that system B is known as www.google.com
 e.g:
cat >> /etc/hosts
192.168.1.11 db
192.168.1.11 www.google.com

ping www.google.com goes through and youll get a response from system B.. But is the host B www.google.com??

NB: we have mapped 2 different names to the ip of system IP, you can have as many names as you want.

ping db
ping www.google.com
curl https://www.google.com
You can even add Ip address of other servers and the names you want them to be known as in the /etc/hosts file.

Translating hostname into IP addresses this way are called name resolution.

When you have multiple systems say A,B,C,D,E,F etc..
For A to talk to B,C,D,E... You will have to enter their ips and their hostnames or names you will want them to be known as in host A /etc/hosts file and the same is applicable to B,C,D,E,F .... when 
they require to talk to A and all.

This was how it was done in the past till the entries becomes so much and complex to maintain, if one hosts IP changes, youll have to update the ip in other hosts /etc/hosts file and vice versa.

This was why DNS server was introduced..

Instead of adding entries of every hosts in the /etc/hosts file. we create a file that contains the hostnames to ip mappings of all the hosts.
Will store these entries into our DNS server. We then point the DNS server to each of the host and any host that needs to resolve a dns will lookup to the dns server.

How do we point our hosts to the dns server?

Every hosts has a dns configuration file at cat /etc/reslove.conf.
Note: Our DNS server has an ip address, lets say 192.168.1.100

In each of the host, we enter our dns server ip address in the /etc/reslove.conf as follows:

nameserver 192.168.1.100

We do this in all of the hosts. 
This means that if a host needs to reslove a hostname, the request will go to our dns server on its ip 192.168.1.100 to lookup for the entries that matches it querys.

Important:
If any of the ip address of a host where to change, we update this only in the dns server entries and all host will be able to resolve the new ip address.

A system is able to use hostname to ip mapping from a remote dns server and equally from /etc/hosts file locally.

What if you have entries in /etc/hosts file and another in remote dns server?

Example..

192.168.1.112 test in /etc/hosts file and 192.168.1.113 in the dns server.

The host will first look at the entries in the cat /etc/hosts file b4 checking the dns server..
This characteristics is defined by the configuration in /etc/nsswitch.conf

Open this file and change the order of dns resolution to first resolve to the dns server and if no entry is found then reslove to the cat /etc/hosts file
example:

hosts file dns change it to hosts dns file....

What if you try to ping a server or a hostname/domain name that does not exist in either the cat /etc/hosts file  or nor in the dns server????

Lets say ping www.facebook.com this will fail.
But we can add a public server that exists on the internet that knows hostname to ip mapping of facebook.
Google has a public dns server that serves publicly available domainnames or websites on the internet.
The ip of this dns server is 8.8.8.8 we add this in our /etc/resolve.conf file in each hosts example.

cat /etc/resolve.conf
nameserver 192.168.1.100
nameserver 8.8.8.8

Now ping www.facebook.com and packets will be sent to the dns server which then resolves it to the ip address of the host hosting the facebook application.

The problem is that we will have to add this nameserver 8.8.8.8 in the cat /etc/resolve.conf of all the hosts..

Alternatively, we can make a change in our dns server to forward all unknown hostnames to the dns server on the internet owned by google that will resolve it to the ip of the host.

eg.

Forward All to 8.8.8.8


Important:

www.facebook.com
www.google.com
This is a domainname and its how ips translate to domain names that we can remember instead of having to type ip addresses..
Domain name is used to group things 2geda

.com -- TLD top level domain and it tells us the intent of the website
. --> root domain 
google --> domainname assigned to google

www --> subdomain, it further helps in grouping things 2geda example
maps.google.com , drive.google.com, hr.google.com, apps.google.com

When you try to reach any of these domainname, say apps.google.com  internally your request first hits your org dns server..
It doesnt kwn who apps or google is.. So it forwards your reqeust to the internet and with the help of multiple dns servers on the internet google will be resloved to the ip address hosting the google app.

A root dns server "." looks at your request and forwards it to the dns server serving .com a .com dns server looks at your request and forwards you to google and google dns server provides you the IP 
address of the server serving the apps application..

In other to speed up future resolves, your org dns server might cache the results of the request .ie the IP address of the apps application for a few sec ensuring it does not have to go through
the entire process eachtime...


WHAT ABOUT MY ORGANIZATION?
SAY WE HAVE
mycompany.com
subdomains as --> hr, pay, sales, www, mail for handling diff functions payroll app, mail application or hr for accessing hr application.
all of these are configured in mycompany internal dns server..

say we have entries like the below, 
 192.168.1.10 web.mycompany.com
 92.168.1.11 hr.mycompany.com
192.168.1.10 mail.mycompany.com
in our dns server and our endusers can reach our application server by pinging web.mycompany.com
This is correct. However, we would like to ping web instead of typing the full name internally and get resolved to the ip address of the server serving the web application
what do we do?

You make an entry in your host in the /etc/resolve.conf file called:
search and specify the domain name you want to append.
e.g

search mycompany.com

ping web 
it will add the rest in the output of the ping
web.mycompany.com


RECORD TYPES

A ---> stores ip address to hostname
AAAA --> stores ipv6 to hostname
CNAME ---> stores hostname to hostnames


Testing DNS resolution:

ping is not the right tool for testing dns resolution...
use:
nslookup and dig
use nslookup to query hostname from a dns server. It does not look at entries in the /etc/hosts files.
nslookup only quries the dns server and not the entry in your local /etc/hosts file

same for dig but outputs more results...




MORE ON DNS:

A "hostname" and a "domain name" are two related but distinct concepts in the context of computer networking and the Domain Name System (DNS):

1. **Hostname**:
   - A hostname is the name assigned to a specific device or computer on a network.
   - It's typically a single word or a short, human-readable label used to identify that particular device within a local network.
   - Hostnames are used for internal network communication and may not be globally unique. 
   For example, on a home network, you might have multiple devices with hostnames like "laptop," "printer," or "smartphone."

2. **Domain Name**:
   - A domain name is a hierarchical, human-readable address used to identify resources on the internet.
   - It consists of multiple parts, separated by periods (dots), with the top-level domain (TLD) being the rightmost part. Examples of TLDs include ".com," ".org," and ".net."
   - A domain name represents a location or an organization on the internet and can be used for websites, email servers, and other online services.
   - Domain names are globally unique and registered through domain registrars to ensure there are no conflicts.

Here's an example to illustrate the difference:
- **Hostname**: On your local network, you might have a computer with the hostname "my-laptop." 
This hostname is used to identify your laptop within your home network.
- **Domain Name**: On the internet, a website might have the domain name "www.example.com." 
This domain name represents a specific website on the worldwide web and is used to access that website from anywhere on the internet.

In summary, hostnames are used for local network identification and may not be unique globally,
 while domain names are used for internet resources and must be globally unique to ensure proper routing and identification on the web.
 
 

 Prerequisite – CoreDNS:


 In the previous lecture we saw why you need a DNS server and how it can help manage name resolution in large environments with many hostnames 
 and Ips and how you can configure your hosts to point to a DNS server. In this article we will see how to configure a host as a DNS server.

 We are given a server dedicated as the DNS server, and a set of Ips to configure as entries in the server. There are many DNS server
  solutions out there, in this lecture we will focus on a particular one – CoreDNS.

 So how do you get core dns? CoreDNS binaries can be downloaded from their Github releases page or as a docker image. 
 Let’s go the traditional route. Download the binary using curl or wget. And extract it. You get the coredns executable.
 


 Run the executable to start a DNS server. It by default listens on port 53, which is the default port for a DNS server.

 Now we haven’t specified the IP to hostname mappings. For that you need to provide some configurations. 
 There are multiple ways to do that. We will look at one. First we put all of the entries into the DNS servers /etc/hosts file.

 And then we configure CoreDNS to use that file. CoreDNS loads it’s configuration from a file named Corefile. 
 Here is a simple configuration that instructs CoreDNS to fetch the IP to hostname mappings from the file /etc/hosts. When the DNS server is run, it now picks the Ips and names from the /etc/hosts file on the server.
 



 Prerequisite Network Namespaces:

 JUST FOR BASIC REFERNCE:
 So if i understand clearly, if i choose a network of 192.168.1.0/20
 This corresponds to 255.255.255.0
 lets say i assign my network a subnet mask of /20

 192.168.1.0 ip will be reserved for the network which corresponds to 255.255.255.0

 I can then assign ips from 192.168.1.1 to 192.168.1.254 ???



 so the first 24 bits should be 1 and the rest 0

 we have 8bit in 4 segment

 11111111 11111111 11111111 00000000  --> binary 
 we convert this to decimal

 11111111 is = 255 in decimal
 11111111.   = 255
 11111111 =    255
 00000000 =  0 

 255.255.255.0 will be for a network of notation as 24

 so if you decide to go with a notation cidr of /24 and chooses the ip

 192.168.1.0/24 or 254.254.254.0/24

 You can only assign ips between 192.168.1.1 to 254



 for 20 cidr notation

 11111111 11111111 11110000 00000000 binary

 to decimal is 

 255 255 240 0

 lets say we want a network of 192.168.240.0


 192.168.241.1
 192.168.242.1
 192.168.243.1
 192.168.244.1
 192.168.245.1
 192.168.246.1
 192.168.247.1
 192.168.254.1
 192.168.254.2

 https://www.binaryhexconverter.com/binary-to-decimal-converter

 Ref:
 https://chat.openai.com/c/a511822e-40a3-441e-aa88-531b757fb423
 
 

 Prerequisite Network Namespaces:
 
 Network namespaces in linux. Containers are separated from the underlying hosts using namespaces.
 When you create a container, you want to make sure its isolated and cannot see other process running on the host or any other containers.
 We create a namespace for the container to run. However, the underlying host has visibility on the container and processes running inside of it.
 
 Running a command ps -aux from the host will show you processes running on the host, including the container with a user ID 1122 or any ramdom number.
 Running the same command inside the container shows you that the process ID of the process in the container is 1 or any random number different from that of the host.
 
 This is how network namespaces works.
 
 When it comes to networking our host has interfaces that connects to the LAN, our host has routing and ARP tables that has information about the rest of the networks.
 We want to see all of those details from the container..
 
 When a container is created, we create a network namespace for it so it will have no visibility to any network related information on the host..
 Within the namespaces, the container has its own interfaces and Arp tables..
 
 Creating New Network Namespaces in linux:
 RUN:
 
 ip netns add red --> Creates a network namespace called red. netsns means network namespace
 ip netns add blue --> creates a blue namespace.
 ip netns --> lists the namespaces created.
 
 More Commands:
 To see the interfaces on my host RUN:
 ip link ---> You will see the loopback interface and an eth0 interface on the host.
 
 How can we view the interfaces on network namespaces we have created..
 
 ip netns exec red ip link 
 ip -n red link ---> Running the command inside the namesapce
 ..
 ip netns exec blue ip link 
 
 These commands execute the ip link command within the specified network namespace, allowing you to see the 
 list of network interfaces that exist within that namespace. This is useful for inspecting and managing network configurations within isolated namespaces.
 
 Listing the Interfaces on the network namespace we created will show you only the loopback interface. You will not see the eth0 interface.
 
 The same is true for the routing table and ARP tables.
 
  ip route --> host
  ip netns exec blue ip route --> no route
  ip netns exec red ip route --> no route

  arp --> host 
  ip netns exec blue arp --> no visibity on other namespaces
  ip netns exec red arp
  
  
  As you know, the network namespaces has no interface, no visibility on the host network.
  Lets establish connectivity bw the network namespaces.
   
  We connect both namespaces using a virtual cable/pipe
  RUN:
  ip link add netns red veth-red type veth peer name veth-blue netns blue --> Creates the cable and places one end of the cable to network namespace red and the other on blue to link the 2 namespaces.
  
  ip link add veth-red type veth peer name veth-blue --> This simply creates the cable called veth-red paired with veth-blue. But you have to link it to the network namespaces.
  ip link set veth-red nestns red --> This attachs one end of the pipe to red namespace
  ip link set veth-blue nestns blue --> This attachs one end to blue namespace
  
  This way You have connected the 2 namespaces using Pipe/cable..
  
  Now we have to assign ips to the network namespaces:
  RUN:
  ip -n blue addr add 192.168.15.1 dev veth-blue
  ip -n red addr add 192.168.15.2 dev veth-red
  
  RUN:  ip netns exec blue ip link 
  Youll see that the interfaces veth-blue and veth-red are down.
  Bring up the interfaces using:
  
  ip -n blue link set veth-blue up
  ip -n red link set veth-red up 
  
  Now we are good...
  Try pinging the red namespace from the blue network namespace.
  
  ip netns exec blue ping 192.168.15.2 --> This ping will go through and return a feedback...
  ip netns exec blue arp --> shows you that it identify its red neigbor on 192.168.15.2
  ip netns exec red arp --> shows you that it identify its blue neigbor on 192.168.15.1
  
  RUN:
  arp --> This on the host.
  You will see that the host has no idea of the network namespaces and their interfaces.
  
  This works for us, we have successfully isolated our network from the hosts and established connectivity bw 2 namespaces..
  
  What happens when we have 4 namespaces or more???
  How do you enable all of them to communicate with each other?
  
  In this case just like in the previous networking notes b4 this, we create a switch inside of the host to establish links to the 4 namespaces..
  This switch will have an IP range or subnet from which the network namespace will be assigned an ip.
  
  How do you create a switch/network inside of a host?
  There are several solutions for this such as.
  1. Open Vswitch
  2. Linux Bridge
  
  RUN:
  ip link add v-net-0 type bridge
  This network/switch ip will be 192.168.15.0/24
  
  This creates a switch/network/interface on the host that will be used to link the namespaces.
  To the namespaces its a switch to connect them
  To the host is just another interface on it.
  
  Run: ip link on the host, you will see that the v-net-0 interface is down.
  Run: ip link set v-net-0 up   ---> This brings up the interface.
  
  
  OUR GOAL:
  we will be connecting the namespaces 2geda using the bridge network v-net-0 we created.
  We will not be creating a pipe/cable like we did previously when we had 2 namespaces. Our requirements has changed and we have more namespaces this is the reason for the bridge network.
  
  1. We have to then delete the pipe we used to link the blue and red namespaces.
  RUN:
  
  ip -n red link delete veth-red  --> This deletes the cable/pipe used to link the blue namespace to the red.
  NB: When you delete one side say veth-red, the other end veth-blue used to connect the blue namespace gets deleted automatically since theyre pairs..
  You do not need to run ip -n blue link delete veth-blue again!!!
  
  NOW WE CAN CONNECT OUR NAMESPACES TO THE BRIDGE NETWORK.
  
  We have 4 namespaces blue,red,black and white
  
  Create a cable to connect the blue namespace to the bridge network, do the same for red, black and white..
  RUN:
   ip link add veth-red type veth peer name veth-red-br -- The other end veth-red-br will be the end that will be used to link to the bridge switch.
   ip link add veth-blue type veth peer name veth-blue-br
   ip link add veth-black type veth peer name veth-black-br
   ip link add veth-white type veth peer name veth-white-br
   
   ip link set veth-red nestns red --> This attachs one end of the pipe to red namespace
   To attach the other end to the bridge v-net-0 network:
   ip link set veth-blue-br master v-net-0 --> This attachs one end to blue
   
   also for the blue namespace, connect it to the v-net-0 bridge network
   ip link set veth-blue netns blue --> link one end of the pipe to blue namespace
   ip link set veth-blue-br master v-net-0 --> links the other end of pipe to bridge v-net-0 network
   
   we have create a pipe/cable thats linked blue namespace to v-net-0 and also for the red, do this for the rest 2 white and black namespaces.
   
   WHAT NEXT:
   
   We set ip addresses on the namespaces using the ip addr command:

   ip -n blue addr add 192.168.15.1 dev veth-blue
   ip -n red addr add 192.168.15.2 dev veth-red
   
   We do the same for the other 2 white and black..
   
  
   RUN:  ip netns exec blue ip link 
   Youll see that the interfaces veth-blue and veth-red,veth-black,veth-white are down.
   Bring up the interfaces using:
  
   ip -n blue link set veth-blue up
   ip -n red link set veth-red up 
   
   We do the same for the other 2 white and black..
   
   This way we have established connectivity bw our namespaces and they can both communicate with each other....
   
   Important:
   Our host has a ip, 192.168.1.2.
   Lets ping the namespaces from our host
   
   ping 192.168.15.1
   
   This will show unreachable, you are unable to reach the namespaces from the host..
   How can we reach the namespaces from the host? remember the when you run the ip link command from the host, youll see the v-net-0 interface from the host.
   We said that the v-net-0 interface is just another interface on the host and assigning it an Ip address within the same cidr range will establish a communication bw the namespaces and the host.
   
   Assign an ip address of 192.168.15.5 to the v-net-0 interface
   
   run:
   ip addr add 192.168.15.1/24 dev v-net-0 --> with this we will be able to ping the blue namespace.
   ping 192.168.15.1
   goes through and returns a response.. Sends a packet, it receives the packet and returns back a response..
   
   Finally: This entire network is private, we cannot reach the outside world..
   The outside world cannot reach the services or application hosted inside our namespaces..
   The only route to the outside world is through the ethernet port on our host..
   
   How do we configure our bridge network to reach the LAN network (192.168.1.0) via the ethernet port on the host?
   
   Lets say we have another host attached to our LAN network with the ip 192.168.1.3
   NOTE: Our host has a LAN attached to it and we are assuming that the LAN has another host attached to it. 
   How do i reach this HOST IP from my namespaces?
   lETS PING IT FROM THE BLUE NAMESPACE
   ip netns exec blue ping 192.168.1.3
   
   This will return an unreachable message...
   A look at the route of the blue namespace..
   ip netns exec blue route, this displays that it does not not kwn or have a route to the outside network attached to our LAN.
   
   We need to add an entry or a door, a gateway to the outside world..
   This is just a system on the local network that connects to the other networks..
   A passage to the other network..
   
   What is the system that has one interface on the network local to the blue namespace or the bridge network on 192.168.15.0 and is also connected to the outside LAN network???
   That is our localhost. Our localhost with the ip 192.168.1.2 has an interface to the bridge network(v-net-0) which enables it to ping the namespaces and also an ethernet port <eth0> interface connecting to the LAN outside.
   Therfore our host becomes our gateway or our door to the outside world...
   
   Important:
   We are trying to reach the outside world. Remember, there is a LAN in bw 2 hosts. Our localhost and the other host.
   To reach the outside network, we add a route on our blue namespace to reach it.
   
   ip netns exec blue route add <ip-address-of-the-LAN> via <the-ip-address-v-net-0>
   NB: The LAN links both hosts and our localhost interfaces with v-net-0 with ip 192.168.15.5
   
   ip netns exec blue route add 192.168.1.0/24 via 192.168.15.5
   
   ping the outside host again from the blue namespace..
   ip netns exec blue ping 192.168.1.3
   
   You no longer get an unreachable msg from the command but you dont get response from the network..
   This is b/c the outside network does not know about the internal bridge network and ips.
   How do we solve this?
   We need NAT enabled on our host acting as a gateway so that that it can send msgs to the LAN in its own name with its own address. \(since the LAN knows/is linked to our host)\
   
   We use the iptables to add NAT functionality to our host..
   RUN:
   iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -J MASQUERADING
   
   Add a new rule in the NAT iptables, in the POSTROUTING chain to masquerade or replace the from address on all packet coming from the source network 192.168.15.0/24 with its own ip address.
   This way, anyone receiving the packets will think theyre coming from the host and not from within the namespaces..
   
   ping the outside host again from the blue namespace..
   ip netns exec blue ping 192.168.1.3
   
   This works and we are happy..
   
   
   MORE EXPLANATION:
   
   The command you've provided is an `iptables` command used to configure Network Address Translation (NAT) in a Linux system.
    NAT is commonly used for allowing multiple devices on a private network to share a single public IP address for accessing resources on the internet. Let's break down the command:

   - `iptables`: This is the command for configuring the Linux kernel's packet filtering rules, including NAT rules.

   - `-t nat`: This specifies the table within `iptables` where the rule should be added. In this case, it's the "nat" table, which is used for configuring NAT rules.

   - `-A POSTROUTING`: This option specifies that the rule should be appended (`-A`) to the POSTROUTING chain. 
   The POSTROUTING chain is part of the NAT table and is used for post-routing operations, including NAT.

   - `-s 192.168.15.0/24`: This specifies the source IP address or network that should be subject to NAT.
    In this case, it's the source network `192.168.15.0/24`, meaning all IP addresses within the `192.168.15.0` subnet.

   - `-J MASQUERADING`: This specifies the action to take when a packet matches the rule. 
   In this case, it's `MASQUERADING`, which is a form of NAT that allows the source
    IP addresses of outgoing packets from the specified source network (`192.168.15.0/24`) to be replaced with the IP address of the router or firewall performing the NAT.  
   This is typically used for enabling multiple devices on a private network to share a single public IP address for internet access.

   In summary, the command is telling the Linux kernel to apply NAT (MASQUERADING) to 
   outgoing packets from the `192.168.15.0/24` subnet, so that their source IP addresses are replaced with the
    IP address of the router or firewall performing the NAT. This allows devices in the `192.168.15.0/24` network to access resources on the internet using a shared public IP address.
   
   
 
  
	FINALLY SAY THE LAN IS CONNECTED TO THE INTERNET:
	
	We try to ping the internet:
	ip netns exec blue ping 8.8.8.8
	We get a return of network unreachable
	
	Lets check our route to see if we have a route to the internet.
	
	ip netns exec blue route
	This will show you that we do not have a route to the internet but to only the LAN NETWORK <192.168.1.0>
	
	We decide to add a route to the internet.
	
	ip netns exec blue ip route add default via 192.168.15.5 --> we add a door to the internet, if you want to access the internet talk to our host.
	We try to ping the internet again:
	ip netns exec blue ping 8.8.8.8
	We get a return of response... success...
	
	WHAT ABOUT CONNECTIVITY FROM OUTSIDE WORLD TO THE NAMESPACES????????
	
	Lets say the blue namespace hosts a web application on port 80.
	As at the moment, the namespaces are on an internal network and no one from the outside world knows them...
	We can only access resouces externally but cant receive external communication.
	
	Lets try it..
	Let ping the blue namespace network from a host outside our network.
	ping 192.168.15.1
	This will output network unreachable error...
	The host does not know about the private network.
	
	How can we make our internal network be accessed from the outside world.
	How can we make services or application hosted on our internal network be made available to end users??
	
	We have 2 options to solve this::::
	1. To give away the identity of the internal network to the outside host.
	
	we add:
	
	ip netns exec blue ip route add <the-ip-of-blue-namespace> via <The-ip-of-the-host>
	The second ip of our host and not the v-net-0 ip which is also on our host.
	But this is not what we want.
	
	Alternatively, 
	
	We add portforwarding options using iptable rule to say any traffic coming from port 80 on the localhost is to be forwarded to port 80 on the IP assigned to the blue namespace.
	
	iptables -t NAT -A PREROUTING --dport 80 --to-destination 192.168.15.1:80 -J DNAT
	Now ping 192.168.15.1 from the external host:
	This will give you a response..
	
	MORE ON THE COMMAND:
	The command you've provided is an `iptables` command used to configure port forwarding in a Linux system. 
	Specifically, it's configuring Destination Network Address Translation (DNAT) in the PREROUTING chain of the NAT (Network Address Translation) table. Let's break down the command:

	- `iptables`: This is the command for configuring the Linux kernel's packet filtering rules, including NAT rules.

	- `-t NAT`: This specifies the table within `iptables` where the rule should be added. In this case, it's the "nat" table, which is used for configuring NAT rules.

	- `-A PREROUTING`: This option specifies that the rule should be appended (`-A`) to the PREROUTING chain. 
	The PREROUTING chain is part of the NAT table and is used for performing actions on packets before they are routed.

	- `--dport 80`: This specifies the destination port (`--dport`) that incoming packets should match.
	 In this case, it's port 80, which is commonly used for HTTP traffic.

	- `--to-destination 192.168.15.1:80`: This option specifies the new destination for packets that match the rule.
	 It means that incoming packets with a destination port of 80 will be forwarded to the IP address `192.168.15.1` on port 80.

	- `-J DNAT`: This specifies the action to take when a packet matches the rule.
	 In this case, it's `DNAT`, which stands for Destination Network Address Translation. DNAT is used to modify the destination IP address and/or port of incoming packets.

	In summary, this `iptables` command is configuring port forwarding for incoming traffic that arrives at port 80 on the host where the rule is applied. 
	It forwards incoming HTTP traffic (port 80) to the internal host with the IP address `192.168.15.1` on port 80. 
	
This is a common setup for exposing a web server hosted on an internal network to external traffic by forwarding incoming requests from the host's port 80 to the internal server's port 80.

IMPORTANT:

	While testing the Network Namespaces, if you come across issues where you can’t ping one namespace from the other,
	 make sure you set the NETMASK while setting IP Address. ie: 192.168.1.10/24

	ip -n red addr add 192.168.1.10/24 dev veth-red

	Another thing to check is FirewallD/IP Table rules. Either add rules to IP Tables to allow traffic from one namespace to another.
	 Or disable IP Tables all together (Only in a learning environment).
	 
	 

	 Prerequisite Docker Networking:
	 How does manages network in Linux.
	 Lets start with a single docker host. A server with docker install on it.
	 This server has an ethernet port or interface at eth0 with the ip.. 192.168.1.10 that connects to the local area network LAN.
	 When you run a docker container, you have diff network options to choose from..
	 
	 1. The none network
	 2. The host network
	 3. The bridge network
	 
	 1. The none network: When you run containers using this network, they're isolated from each other and are not part of any network, these containers cannot talk to the outside world..
	 These containers cannot be accessed also from the outside..
	 
	 2. The host network: The container is attached to the host network and there is no network isolation bw the container and the host.
	 If you deploy a web application on port 80, the web application is available on port 80 on the host.
	 You do not need to do additional configuration and you do not have to do a port mapping..
	 If you try to run another instance of a container that runs on the same port, it wont work as they share the same host networking and 2 processes cannot run on the same port at the same time.
	 
	 3. The bridge Network: In this case an internal network is created which the docker host and networks attach to. say the network has an ip 172.17.0.0 by default and each
	 devices connecting to this network, gets their internal network address from this network.
	 
	 HOW does docker manage this network??
	 
	 When you install docker on a host, it creates an internal network called bridge by default.
	 Run docker network ls ---> This shows you the network
	 Docker calls this network bridge but on the host is called docker0
	 
	 Run: ip link command on the host and look at the output.
	 You will see the docker0 interface.
	 
	 Docker uses  the same techniques as we saw in the network namespace in linux by running.
	 
	 ip link add docker0 type bridge
  
     This creates a switch/network/interface on the host that will be used to link the namespaces.
     To the namespaces its a switch to connect them
     To the host is just another interface on it.
	 
	 So the interface on the host, docker0 is assigned an ip of 172.17.0.1 
	 Run:
	 ip addr comand on the host --> This will show you the ip address of the docker0 interface..
	 
	 Whenever a container is created docker creates a network namespace for it.
	 Run:
	 ip netns --> List the namespaces
	 More on this to display the namespaces associated with each containers..
	 
	 Run:
	 docker container inspect <container-id> --> This output will show you the namespace associated with the said container..
	 
	 How does docker attach the network namespace or the container to the bridge network???
	 
	 Important: 
	 In our context, a container and a network namespace means the same thing....
	 
	 When i say container, iam referring to the namespace created for that container...
	 
	 HOW DOES DOCKER ATTACH THE CONTAINER TO THE BRIDGE??
	 
	 Docker also uses the same techniques that we used in network namespace in linux.
	 
	 It creates a virtual cable/pipe/ and attach one end to the conatiner/namespace and the other on the docker0 interface.
	 
	 example:
	 run ip link command on the host --> You will also see the one end of the pipe/cable/ that was attached to the docker0 interface. (vethbb1c...@if7)
	 RUN: ip netns exec <name-of-the-namespace-or-numbers> ip link --> This will show you the other end of the pipe/cable attached to the namespace. (eth0@if8)
	 
	 NB They end with odd numbers and even numbers when you look closely at the pipes/cables..
	 The interface/namespace also gets an ip address assigned to it.
	 You can see this by running, 
	 ip netns exec <namespace name> ip addr
	 
	 This will show you the ip assigned to the interface/namespace/container and this is also referred to as the container ip.
	 This same process is repeated by docker eachtime a container is created..
	 Say we have multiple containers, docker follows this pattern and the containers can now talk to each other
	 
	
	 PORT MAPPING:
	 
	 Lets say the container we deployed is an nginx container running on port 80 on the namespace.
	 Other containers cannot access this container except theyre in the same network.
	 But the host itself can access these containers.
	 
	 Lets say you try to access the container from the docker host on port 80:
	 
	 e.g
	 curl http://172.17.0.30:80
	 You'll be able to access it.
	 .....
	 Lets try doing the same thing from outside the host...
	 curl http://172.17.0.30:80
	 
	 Youre unable to reach the website.
	 
	 To allow external users to access the application, docker provides port publishing or port mapping option..............
	 
	 docker run -dit nginx -p 8080:80
	 
	 When you run your container, you have to tell docker to map port 8080 on the docker host to port 80 on the container.........
	 When you do this, any traffic coming on port 8080 on the host will be forwarded to port 80 on the container, this way all of your external users can then access the application externally using
	 the ip address of the host and port 8080
	 
	 HOW DOES DOCKER DO THIS?
	 HOW DOES IT FOWARD TRAFFIC FROM ONE PORT TO ANOTHER???????
	 Lets say the requirement is to forward traffic from one port to another port on the server!
	 We create a NAT rule for that, using iptables 
 	iptables -t NAT -A PREROUTING -J DNAT --dport 8080 --to-destination 80
	
	DOCKER DOES IT THE SAME WAY:
	
	
 	iptables -t NAT -A DOCKER -J DNAT --dport 8080 --to-destination <IP-OF-THE-CONTAINER>:80
	
	You can see the rules docker creates when you list the rules in iptables:
	iptables -nVL -t NAT
	 
	................
	The command you've provided is an `iptables` command used in the context of Docker container networking. 
	It configures a rule in the NAT (Network Address Translation) table to perform Destination Network Address Translation (DNAT). 
	This is typically used in Docker to forward incoming traffic from a host port to a port inside a running Docker container. Let's break down the command:

	- `iptables`: This is the command for configuring the Linux kernel's packet filtering rules, including NAT rules.

	- `-t NAT`: This specifies the table within `iptables` where the rule should be added. In this case, it's the "nat" table, which is used for configuring NAT rules.

	- `-A DOCKER`: This specifies that the rule should be appended (`-A`) to the DOCKER chain. The DOCKER chain is used by Docker to manage network traffic to and from containers.

	- `-J DNAT`: This option specifies the action to take when a packet matches the rule. 
	
	In this case, it's `DNAT`, which stands for Destination Network Address Translation. It is used to modify the destination IP address and/or port of incoming packets.

	- `--dport 8080`: This specifies the destination port (`--dport`) that incoming packets should match. In this case, it's port 8080, which is the host port you want to forward traffic to.

	- `--to-destination <IP-OF-THE-CONTAINER>:80`: This option specifies the new destination for packets that match the rule.
	 It forwards incoming packets with a destination port of 8080 to the IP address of the Docker container (`<IP-OF-THE-CONTAINER>`) on port 80.

	In Docker, this rule is used to allow incoming traffic to reach a specific container by mapping a host port to a container port. 
	For example, if you want to access a web server running inside a Docker container on port 80, you can configure this rule to forward traffic from port 8080 on the host to port 80 inside the container.

	The command to list the rules in the NAT table (`iptables -nVL -t NAT`) is useful for inspecting and verifying the configured rules, including Docker-related rules for network address translation.
	



	Prerequisite CNI:
	On network name spaces in Linux:
	STEPS:
	1. Create Network Namespace
	2. Create Bridge Network/interface
	3. Create VETH pairs (Pipe,Virtual Cable)
	4. Attach Veth to Namespace
	5. Attach other Veth to Bridge
	6. Assign IP Addresses
	7. Bring the Interfaces UP
	8. Enable NAT - IP Masquerade


	We also Saw how Docker did it using the bridge option. It was the same way just that it uses diff naming pattern:

	On network name space in linux by Docker:
	STEPS:
	1. Create Network Namespace
	2. Create Bridge Network/interface
	3. Create VETH pairs (Pipe,Virtual Cable)
	4. Attach Veth to Namespace
	5. Attach other Veth to Bridge
	6. Assign IP Addresses
	7. Bring the Interfaces UP
	8. Enable NAT - IP Masquerade
	 
	The same pattern is been adopted by other container orchestrators like MESOS,RKT,K8S.
	
	What is CNI?

	Now about CNI, it’s a set of standards that must be adhered by network solutions in other for it to work with Kubernetes,MESOS,RKT etc without having to modify or change the k8s source code right? 


	Yes, that's correct! The Container Network Interface (CNI) is a set of standards and specifications that network solutions must 
	adhere to in order to work with Kubernetes seamlessly, without needing to modify or change the Kubernetes source code. 
	CNI provides a standardized way for network plugins to configure and manage networking for pods within a Kubernetes cluster.

	Key points about CNI:

	1. **Standardized Interface:** CNI defines a standardized interface and set of conventions that network plugins can follow. 
	This standardization ensures that network solutions can be used interchangeably with Kubernetes, as long as they adhere to the CNI specification.

	2. **Flexibility:** Because Kubernetes relies on the CNI interface, it can work with a wide range of network plugins. 
	Different plugins, such as Calico, Flannel, Weave, and more, can be used to meet specific networking requirements without altering Kubernetes itself.

	3. **No Kubernetes Source Code Changes:** Kubernetes does not need to be modified to support different network solutions, thanks to CNI. 
	This separation of concerns allows for easier integration and maintenance of Kubernetes clusters with diverse networking needs.

	In summary, CNI serves as a standardized bridge between Kubernetes and network plugins, enabling Kubernetes to remain agnostic 
	about the specific networking technology being used while allowing users to choose the network solution that best fits their requirements.
	This design philosophy promotes interoperability and simplifies the management of networking in Kubernetes clusters.
	
	Important:
	
	Instead of each Network solutions working separately and developing the same solutions multiple times, why not create a single standard approach that everyone can follow?
	So we take all the ideas from diff network solutions and move all of the networking portions of it into a single code.
	Since this is for the bridge network we call it bridge..
	So we develop a script that runs and performs a task to get the container attached to a bridge network.
	
	The script will impliment these portions:
	2. Create Bridge Network/interface
	3. Create VETH pairs (Pipe,Virtual Cable)
	4. Attach Veth to Namespace
	5. Attach other Veth to Bridge
	6. Assign IP Addresses
	7. Bring the Interfaces UP
	8. Enable NAT - IP Masquerade
	
	Once the script is created, This command is ran to add the conatiner to a network..
	
	bridge add <cid> /var/run/netns/namespace
	
	NB: cid = namespace, so you must use the name of the conatiner as the name of the namespace.
	
	Say you want to create your own network solution.. How do you know that container runtimes or orchestrators like k8s, rkt, mesos will support it?
	That is where CNI comes in to play. You must develop that solution using CNI standard for it to work with orchestrators that support CNI.
	
	CNI STANDARDS FOR CONTAINER RUNTIMES OR ORCHESTRATORS:
	......................................................
	1. Container Runtimes must create network namespace
	2. Indentify network the container must attach to
	3. Container Runtime to invoke Network Plugin (bridge) when container is ADDed
	4. Container Runtime to invoke Network Plugin (bridge) when container is DELeted
	5. JSON format of the Network configuration
	
	
	CNI STANDARDS FOR NETWORK PLUGIN/NETWORK SOLUTIONS
	-------------------------
	1. Must support command line arguments ADD/DEL/CHECK
	2. Must support parameters container id, network ns etc
	3. must manage ip address assignment to pods
	4. must return results in a specific format.
	
	
	CNI COMES WITH A SET OF SUPPORTED PLUGINS ALREADY.
	When i say plugin, it also means network solutions. e.g.
	Bridge, vlan, ipvlan, macvlan,windows, dhcp,host-local.
	
	There are other plugin available from third party org such as.
	flannel, weaveworks, vmware nxs, calico, cilium any of these solutions follows cni standards and can be used for container runtimes that are onboard with cni e.g k8s,rkt,mesos.
	
	Important:
	Docker a container runtime does not impliment CNI, Docker has its own set of standard called Container Network Model(CNM) which aims at solving networking challenges.
	This is similar to CNI but with minor differnces. Due to this minor differnces, you cant run a docker conatiner and specify that the plugin to use is cni-bridge
	
	e.g docker run --network cni-bridge nginx ---> You cant do this...
	That does not mean you cant run a docker container with CNI-BRIDGE Plugin.
	
	To use docker with CNI compliant plugin like bridge. Run the docker container with a none network and manually invoke the bridge plugin..
	example:
	
	docker container run --network=none nginx
	
	bridge add <cid> /var/run/netns/namespace
	
	Important: With the above method you'll run docker container using CNI-bridge plugin.
	This is also the way kubernetes does it, k8s first creates a container on the none network.
	It then invokes the configured cni plugins. Follows CNI standards.
	
	

	Cluster Networking: Networking configurations on the master and worker nodes in the k8s cluster...
	
	https://kubernetes.io/docs/reference/networking/ports-and-protocols/
	
	Explore the various port that must be opened in your k8s cluster setup using the above link.
	Follow the best practice, the worker, node and master node must have a unique name,Mac addresses, ethernet interface and must be connected to an external network.
	...
	
	

	Important Note about CNI and CKA Exam

	An important tip about deploying Network Addons in a Kubernetes cluster.

	In the upcoming labs, we will work with Network Addons. This includes installing a network plugin in the cluster. 
	While we have used weave-net as an example, please bear in mind that you can use any of the plugins which are described here:

	https://kubernetes.io/docs/concepts/cluster-administration/addons/

	https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model

	In the CKA exam, for a question that requires you to deploy a network addon, unless specifically directed, you may use any of the solutions described in the link above.

	However, the documentation currently does not contain a direct reference to the exact command to be used to deploy a third party network addon.

	The links above redirect to third party/ vendor sites or GitHub repositories which cannot be used in the exam. 
	This has been intentionally done to keep the content in the Kubernetes documentation vendor-neutral.
	
	COMMANDS:
	
	netstat -plnt
	ip addr show etho
	ip addr show type bridge
	
	
	
	

     Pod Networking:
	 Kubernetes networking model:
1. Every pod should have an IP address
2. Every pod should be able to communicate with every other pod in the same node
Every pod should be able to communicate with every other pod on the other nodes without NAT

Important information: The ip address that will be assigned to the bridge interface or the docker0 interface or the v-net-0 interface must be from the range of ip of the source network..

What better way to ensure pods communication accross nodes without having to add route for all created pods one by one on each server for one pod to talk to a pod in a diff node.

1. A better solution is to do that on a router if you have one on your network and point all host to use the router as the default gateway.

e.g
NETWORK                     GATEWAY
           
source network (bridge).     IP OF THE HOST1 or node
source network (bridge).     IP OF THE HOST1
source network (bridge).     IP OF THE HOST2

With this you can manage route of network via the router..

We created a script that execute in each node manully to achive our goal.
But we do not wantt to be running these scripts manually each time a pod is created.
We want to automate it.. What do we do??

THIS IS WHERE CNI COMES IN AND ACTS AS THE MIDDLEMAN...
CNI tells k8s this is how you should call/invoke your script!!
CNI tells us the network solution, this is how our script should look like...

The kubelet on each node is responsible for creating of pods and once a container is created the kubelet looks at the cni configuration passed as a 
--cni-conf-dir=/etc/cni/net.d command line argument when it was run.
it then looks at the cni bin dir --cni-bin-dir=/etc/cni/bin
It identifies our script name and executes it.

./net-script.sh add <cid> <namespace>
	
	
	

CNI in kubernetes:

How and where do we specify the network plugins for k8s to use or invoke them??
The CNI plugin must be invoke by the component in kubernetes responsible for creating the containers..
That component must invoke the appropriate network plugin once the container is created...
CNI plugin is configured on the kubelet on each node in the cluster

Check the kubelet conf file to see the options passed to enable it invoke the cni plugin.
--cni-conf-dir=/etc/cni/net.d ---> has the configuration file, if theyre many, it will kubelet will choose in aphabetical order..
--cni-bin-dir=/etc/cni/bin or /opt/cni/bin ---> has all the supported cni plugins as exe.
--network-plugin=cni

OR run ps -aux | grep -i kubelet
The plugins will show...

Check the plugin configuration file.	
cat /etc/cni/net.d/10-bridge.conf




Note CNI Weave

Important Update: –

Before going to the CNI weave lecture, we have an update for the Weave Net installation link. They have announced the end of service for Weave Cloud.

To know more about this, read the blog from the link below: –

https://www.weave.works/blog/weave-cloud-end-of-service

As an impact, the old weave net installation link won’t work anymore: –

kubectl apply -f “https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d ‘\n’)”

Instead of that, use the below latest link to install the weave net: –

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

Reference links: –

    https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-installation
    https://github.com/weaveworks/weave/releases



Weaveworks cni plugin:
Once a weaveworks cni plugin is deployed on the cluster, it deploys an agent or service on each node on the cluster..	
They communicate with each other to exchange information regarding the nodes, the networks and pods within them.
Each agent or pairs stores a topology of the entire setup that is how they know the ip and port of the other nodes.
Weave creates its own bridge on the node and names it weave, it then assigns ip address to each network.

Important:
What path a packet takes to destination depends on the route configured on the container
ip route

HOW DO WE DEPLOY WEAVE ON THE CLUSTER?
weave/weave peers are deployed as daemons on the cluster..
Theyre deployed manually.
However, if k8s is setup already, the easier way to do it is to deploy it as pod 
	 
	 
deploy:

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

you can view weave peers
k get pod -n kube-system
You will see the weave peers deployed as agents on the other nodes and you will see the one for master

check logs

k logs <podname> weave -n kube-system


Solution – Deploy Network Solution:

wget https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

describe the kube-proxy configmap file to check if it was deployed with.
Important:
If you do set the --cluster-cidr option on kube-proxy, make sure it matches the IPALLOC_RANGE given to Weave Net (see below).

NB: Check the --cluster-cidr in the kube-proxy configmap if it was passed as an option then make sure you set an env variable in the weave yaml file.
ALSO IF YOU DEPLOYED YOUR CLUSTER USING --cluster-cidr 

e.g
- name: weave
  env:
    - name: IPALLOC_RANGE
      value: 10.0.0.0/16
	  
	  The value of this env should be the value of the --cluster-cidr in the kube-proxy configmap volume.


additional arguments may be supplied to the Weave router process by adding them to the command: array in the YAML file,
additional parameters can be set via the environment variables listed above; these can be inserted into the YAML file like this:

  containers:
    - name: weave
      env:
        - name: IPALLOC_RANGE
          value: 10.0.0.0/16


ipam weave:

ip address mgt (IPAM) solutions:
host-local
dhcp

 k describe cm -n kube-system kube-proxy
 ip addr show weave
 
 apt-get update
 apt-get install iproute2
 

 Service Networking:
 
 To make pods communicate with each other, you will always use a service..
 When a service is created, it gets an ip assigned to it.
 Lets say we have 2 pods a blue pod and an orange pod
 For the blue pod to talk to the orange pod, it uses service.
 The blue pod can talk to the orange pod via the name of the service of the orange pod or via the ip address of the service of the orange pod.
 
 When services are created, its accessible from any node in the cluster. It is a cluster wide resource..
 While a pod is hosted on a node, a service is hosted accross the cluster..
 It is not bound to a specific node.. But the service is only accessible from within the cluster and its called ClusterIP service..
 
 How are the services getting their ip addresses? How are they made available across all nodes in the cluster??
 How are services made available to external users through a port on each node.
 WHos doing that and how when do we see it???
 
 Each node runs a component called kube-proxy..
 Kube proxy watches the apiserver for new services and everytime a new service is created.
 kube-proxy agent on each nodes, gets the ip of that service and creates a forwarding rule saying.
 
 Any traffic coming to this service, the ip of the service, should be forwarded or go to the ip of the pod.
 With this in place, whenever a pod trys to reach the ip of the service, it is forwarded to the ip of the pod.
 Its not just an ip, its an ip end port combination.
 
 HOW ARE THESE RULES CREATED/Practice test and commands
 kube-proxy supports
 1. userspace
 2. ipvs
 3. iptables
 
 The proxy mode can be set while configurring kube-proxy.
 If this is not set, it defaults to kube-proxy....
 see below:
 kube-proxy --proxy-mode [iptables | ipvs | userspace]
 
 Where does the service gets its ip from?
 This is passed as option  in the kube-apiserver configuration on..
kube-apiserver --service-cluster-ip-range ipNet (Default 10.0.0.0/24)
also you check

ps aux | grep kube-api-server
ps -aux | grep kube-api-server

You will see what the range of ip is..

Important:
The pod and the service should have its distinct range of ip to work with in other to avoid overlap..
 
 
 k get pods -o wide
 look for the ip of the pod and note it..
 
 k get svc 
 look for the ip address of the svc and note it.
 
 run iptables -L -t nat | grep <service name>
 
 Analyse the output:
 Youll see the first rule: where the ip of the service is specified...
 You will see on the DNAT RULE
 The rule means that any traffic going to the ip of the service on a specified port (dpt)
 Should be forwarded to the ip of the pod an a specified port.
 
 Check kube-proxy creates this logs by running:
 cat /var/log/kube-proxy.log
 
 
 k exec busybox -- ip route
 default via 10.244.192.0 dev eth0 
 10.244.0.0/16 dev eth0 scope link  src 10.244.192.2 
 
 You can check the proxy the kube-proxy is using by running:
 k logs kube-proxy-b4zll  -n kube-system 
 
 grep -i kube-apiserver | grep -i range
 
1. To check range of ip for a node, run the k get nodes -o wide and get the ip of the node,
  the run ip addr command and check the interface that matches the node ip and youll see the cidr range.
  
  2. For pod check the ip allocrange in the output of the kube-proxy logs.
  
  Or check the cni file cat /etc/cni/net.d/10-weave67678
  check the name of plugin which is weave
  run ip address show weave
  This will show you the weave interface and the address assigned to it.. That will be where the pods gets it ip from.
  
  3. Service range ip:
  Check the api server config.. --cluster-service-range
  
 
	

  DNS in kubernetes:
  1. What names are assigned to what objects?
  2. Service DNS records
  3. Pod DNS Records
  What are the differerent ways you can reach one pod from another?
  When a Service is created, the dns solution of the clusters creates a DNS records that maps the name of the service to the ip of the service
  So within the cluster, any pod can reach the pod which has service created for it using the name of the pods service.
  This works when the both pods are in the same namespace..
  
  What if we have pods in a different namespace.
  How do we reach a pods from one namespace to another.
  Say we have a test pod in the default namespace and a web pod in the apps namespace.
  How can we reach the web pod?
  1.   We create a service for the web pod. Once we create a service for the web pod (web-service). The kubernetes dns service creates a dns record that maps the name of
  the service to the apps namespace
  2. For each namespace the dns server creates a sub domain, if the namespace is apps a subdomain apps will be created..
  3. All the services are then grouped together into another sub domain called svc
  so You can reach your application using:
  web-service.apps.svc
  4. The services are futher grouped into a subdomain called cluster.local --> TLD
  
  You can then reach the pod using:
  web-service.apps.svc.cluster.local.<ipaddressofthesvc> But you dont need to refernce the ip
  The above is the FQDN of the service..
  The above is how services are resolved within the cluster...
  
  What about pods?
  Records about pods are not created by default...
  However, we can enable that explicitly.
  Once enabled records for pods are created as well.. It does not use the pods name.. It generates a name by replaing the pods ip with -  eg
  
  hostname            ip
  10-244-10-1         10.244.10.1
  
  You can then reach the pod using:
 10-244-10-1.apps.pod.cluster.local.<ipaddressofthepod> But you dont need to refernce the ip
  The above is the FQDN of the pod..
  The above is how pods are resolved within the cluster...
  
  You can decide to access pods he same namespace with FQDN as well, your choice.. But outside the same namespace FQDN is a must.
  

  CoreDNS in Kubernetes::::
  How is coreDNS deployed in k8s?
  Theyre deployed as pods in k8s. Theyre deployed with 2 replicas for redundancy as part of replicaset within deployment.
  
  coreDNS configuration file is at /etc/coredns/Corefile
  Inside the Corefile are plugins such as
  error --> for handling error
  health --> for health checks
  kubernetes --> This makes coreDNS works with k8s, this is where to TLD/root domain/zone of the cluster is set i.e cluster.local
  pods inscure --> This enables pods dns resolution, is this plugin that adds the dash to pods record. 10-244-10-1.apps.pod.cluster.local.<ipaddressofthepod> 
  It can disbaled by removing the pods insecure from the corefile.
  
  Important:
  The /etc/coredns/Corefile file is passed as a configmap object to the coredns pods.
  Its mounted as a volume and this way if you need to modify it you can easly do that..
  

  When a Service/pod is created, the dns solution of the clusters creates a DNS records that pods/service
  What ip address does the pods use to reach the dns server?
  When you deploy the coredns it creates a svc by default.
  The service is called kube-dns 
  The ip address of this service is configured as a nameserver on pods in the /etc/resolve.conf k8s does it when pods are created...
  Its the kubelete that is responsible for this.
  check the cat /var/lib/kubelet/config.yaml
  Youll see the clusterDNS 10.0.0.0 --> ip of coredns svc
  clusterDomain cluster.local
  
  I.Q:
  What is the IP of the CoreDNS server that should be configured on PODs to resolve services?
  check the cat /var/lib/kubelet/config.yaml
  or
  check the ip of the coredns svc...
   clusterDNS 10.0.0.0
   
  
  check the resolution of the svc.
  Run:
  host <svc-name>
 it will output the FQDN
 web-service.default.svc.cluster.local
 How is this possible that it returned the FQDN?
 The resolve.conf file also has a search entries in it that has
 cat /etc/resolve.conf
 search default.svc.cluster.local svc.cluster.local cluster.local
 this allows you to find the service using any name.
 
 This way you can access svc by running:
 curl http://web-service 
 curl http://web-service.default
 curl http://web-service.default.svc
 curl http://web-service.default.svc.cluster.local
 
 ------
 But You cannot reach a pod this way:
 to reach a pod, you must specify the FQDN e.g
 10-244-10-1.apps.pod.cluster.local.<ipaddressofthepod> 
  
  
 I.Q:
 Where is the configuration file located for configuring the CoreDNS service?
 cat /etc/coredns/Corefile
  
 
 
 Ingress:::
 Ingress helps your users access your application using a single externally accessible url that you can configure to route traffic to diff services within your cluster
 based on the url path, the same time impliment ssl security as well..
 Think of ingress as a layer 7 load balancer built into the kubernetes cluster and can be configured using basic k8s primitives just like any other object that we have been working with in k8s.
 NOTE: Even with ingress, you still need to expose it to make it accessible to the cluster.. Either as a nodeport or cloud native lB.
 
 
 HOW DOES IT WORK? WHAT IS IT? WHERE IS IT?
 HOW CAN YOU CONFIGURE IT AND HOW DOES IT LOADBALANCE?
 HOW DOES IT IMPLIMENT SSL?
 
 WITHOUT INGRESS, HOW WOULD YOU DO ALL OF THIS?
 I WILL USE A REVERSE PROXY LIKE NGINX, HAPROXY, TRAEFIK.
 i will deploy them on my k8s cluster and configure them to route traffic to other services..
 
 Implimenting Ingress:
 1. Use any of the above listed solutions like HAPROXY,TRAEFIK OR NGINX,CONTOUR,ISTIO, GCP HTTPS GCE LB. 
 2. THE SOLUTION YOU DEPLOY IS CALLED INGRESS CONTROLLER
 3. THE SET OF RULES YOU CONFIGURE IS CALLED INGRESS RESOURCES
 Ingress resources are created using definition files.
 
 The k8s cluster does not come with Ingress controller deployed in it by default.
 If you create ingress resources and expect them to work, they wont...
 
 We deploy the ingress controller using nginx solution.
 HTTPS GCE LB and NGINX ingress are supported by the k8s project.
 
 This ingress controllers are not just another LB, the loadbalancer are built inside of it. 
 The ingress controller has an additional inteligence built in it to monitor the kubernetes cluster
 for new resources and definitions and configure the nginx server accordingly....
 
 The ingress controller is deployed as a deployment.
 You create a deployment file for it specifying the right image version..
 The nginx program is stored at 
 /nginx-ingress-controller
 
 1. deployment
 2. svc to expose the deployment
 3. cm to load the config data
 4. sa act for auth --> b/c the ingress controller has add inteligence
 5. role and rolebinding
 
 
 INGRESS RESOURCES:
 This are set of rules applied on the ingress controller..
 1. A rule that says forward an incoming traffic to a single application...
 2. route traffic to diff aps based on the url
 3. route traffic based on path or host based routing...
 
 REF:
 https://kubernetes.io/docs/concepts/services-networking/ingress/
 
 IMPORTANT:

 Article: Ingress

 As we already discussed Ingress in our previous lecture. Here is an update. 

 In this article, we will see what changes have been made in previous and current versions in Ingress.

 Like in apiVersion, serviceName and servicePort etc.

         

 Now, in k8s version 1.20+ we can create an Ingress resource from the imperative way like this:-

 Format - kubectl create ingress <ingress-name> --rule="host/path=service:port"

 Example - kubectl create ingress ingress-test --rule="wear.my-online-store.com/wear*=wear-service:80"

 Find more information and examples in the below reference link:-

 https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-ingress-em- 

 References:-

 https://kubernetes.io/docs/concepts/services-networking/ingress

 https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types
 
 
 Path types

 Each path in an Ingress is required to have a corresponding path type. 
 Paths that do not include an explicit pathType will fail validation. There are three supported path types:

     ImplementationSpecific: With this path type, matching is up to the IngressClass. 
	 Implementations can treat this as a separate pathType or treat it identically to Prefix or Exact path types.

     Exact: Matches the URL path exactly and with case sensitivity.

     Prefix: Matches based on a URL path prefix split by /. Matching is case sensitive and done on a path element by element basis.
	  A path element refers to the list of labels in the path split by the / separator.
	  A request is a match for path p if every p is an element-wise prefix of p of the request path.
	  
	  
	  

Ingress – Annotations and rewrite-target

Different ingress controllers have different options that can be used to customise the way it works.
 NGINX Ingress controller has many options that can be seen here. I would like to explain one such option that we will use in our labs. The Rewrite target option.

 

Our watch app displays the video streaming webpage at http://<watch-service>:<port>/

Our wear app displays the apparel webpage at http://<wear-service>:<port>/

We must configure Ingress to achieve the below. When user visits the URL on the left, his/her request should be forwarded internally to the URL on the right. Note that the /watch and /wear URL path are what we configure on the ingress controller so we can forward users to the appropriate application in the backend. The applications don’t have this URL/Path configured on them:

 

http://<ingress-service>:<ingress-port>/watch –> http://<watch-service>:<port>/

http://<ingress-service>:<ingress-port>/wear –> http://<wear-service>:<port>/

 

Without the rewrite-target option, this is what would happen:

http://<ingress-service>:<ingress-port>/watch –> http://<watch-service>:<port>/watch

http://<ingress-service>:<ingress-port>/wear –> http://<wear-service>:<port>/wear

 

Notice watch and wear at the end of the target URLs. The target applications are not configured with /watch or /wear paths. They are different applications
 built specifically for their purpose, so they don’t expect /watch or /wear in the URLs. And as such the requests would fail and throw a 404 not found error.

 

To fix that we want to “ReWrite” the URL when the request is passed on to the watch or wear applications. 
We don’t want to pass in the same path that user typed in. So we specify the rewrite-target option. 
This rewrites the URL by replacing whatever is under rules->http->paths->path which happens to be
 /pay in this case with the value in rewrite-target. This works just like a search and replace function.

For example: replace(path, rewrite-target)

In our case: replace("/path","/")

 

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /pay
        backend:
          serviceName: pay-service
          servicePort: 8282

 

In another example given here, this could also be:

replace("/something(/|$)(.*)", "/$2")

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  name: rewrite
  namespace: default
spec:
  rules:
  - host: rewrite.bar.com
    http:
      paths:
      - backend:
          serviceName: http-svc
          servicePort: 80
        path: /something(/|$)(.*)

		IMPORTANT: IT IS THE PORT OF THE SERVICE WE ARE SPECIFYING AS THE BACK END PORT.
		
		

Design and Install a Kubernetes Cluster::;
Before you design a cluster, you must ask relevant questions..

1. Purpose
a. Education
Use--> Minikube
Single node cluster with kubeadm/GCP/AWS

b Development and testing
Multi-node cluster with a single master and multi workers.
setup using kubeadm/GCP/AWS/AKS

c. Hosting production applications
High avai. multi node cluster with multi master node.
setup using kubeadm/GCP/AWS/AKS/kops or other supported platform
upto 5000 nodes
upto 150,000 pods per cluster
upto 300,000 total containers
upto 100 pods per node.
  
2. Cloud or Onprem
3. Workloads 
a. How many application are going to be hosted on the cluster
b. What kind of application will be hosted on the cluster.
i. Web application
ii. Big Data/Analytics

4. Application Resource Requirments
  i. CPU intensive
  ii. Memory intensive
  
  5. Traffic 
  i. Heavy traffic
  ii. Burst traffic
  
 



  Choosing Kubernetes Infrastructure:
  turnkey solutions:
  1. vagrant
  2. vmware cloud pks
  3 openshift
  4. cloud foundry cr
  
  hosted solutions:
  1 GKE
  2 EKS
  3. AKS
  4. OPENSHIFT ONLINE
   

Configure High Availability:
In a high availability setup of the k8s cluster, you will have a multiple master nodes kubernetes cluster!
A high availability in the cluster is where you have redundancy for every component in the cluster...
This ensure you do not have a single point of failure.
in a HA setup you have the controlplane component running in each of the master nodes.
How will they designate the task?
Will they share the workloads amongst themselves????
Will they perform the same task at once? It all defers based on what they do.

1. kube-api-server: They will work on one request at a time, theyll both be on an active mode.
We create a loadbalancer that splits traffic bw the api-server.
We point the kubectl utility to the loadbalancer..

2. Scheduler and controller manager: They watch the state of the cluster and take actions....

3. The controller manager: Watches the state of the cluster and takes necessary action to maintain the desired state.
It has controllers such as node, and replication controllers.
If we have multiple controller manager and its replication controller that maintains the state of pod, creating pods at the same time, it might result to more pods 
created than desired.
How do we stop this from happening?

4. Scheduler: The same fate as the controller manager is applicable to the kube-sceduler.
How do we solve this?
1. They must not run in paralle.
2. They run in an active standy mode
3 ONE is active on one node and the other on the second node is on standy...

Who decides which is active and which is passive/stadby??????///
This is achived through a leader elect process!!

1. Kube-controller-manager:
When you configure the controller manager, you must specify the leader elect optio to true..
kube-controller-manager --leader-elect [other options]

When the kube-controller-manager process starts, it trys to get a lease or lock from the kube-controller-manager endpoint.
Which ever process first updates its information on the kube-controller-manager endpoint gains the lease and becomes the active of the 2 or becomes the leader elect..
The other becomes passive/standby..
It holds the lease/lock it aquired for the lease duration <--leader-elect-lease-duration 15s> configured in the kube-controller-manager config file.
The active process then renews the lease every 10s by default. --leader-elect-renew-deadline 10s
Both processes trys to become the leader elect every 2 seconds, that way if one master fails the other process in the other master will aquire the lease/lock and become a leader..

------
kube-controller-manager --leader-elect [other options]
--leader-elect-lease-duration 15s 
--leader-elect-renew-deadline 10s
--leader-elect-retry-periods 2s

4. The kube-scheduler: It follows the same approach as the kube-controller-manager and has the same command line option..

5. ETCD: With etcd there are 2 topology you can configure in k8s.
1. Stacked toplogy --> This is when etcd is deployd as a pod in the kubernetes cluster.
2. External topology --> This is where etcd is hosted on a seprate server from the controlplane.

Which ever solution you choose, you must pass the option to the kube-api-server configuration file pointing at the right etcd-servers.
Since etcd is a distributed database.
data can be written on one etcd instance and read from the other etcd instances, it uses a leader elect option to choose who writes/leader and the follower.
this is why we list the lists of etcd server in the apiserver configuration..


ETCD in HA:
In HA mode. The etcd instances elects a leader and the other instances becomes the follower.
The leader writes data and distributes a copy to the follows which is for reading of data.
If the write request comes through a follower, the follower forwards it to the leader, the leader then writes the data and sends a copy to the followers thus the followers are for reading of data.
A write is considered complete if a leader gets consent from the members.
How do they elect a leader amongst themselves...
How do they ensure a write is propagated across instances of etcd.
ETCD impliments distributed consensous using RAFT protocol..

HOW DOES THIS WORK IN A 3 NODE CLUSTER???
RAFT protocol uses a random timer for initiating request. A random timer is kicked off bw the 3 managers.
The first to finish the timer sends out a request to the other managers requesting for a permission to be the leader.
The other managers uppon receiving the requests sends their vote and that one becomes the leader.

Assuming the role of the leader, at intervals it sends out a request to the other masters that its continuing with it leadership role..
In case the leader didnt send a request due to the server going down, the members initiates a re election process and a new leader is identified or elected.

In a case where a write comes in within a 3 node cluster.
The leader is expected to write the data and replicate it accross the other 2 for them to have a copy.
What if the replication wasnt complete?
Lets the leader was only able to replicate the data to just one of the node and the other wasnt successful?
Will the write be defined as complete??????

The write is only complete if the data can be written to majority of the node in the cluster

in 3 nodes, the majority is 2 and if data can be written to the 2 it will be deemed as complete..

What is majority?
Quorum? The minimum number of node that must be available for the cluster to function well or make a sucessfully write...
Quorum = N/2 +1
where N = total number of nodes..
with an even number quorum cant be implimented and the entire cluster will go down in disaster..

options:
--initial-cluster peer option is how etcd kwns its part of a cluster..

---------------

Important Update: Kubernetes the Hard Way

Installing Kubernetes the hard way can help you gain a better understanding of putting together the different components manually.

An optional series on this is available at our youtube channel here:

https://www.youtube.com/watch?v=uUupRagM7m0&list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo

The GIT Repo for this tutorial can be found here: https://github.com/mmumshad/kubernetes-the-hard-way


Introduction to Deployment with kubeadm:


Resources

The vagrant file used in the next video is available here:

https://github.com/kodekloudhub/certified-kubernetes-administrator-course

Here’s the link to the documentation:

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

1. vm
2. docker
https://kubernetes.io/docs/setup/production-environment/container-runtimes/
https://docs.docker.com/engine/install/ubuntu/
3. kubeadm
4. initialize
5 pod network
6 join

Check your init system 
run ps -p 1

remove the content of this file vi /etc/containerd/config.toml
replace with:

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true

	NB: remove the ... so you dont have error..
	sudo apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00
	sudo apt-mark hold kubelet kubeadm 






 
Install “Kubernetes the kubeadm way:

Go to the documentation and type install kubeadm
1. Installing a container runtime:
Click on container run time and Install and configure prerequisites
https://kubernetes.io/docs/setup/production-environment/container-runtimes/

RUN:

Forwarding IPv4 and letting iptables see bridged traffic

Execute the below mentioned instructions:

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


2. Installing kubeadm, kubelet and kubectl

use the rigt kubernetes apt repo depending on the required version of the component needed.
check:
Kubernetes package repositories

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


Note: In releases older than Debian 12 and Ubuntu 22.04, /etc/apt/keyrings does not exist by default; you can create it by running sudo mkdir -m 755 /etc/apt/keyrings

3. initialize the cluster by running kubeadm init <args>
kubeadm init --apiserver-advertise-address=10.0.72.124 --apiserver-cert-extra-sans=controlplane --pod-network-cidr=10.244.0.0/16

4 join the worker node to the controlplan

5. deploy a network solution..
Install containerd if required.
https://docs.docker.com/engine/install/ubuntu/

sudo apt-cache madison kubeadm --> Use this command to check the versions of the component that exists in the repo you added.

................


Troubleshooting – Section Introduction:


Application Failure: in a 2 tier app..
Check application accessibility:
1. check if the webserver is accessible using curl
curl http://web-service:nodeport
2. check the service, has it discovered service for the endpoint?
compare the selector configured on the service to the one on the pod..

3. check the pods to be sure its in a running state.
check the status and the number of restarts.. This will give you an idea if the app is running or getting restarted..
check the event on the pod by using the describe command.
check the logs of the app using the logs command.

NB: If the pods is getting restarted, the current log might not reflect why it failed previously.
You have to use the watch option to watch the logs and wait for the app to fail again..

k logs <podname> -f  where f = watch 
or
use the --previous option to view the logs of the previous pod.

k logs <podname> -f --previous

4. check the status of the db service
5. check the db pod
6. check the logs of the db pod and check for any error in the database...

I must read the question carefully, understand it b4 doing the task....
Note: The mysql user is root by default it does not need to be set in the mysql pod itself except reqiured...
DB_HOST is the name of the service of the db.. thats how the webapp can talk to it..


  kubectl config set-context [NAME | --current] [--cluster=cluster_nickname] [--user=user_nickname]
[--namespace=namespace] [options]

kubectl config set-context --current --namespace=alpha
curl http://localhost:30081 --> you can curl localhost cuz is a nodeport svc
 
 

Control Plane Failure:
1. Check the nodes status
k get nodes
see if theyre all healthy.

2. Check status of the pods running..
See if theyre all healthy.

3. If we have a cluster deployed using the kubeadm tool, then check the status of the pods in the kube-system namespace and see that theyre all healthy.
k get pods -n kube-system

4. If controleplan component are deployed as native services then.
run:
service kube-apiserver status
service kube-controller-manager status
service kubelet status --> worker node
service kube-scheduler status
service kube-proxy status

4 Check service logs of the controlplane components:

cluster deployed using kubeadm tool use 
k logs kube-apiserver-master -n kube-system

4. cluster deployed using native services:

journalctl -u kube-apiserver
https://kubernetes.io/docs/tasks/debug/debug-cluster/

/etc/kubernetes/controller-manager.conf

alias k=kubectl
complete -o default -F __start_kubectl k

Type kubectl cheat sheet
https://kubernetes.io/docs/reference/kubectl/cheatsheet/
copy:
source <(kubectl completion bash) --> # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
 
 

Worker Node Failure:

Control Plane nodes

    /var/log/kube-apiserver.log - API Server, responsible for serving the API
    /var/log/kube-scheduler.log - Scheduler, responsible for making scheduling decisions
    /var/log/kube-controller-manager.log - a component that runs most Kubernetes built-in controllers, with the notable exception of scheduling (the kube-scheduler handles scheduling).

Worker Nodes
/var/log/kubelet.log - logs from the kubelet, responsible for running containers on the node
/var/log/kube-proxy.log - logs from kube-proxy, which is responsible for directing traffic to Service endpoint

1. Check the node status are they recorded as ready or not ready
k get nodes

2. If theyre recorded as not ready use the kubectl command to describe the node.

k describe node worker-node-01

Look for the below:


conditions:

Type.       status     lastheartbeatTime         Reason                Message

The status are set to
1. true --> can mean good or bad.. True if node is ready is good but true for the rest (type) is bad..
2. false  --> means everything is ok
3. unknown  ---> outofdisk issue, mem issue, pid issue, when these are wrong we have these unknown status..

Important:
unknown status can mean a possible loss of a node..
Check the lastheartbeattime to find out the time when the node might have crashed..
if crashed, bring it back up..

4. check for possible cpu and memory on the node
k top nodes
top
df -h

5. Check the status of the kubelet
service kubelet status

check the kubelet logs for possible issues

journalctl -u kubelet

6. Check the kubelet certificate that theyre not expired..
that theyre in the right group and issued by the right CA.
  
  openssl X509  -in <pathto the crt file> -noout -text
View Certificate Details::::
https://kubernetes.io/docs/tasks/administer-cluster/certificates/

command:
  openssl req  -noout -text -in ./server.csr
  
  
  ISSUE:
  ● kubelet.service - kubelet: The Kubernetes Node Agent
       Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
      Drop-In: /etc/systemd/system/kubelet.service.d
               └─10-kubeadm.conf
       Active: inactive (dead) since Wed 2023-10-11 14:18:56 EDT; 1min 12s ago
         Docs: https://kubernetes.io/docs/home/
      Process: 1954 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=0/SUCCESS)
     Main PID: 1954 (code=exited, status=0/SUCCESS)
	 
	 Check loaded:
	 check active: 
	 
	 after checking journalctl -u kubelet
	 --
	 vi /var/lib/kubelet/config.yaml
	 
	 apiVersion: kubelet.config.k8s.io/v1beta1
	 authentication:
	   anonymous:
	     enabled: false
	   webhook:
	     cacheTTL: 0s
	     enabled: true
	   x509:
	     clientCAFile: /etc/kubernetes/pki/ca.crt
	 authorization:
	   mode: Webhook
	   webhook:
	     cacheAuthorizedTTL: 0s
	     cacheUnauthorizedTTL: 0s
	 cgroupDriver: systemd
	 clusterDNS:
	 - 10.96.0.10
	 clusterDomain: cluster.local
	 containerRuntimeEndpoint: ""
	 cpuManagerReconcilePeriod: 0s
	 evictionPressureTransitionPeriod: 0s
	 fileCheckFrequency: 0s
	 healthzBindAddress: 127.0.0.1
	 healthzPort: 10248
	 httpCheckFrequency: 0s
	 imageMinimumGCAge: 0s
	 kind: KubeletConfiguration
	 logging:
	   flushFrequency: 0
	   options:
	     json:
	       infoBufferSize: "0"
	   verbosity: 0
	 memorySwap: {}
	 nodeStatusReportFrequency: 0s
	 nodeStatusUpdateFrequency: 0s
	 resolvConf: /run/systemd/resolve/resolv.conf
	 rotateCertificates: true
	 runtimeRequestTimeout: 0s
	 shutdownGracePeriod: 0s
	 shutdownGracePeriodCriticalPods: 0s
	 staticPodPath: /etc/kubernetes/manifests
	 streamingConnectionIdleTimeout: 0s
	 syncFrequency: 0s
	 volumeStatsAggPeriod: 0s


	 Check the ca file at the kubelet node
	 /etc/kubernetes/pki/ca.crt
	 
	 /etc/kubernetes/kubelet.conf 
	 /var/lib/kubelet/config.yaml
	 
	 
.Important point:

`/etc/kubernetes/kubelet.conf` and `/var/lib/kubelet/config.yaml` are two distinct configuration files used in a Kubernetes cluster, and they serve different purposes. Let's explain each of them:

1. `/etc/kubernetes/kubelet.conf`:
   - **Purpose**: This file is the kubeconfig file for the kubelet service.
    It contains the configuration information needed for the kubelet to authenticate with the Kubernetes API server and perform its duties in the cluster.
   - **Contents**: Typically, this file contains information like the API server's address, the certificate and private key for authentication,
    and the user context to use for kubelet's interactions with the API server.
   - **Location**: It is usually located in the `/etc/kubernetes` directory on a node in the Kubernetes cluster.
   - **Usage**: The kubelet service uses this configuration to communicate with the Kubernetes control plane components, such as the API server, 
   to register the node, manage pods, and handle other node-specific tasks.

2. `/var/lib/kubelet/config.yaml`:
   - **Purpose**: This file is the kubelet's own configuration file. It defines various settings and options related to the behavior of the kubelet on the node.
   - **Contents**: The `config.yaml` file includes settings such as the node's hostname, the location of the pod manifest directory, 
   the address and port for the kubelet's health endpoint, and various other configuration options that affect how the kubelet operates.
   - **Location**: It is typically located in the `/var/lib/kubelet` directory on a node in the Kubernetes cluster.
   - **Usage**: The kubelet uses this configuration file to control its behavior and how it manages pods and containers on the node.

In summary, `/etc/kubernetes/kubelet.conf` is primarily used for authentication and communication between the kubelet service and 
the Kubernetes control plane, while `/var/lib/kubelet/config.yaml` is used for configuring the behavior of the kubelet itself on the node.

 These two configuration files serve different purposes within the Kubernetes node, and both are crucial for the proper functioning of the kubelet and the Kubernetes cluster as a whole.
 
 
 Important:
 3 senarios for the kubelet
 1. loaded and inactive <dead> --> needs restart
 2. loaded and activating --> check the /var/lib/kubelet/config.yaml uses to manage node, /etc/kubernetes/kubelet.conf kube-apiserver authentication file.
 3. loaded and active --> kubelet is good
	 
	 

 ISSUE:
 ssh node01
ssh: Could not resolve hostname node01: Name or service not known

run: k get nodes -o wide and use the nodes ip to ssh.



................................

Network Troubleshooting:
///////////////////////


Network Plugin in kubernetes:

——————–

There are several plugins available and these are some.

1. Weave Net:

To install,

kubectl apply -f
https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

You can find details about the network plugins in the following documentation :

https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy

2. Flannel :

To install,

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

 

Note: As of now flannel does not support kubernetes network policies.

3. Calico :

 

To install,

curl https://docs.projectcalico.org/manifests/calico.yaml -O

Apply the manifest using the following command.

kubectl apply -f calico.yaml

Calico is said to have most advanced cni network plugin.

In CKA and CKAD exam, you won’t be asked to install the cni plugin. But if asked you will be provided with the exact url to install it.

Note: If there are multiple CNI configuration files in the directory, the kubelet uses the configuration file that comes first by name in lexicographic order.
DNS in Kubernetes
—————–

Kubernetes uses CoreDNS. CoreDNS is a flexible, extensible DNS server that can serve as the Kubernetes cluster DNS.

Memory and Pods

In large scale Kubernetes clusters, CoreDNS’s memory usage is predominantly affected by the number of Pods and Services in the cluster. Other factors include the size of the filled DNS answer cache, and the rate of queries received (QPS) per CoreDNS instance.

Kubernetes resources for coreDNS are:

    a service account named coredns,
    cluster-roles named coredns and kube-dns
    clusterrolebindings named coredns and kube-dns, 
    a deployment named coredns,
    a configmap named coredns and a
    service named kube-dns.

While analyzing the coreDNS deployment you can see that the the Corefile plugin consists of important configuration which is defined as a configmap.

Port 53 is used for for DNS resolution.

    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }

This is the backend to k8s for cluster.local and reverse domains.

proxy . /etc/resolv.conf

Forward out of cluster domains directly to right authoritative DNS server.
Troubleshooting issues related to coreDNS

1. If you find CoreDNS pods in pending state first check network plugin is installed.

2. coredns pods have CrashLoopBackOff or Error state

If you have nodes that are running SELinux with an older version of Docker you might experience a scenario where the coredns pods are not starting. To solve that you can try one of the following options:

a)Upgrade to a newer version of Docker.

b)Disable SELinux.

c)Modify the coredns deployment to set allowPrivilegeEscalation to true:

kubectl -n kube-system get deployment coredns -o yaml | \
  sed 's/allowPrivilegeEscalation: false/allowPrivilegeEscalation: true/g' | \
  kubectl apply -f -

d)Another cause for CoreDNS to have CrashLoopBackOff is when a CoreDNS Pod deployed in Kubernetes detects a loop.

There are many ways to work around this issue, some are listed here:

    Add the following to your kubelet config yaml: resolvConf: <path-to-your-real-resolv-conf-file> This flag tells kubelet to pass an alternate resolv.conf to Pods. For systems using systemd-resolved, /run/systemd/resolve/resolv.conf is typically the location of the “real” resolv.conf, although this can be different depending on your distribution.
    Disable the local DNS cache on host nodes, and restore /etc/resolv.conf to the original.
    A quick fix is to edit your Corefile, replacing forward . /etc/resolv.conf with the IP address of your upstream DNS, for example forward . 8.8.8.8. But this only fixes the issue for CoreDNS, kubelet will continue to forward the invalid resolv.conf to all default dnsPolicy Pods, leaving them unable to resolve DNS.

3. If CoreDNS pods and the kube-dns service is working fine, check the kube-dns service has valid endpoints.

kubectl -n kube-system get ep kube-dns

If there are no endpoints for the service, inspect the service and make sure it uses the correct selectors and ports.
Kube-Proxy
———

kube-proxy is a network proxy that runs on each node in the cluster. kube-proxy maintains network rules on nodes. These network rules allow network communication to the Pods from network sessions inside or outside of the cluster.

In a cluster configured with kubeadm, you can find kube-proxy as a daemonset.

kubeproxy is responsible for watching services and endpoint associated with each service. When the client is going to connect to the service using the virtual IP the kubeproxy is responsible for sending traffic to actual pods.

If you run a kubectl describe ds kube-proxy -n kube-system you can see that the kube-proxy binary runs with following command inside the kube-proxy container.

    Command:
      /usr/local/bin/kube-proxy
      --config=/var/lib/kube-proxy/config.conf
      --hostname-override=$(NODE_NAME)

 

So it fetches the configuration from a configuration file ie, /var/lib/kube-proxy/config.conf and we can override the hostname with the node name of at which the pod is running.

 

In the config file we define the clusterCIDR, kubeproxy mode, ipvs, iptables, bindaddress, kube-config etc.

 
Troubleshooting issues related to kube-proxy

1. Check kube-proxy pod in the kube-system namespace is running.

2. Check kube-proxy logs.

3. Check configmap is correctly defined and the config file for running kube-proxy binary is correct.

4. kube-config is defined in the config map.

5. check kube-proxy is running inside the container

# netstat -plan | grep kube-proxy
tcp        0      0 0.0.0.0:30081           0.0.0.0:*               LISTEN      1/kube-proxy
tcp        0      0 127.0.0.1:10249         0.0.0.0:*               LISTEN      1/kube-proxy
tcp        0      0 172.17.0.12:33706       172.17.0.12:6443        ESTABLISHED 1/kube-proxy
tcp6       0      0 :::10256                :::*                    LISTEN      1/kube-proxy

References:

Debug Service issues:

https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

DNS Troubleshooting:

https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/


ISSUES: 
Pod stucked in creating state.
There was no network solution deployed, i deployed weave and it worked..

ISSUE: POD RUNNING, SVC,EP,SVC NAME ALL OK BUT APP NOT LOADING OR SERVING ENDUSERS.
Kube-proxy in crashloop.
kubectl logs and describe.
showed that it was an issue with the kube proxy config.conf file.. It was the wrong one that was specified diff from what was in the configmap data:



Labs – JSON PATH

To practice more on JSON PATH with hands-on Labs check out the lab exercises in this course:

https://kodekloud.com/p/json-path-quiz

Pre-Requisites – JSON PATH

In the upcoming lecture we will explore some advanced commands with kubectl utility. But that requires JSON PATH. 

If you are new to JSON PATH queries get introduced to it first by going through the lectures and practice tests available here.

https://kodekloud.com/p/json-path-quiz

Once you are comfortable head back here:

I also have some JSON PATH exercises with Kubernetes Data Objects. Make sure you go through these:

https://mmumshad.github.io/json-path-quiz/index.html#!/?questions=questionskub1

https://mmumshad.github.io/json-path-quiz/index.html#!/?questions=questionskub2



Introduction to JSON PATH:

In json, we use a square bracket [] to denote a list and each item in the list is separated by a comma.

www.json2yaml.com --> helps you convert json to yaml

Json path is a query that allows you to pass data in a json or yaml format..
json path when applied allows you to query a data and retreive a specific subset of the data

example: a dictionary in json path.

{
	"car" : {
	   "color" : "blue",
	   "price" : "20,000"	
	},
	
	"bus" : {
	  "color" : "red",
	  "price" : "120,000",
    "owner" : "john"
	
  }

}


To query the above data to retreive a specific data like car or bus.
1. you query get car
2. get bus
...
To the the color of the car, you query
1. get car.color ---> The output will be blue
2. get bus.color ---> red

Note in the dictionary the first key and value should have comma at the end of the value expect the last value.
If you have to specify another dictionary, then you have use comma to separate the first from the second.


Important:

The top level dictionary which has no name is called root element of the json document.
The root element is denoted by a dollar <$>
example:

{
	"car" : {
	   "color" : "blue",
	   "price" : "20,000"	----> This should start with "$" 
	},
	
	"bus" : {
	  "color" : "red",
	  "price" : "120,000",
    "owner" : "john"
	
  }

}
--


example 2

{
  "vehicles": { 
	  "car" : {
	     "color" : "blue",
	     "price" : "20,000"	
	},
	
	 "bus" : {
	    "color" : "red",
	    "price" : "120,000",
      "owner" : "john"
	
  }
    
  }
}

Querying dictionary in a json data:
A query created for a json document with dictionary as its root should start with a dollar sign $.
If the json file has dictionary as the root, start the query with a dollar sign.
 
To query the data, we use $.car, $.car.color, $.bus, $.bus.color

What about the dictionary that has Vehicles?

We query it as follows:
$.vehicles.car, $.vehicles.car.color, $.vehicles.bus.color


Important:
All result of a json path document query are encapsulated within an array.
meaning theyre encapsulated within a pair of square bracket.


IQ:
Which of the following statements is true?
ANS:
A. Dictionary is an unordered collection whereas list is an ordered collection.




..........
In the context of querying JSON data, the dot (.) is used to navigate through the structure of the JSON document to access specific properties or elements within objects. 
It is often used in conjunction with query languages or libraries like JSONPath, jq, or similar tools. Here's how the dot (.) is used in a query:

1. **Accessing Properties**: The dot is commonly used to access properties (keys) within JSON objects. For example, if you have a JSON object like this:

   ```json
   {
     "name": "John",
     "age": 30,
     "address": {
       "street": "123 Main St",
       "city": "New York"
     }
   }
   ```

   You can use the dot notation to access specific properties:

   - To access the "name" property: `$.name`
   - To access the "city" property within the "address" object: `$.address.city`

2. **Iterating Arrays**: When working with arrays in JSON, you can use the dot notation to iterate through elements of an array. For example:

   ```json
   {
     "fruits": ["apple", "banana", "orange"]
   }
   ```

   - To access the first element of the "fruits" array: `$.fruits[0]`
   - To access the second element of the "fruits" array: `$.fruits[1]`

3. **Combining Paths**: You can use dots to combine multiple levels of navigation in a single query. For example:

   ```json
   {
     "user": {
       "profile": {
         "name": "Alice",
         "age": 25
       }
     }
   }
   ```

   - To access the "name" property within the "profile" object: `$.user.profile.name`

The dot (.) is a convenient and intuitive way to navigate and access data within a JSON document. 
It allows you to specify the hierarchy of keys and objects to reach the desired data within the structure.


A LIST OR AN ARRAY IN A JSON PATH:

To query a json path document in a list, we use index..
To query the below employees json path.
$.employees[0] --> This will output the first elemt in the list
$.employess[0].name --> this will output the name Alice from the first element
$.employess[*].name --> this will iterate and output all the names in the lists.


{
  "employees": [
    {
      "id": 1,
      "name": "Alice",
      "department": "HR"
    },
    {
      "id": 2,
      "name": "Bob",
      "department": "Engineering"
    },
    {
      "id": 3,
      "name": "Charlie",
      "department": "Marketing"
    }
  ]
}
```

Certainly, here's an example of JSONPath used to query data within an array in a JSON document. Consider the following JSON document:

```json
{
  "employees": [
    {
      "id": 1,
      "name": "Alice",
      "department": "HR"
    },
    {
      "id": 2,
      "name": "Bob",
      "department": "Engineering"
    },
    {
      "id": 3,
      "name": "Charlie",
      "department": "Marketing"
    }
  ]
}
```

Now, let's say you want to use JSONPath to query the names of all employees in the "employees" array. You can use the following JSONPath query:

- To access all "name" properties within the "employees" array:
  - JSONPath: `$.employees[*].name`

This JSONPath query uses `[*]` to iterate through all elements in the "employees" array and then selects the "name" property for each employee. 
When you apply this query, it would return an array of names:

```json
["Alice", "Bob", "Charlie"]
```

JSONPath is a powerful tool for extracting and querying data from JSON documents, and it allows you to specify complex queries to navigate through the structure of your data.


Querrying a dictionary and a list::
-----------------------------------

[
	
	12
	13
	5
	99
	90
	
	33
	46
	
]

$[ ? (    each item in the list   )    ] --> ?() is used to specify a criteria or filter or check if

 
@ --> is used to represent each item in the list..

so we have

$[ ? (   @ > 40   ) 
	
	MORE: You can use
	
	@ == 40
	@ != 40
	@ in [40,43,45] ---> Returns all the numbers that are 40,43 and 45
	@ nin [40,43,45] ---> Returns all the numbers not in 40,43 and 45
	
	
--------------------------------
	
example:
 
Yes, your JSONPath expression is almost correct. To get the numbers greater than 10 from the array, you can use the following JSONPath expression:

```json
$[?( @ > 10 )]
```

In this expression:

- `$` refers to the root of the JSON array.
- `[?( @ > 10 )]` is a filter expression. It selects elements in the array that satisfy the condition of being greater than 10.

Given your example array:

```json
[
  10,
  11,
  90,
  77,
  90,
  100,
  90,
  99,
  1,
  2,
  3,
  88
]
```

When you apply the JSONPath expression `$[?( @ > 10 )]`, it will return an array of numbers greater than 10:

```json
[11, 90, 77, 90, 100, 99, 88]
```

This expression filters the array and selects only the numbers that are greater than 10.


....
QUESTION:
Develop a JSON path query to extract the model of the third wheel of the car.

{
  "car": {
    "color": "blue",
    "price": "$20,000",
    "wheels": [
      {
        "model": "KDJ39848T",
        "location": "front-right"
      },
      {
        "model": "MDJ39485DK",
        "location": "front-left"
      },
      {
        "model": "KCMDD3435K",
        "location": "rear-right"
      },
      {
        "model": "JJDH3434KK",
        "location": "rear-left"
      }
    ]
  }
}

ANSWER:
$.car.wheels[?( @.location == "rear-right" )].model This also means $.car.wheels[2].model


2.QUESTION:
Retreive the 3rd month's pay details of the employee.
{
  "employee": {
    "name": "john",
    "gender": "male",
    "age": 24,
    "address": {
      "city": "edison",
      "state": "new jersey",
      "country": "united states"
    },
    "payslips": [
      {
        "month": "june",
        "amount": 1400
      },
      {
        "month": "july",
        "amount": 2400
      },
      {
        "month": "august",
        "amount": 3400
      }
    ]
  }
}


ANSWER:
$.employee.payslips[?( @.month == "august" )] this also means $.employee.payslips[2]

The first answer is better b/c if the data admin did not enter the data in an orderred manner or it was a mistake, then it wont be wont be the 3rd item in the list.


MORE:
IQ: 

Retreive the 3rd month's pay amount of the employee.

ANS:

$.employee.payslips[?(@.month == "august" )].amount


I.Q:
{
  "property1": "value1",
  "property2": "value2"
}

ANS:
$.property1,property2
......................


Develop a JSON path query to extract the price of the car and the bus.
$.vehicles.*.price

{
  "vehicles": {
    "car": {
      "color": "blue",
      "price": "$20,000"
    },
    "bus": {
      "color": "white",
      "price": "$120,000"
    }
  }
}
....
IQ


Develop a JSON path query to extract the models of all wheels.
[
  {
    "model": "KDJ39848T",
    "location": "front-right"
  },
  {
    "model": "MDJ39485DK",
    "location": "front-left"
  },
  {
    "model": "KCMDD3435K",
    "location": "rear-right"
  },
  {
    "model": "JJDH34234KK",
    "location": "rear-left"
  }
]

ANS:
$[*].model

IQ


Develop a JSON path query to extract the models of all wheels of the car.
{
  "car": {
    "color": "blue",
    "price": "$20,000",
    "wheels": [
      {
        "model": "KDJ39848T",
        "location": "front-right"
      },
      {
        "model": "MDJ39485DK",
        "location": "front-left"
      },
      {
        "model": "KCMDD3435K",
        "location": "rear-right"
      },
      {
        "model": "JJDH34234KK",
        "location": "rear-left"
      }
    ]
  }
}

$.car.wheels[*].model


I.Q
Develop a JSON path query to extract models of all wheels of car and bus .
{
  "car": {
    "color": "blue",
    "price": "$20,000",
    "wheels": [
      {
        "model": "KDJ39848T",
        "location": "front-right"
      },
      {
        "model": "MDJ39485DK",
        "location": "front-left"
      },
      {
        "model": "KCMDD3435K",
        "location": "rear-right"
      },
      {
        "model": "JJDH34234KK",
        "location": "rear-left"
      }
    ]
  },
  "bus": {
    "color": "white",
    "price": "$120,000",
    "wheels": [
      {
        "model": "BBBB39848T",
        "location": "front-right"
      },
      {
        "model": "BBBB9485DK",
        "location": "front-left"
      },
      {
        "model": "BBBB3435K",
        "location": "rear-right"
      },
      {
        "model": "BBBB4234KK",
        "location": "rear-left"
      }
    ]
  }
}
 $.*.wheels.[*].model
 
 
 IQ
 Retreive all the amount's paid to the employee from his payslips data.
 
 {
   "employee": {
     "name": "john",
     "gender": "male",
     "age": 24,
     "address": {
       "city": "edison",
       "state": "new jersey",
       "country": "united states"
     },
     "payslips": [
       {
         "month": "june",
         "amount": 1400
       },
       {
         "month": "july",
         "amount": 2400
       },
       {
         "month": "august",
         "amount": 3400
       }
     ]
   }
 }
 
 $.employee.payslips.[*].amount
 
 
 I.Q:
 Give this a shot. Try to find the first names of all winners in the below list of Noble Prize Winners.
 
 {
   "prizes": [
     {
       "year": "2018",
       "category": "physics",
       "overallMotivation": "\"for groundbreaking inventions in the field of laser physics\"",
       "laureates": [
         {
           "id": "960",
           "firstname": "Arthur",
           "surname": "Ashkin",
           "motivation": "\"for the optical tweezers and their application to biological systems\"",
           "share": "2"
         },
         {
           "id": "961",
           "firstname": "Gérard",
           "surname": "Mourou",
           "motivation": "\"for their method of generating high-intensity, ultra-short optical pulses\"",
           "share": "4"
         },
         {
           "id": "962",
           "firstname": "Donna",
           "surname": "Strickland",
           "motivation": "\"for their method of generating high-intensity, ultra-short optical pulses\"",
           "share": "4"
         }
       ]
     },
     {
       "year": "2018",
       "category": "chemistry",
       "laureates": [
         {
           "id": "963",
           "firstname": "Frances H.",
           "surname": "Arnold",
           "motivation": "\"for the directed evolution of enzymes\"",
           "share": "2"
         },
         {
           "id": "964",
           "firstname": "George P.",
           "surname": "Smith",
           "motivation": "\"for the phage display of peptides and antibodies\"",
           "share": "4"
         },
         {
           "id": "965",
           "firstname": "Sir Gregory P.",
           "surname": "Winter",
           "motivation": "\"for the phage display of peptides and antibodies\"",
           "share": "4"
         }
       ]
     },
     {
       "year": "2018",
       "category": "medicine",
       "laureates": [
         {
           "id": "958",
           "firstname": "James P.",
           "surname": "Allison",
           "motivation": "\"for their discovery of cancer therapy by inhibition of negative immune regulation\"",
           "share": "2"
         },
         {
           "id": "959",
           "firstname": "Tasuku",
           "surname": "Honjo",
           "motivation": "\"for their discovery of cancer therapy by inhibition of negative immune regulation\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2018",
       "category": "peace",
       "laureates": [
         {
           "id": "966",
           "firstname": "Denis",
           "surname": "Mukwege",
           "motivation": "\"for their efforts to end the use of sexual violence as a weapon of war and armed conflict\"",
           "share": "2"
         },
         {
           "id": "967",
           "firstname": "Nadia",
           "surname": "Murad",
           "motivation": "\"for their efforts to end the use of sexual violence as a weapon of war and armed conflict\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2018",
       "category": "economics",
       "laureates": [
         {
           "id": "968",
           "firstname": "William D.",
           "surname": "Nordhaus",
           "motivation": "\"for integrating climate change into long-run macroeconomic analysis\"",
           "share": "2"
         },
         {
           "id": "969",
           "firstname": "Paul M.",
           "surname": "Romer",
           "motivation": "\"for integrating technological innovations into long-run macroeconomic analysis\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2014",
       "category": "peace",
       "laureates": [
         {
           "id": "913",
           "firstname": "Kailash",
           "surname": "Satyarthi",
           "motivation": "\"for their struggle against the suppression of children and young people and for the right of all children to education\"",
           "share": "2"
         },
         {
           "id": "914",
           "firstname": "Malala",
           "surname": "Yousafzai",
           "motivation": "\"for their struggle against the suppression of children and young people and for the right of all children to education\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2017",
       "category": "physics",
       "laureates": [
         {
           "id": "941",
           "firstname": "Rainer",
           "surname": "Weiss",
           "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
           "share": "2"
         },
         {
           "id": "942",
           "firstname": "Barry C.",
           "surname": "Barish",
           "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
           "share": "4"
         },
         {
           "id": "943",
           "firstname": "Kip S.",
           "surname": "Thorne",
           "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
           "share": "4"
         }
       ]
     },
     {
       "year": "2017",
       "category": "chemistry",
       "laureates": [
         {
           "id": "944",
           "firstname": "Jacques",
           "surname": "Dubochet",
           "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
           "share": "3"
         },
         {
           "id": "945",
           "firstname": "Joachim",
           "surname": "Frank",
           "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
           "share": "3"
         },
         {
           "id": "946",
           "firstname": "Richard",
           "surname": "Henderson",
           "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
           "share": "3"
         }
       ]
     },
     {
       "year": "2017",
       "category": "medicine",
       "laureates": [
         {
           "id": "938",
           "firstname": "Jeffrey C.",
           "surname": "Hall",
           "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
           "share": "3"
         },
         {
           "id": "939",
           "firstname": "Michael",
           "surname": "Rosbash",
           "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
           "share": "3"
         },
         {
           "id": "940",
           "firstname": "Michael W.",
           "surname": "Young",
           "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
           "share": "3"
         }
       ]
     }
   ]
 }
 
 $.prizes.[*].firstname
 
 
 ......
 IQ
 Let's mix things up. Try to find the first names of all winners of year 2014 in the below list of Noble Prize Winners.
 $.prizes.[?( @.year == 2014 )].[*].firstname
 
 {
   "prizes": [
     {
       "year": "2018",
       "category": "physics",
       "overallMotivation": "\"for groundbreaking inventions in the field of laser physics\"",
       "laureates": [
         {
           "id": "960",
           "firstname": "Arthur",
           "surname": "Ashkin",
           "motivation": "\"for the optical tweezers and their application to biological systems\"",
           "share": "2"
         },
         {
           "id": "961",
           "firstname": "Gérard",
           "surname": "Mourou",
           "motivation": "\"for their method of generating high-intensity, ultra-short optical pulses\"",
           "share": "4"
         },
         {
           "id": "962",
           "firstname": "Donna",
           "surname": "Strickland",
           "motivation": "\"for their method of generating high-intensity, ultra-short optical pulses\"",
           "share": "4"
         }
       ]
     },
     {
       "year": "2018",
       "category": "chemistry",
       "laureates": [
         {
           "id": "963",
           "firstname": "Frances H.",
           "surname": "Arnold",
           "motivation": "\"for the directed evolution of enzymes\"",
           "share": "2"
         },
         {
           "id": "964",
           "firstname": "George P.",
           "surname": "Smith",
           "motivation": "\"for the phage display of peptides and antibodies\"",
           "share": "4"
         },
         {
           "id": "965",
           "firstname": "Sir Gregory P.",
           "surname": "Winter",
           "motivation": "\"for the phage display of peptides and antibodies\"",
           "share": "4"
         }
       ]
     },
     {
       "year": "2018",
       "category": "medicine",
       "laureates": [
         {
           "id": "958",
           "firstname": "James P.",
           "surname": "Allison",
           "motivation": "\"for their discovery of cancer therapy by inhibition of negative immune regulation\"",
           "share": "2"
         },
         {
           "id": "959",
           "firstname": "Tasuku",
           "surname": "Honjo",
           "motivation": "\"for their discovery of cancer therapy by inhibition of negative immune regulation\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2018",
       "category": "peace",
       "laureates": [
         {
           "id": "966",
           "firstname": "Denis",
           "surname": "Mukwege",
           "motivation": "\"for their efforts to end the use of sexual violence as a weapon of war and armed conflict\"",
           "share": "2"
         },
         {
           "id": "967",
           "firstname": "Nadia",
           "surname": "Murad",
           "motivation": "\"for their efforts to end the use of sexual violence as a weapon of war and armed conflict\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2018",
       "category": "economics",
       "laureates": [
         {
           "id": "968",
           "firstname": "William D.",
           "surname": "Nordhaus",
           "motivation": "\"for integrating climate change into long-run macroeconomic analysis\"",
           "share": "2"
         },
         {
           "id": "969",
           "firstname": "Paul M.",
           "surname": "Romer",
           "motivation": "\"for integrating technological innovations into long-run macroeconomic analysis\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2014",
       "category": "peace",
       "laureates": [
         {
           "id": "913",
           "firstname": "Kailash",
           "surname": "Satyarthi",
           "motivation": "\"for their struggle against the suppression of children and young people and for the right of all children to education\"",
           "share": "2"
         },
         {
           "id": "914",
           "firstname": "Malala",
           "surname": "Yousafzai",
           "motivation": "\"for their struggle against the suppression of children and young people and for the right of all children to education\"",
           "share": "2"
         }
       ]
     },
     {
       "year": "2017",
       "category": "physics",
       "laureates": [
         {
           "id": "941",
           "firstname": "Rainer",
           "surname": "Weiss",
           "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
           "share": "2"
         },
         {
           "id": "942",
           "firstname": "Barry C.",
           "surname": "Barish",
           "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
           "share": "4"
         },
         {
           "id": "943",
           "firstname": "Kip S.",
           "surname": "Thorne",
           "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
           "share": "4"
         }
       ]
     },
     {
       "year": "2017",
       "category": "chemistry",
       "laureates": [
         {
           "id": "944",
           "firstname": "Jacques",
           "surname": "Dubochet",
           "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
           "share": "3"
         },
         {
           "id": "945",
           "firstname": "Joachim",
           "surname": "Frank",
           "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
           "share": "3"
         },
         {
           "id": "946",
           "firstname": "Richard",
           "surname": "Henderson",
           "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
           "share": "3"
         }
       ]
     },
     {
       "year": "2017",
       "category": "medicine",
       "laureates": [
         {
           "id": "938",
           "firstname": "Jeffrey C.",
           "surname": "Hall",
           "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
           "share": "3"
         },
         {
           "id": "939",
           "firstname": "Michael",
           "surname": "Rosbash",
           "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
           "share": "3"
         },
         {
           "id": "940",
           "firstname": "Michael W.",
           "surname": "Young",
           "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
           "share": "3"
         }
       ]
     }
   ]
 }
 
 
 

 JSON PATH – Lists:
 $[-1:0] --> start from the last all the way to the first top
 
 ....................
 

 JSON PATH Use case – Kubernetes:
 When query the kubernetes api via the kubectl utility, it returns an output in json but to make it human readyable, it does not give us the entire output in json.
 kubectl get nodes -o wide --> This give info about the node.
 Say we want to get a specific output about the node architecture, cpu count, taints etc. we will use the jsonpath query to get this done.
 
 e.g.  NAME         CPU.      NAME            TAINTS
       master       4         master          node-role.kubernetes.io/master
       node01.      4         node01
	   
	   NAME       ARCHITECTURE
	   master     amd64
	   node01.    amd64
	   
	   
	   NAME          IMAGE
	   red           nginx
	   blue.         ubuntu
	   yellow        redis
 
 
	   STEPS TO USE JSON PATH IN K8S
	   
1. Command that will give you the required info in raw format
k get nodes
k get pods

2. Familiarize with json output.
k get nodes -o json
k get pods -o json

3. Form the json path query that will retreive the reqiured info for you.

example:

.items[0].spec.containers[0].image --> to retreive image
$ not mandatory as kubectl adds it..

4. Use the json path query with kubectl command:
the query u developed

kubectl get pods -o=jsonpath= .items[0].spec.containers[0].image

you must encapsulated it with a single quote with curly bracket:

kubectl get pods -o=jsonpath='{ .items[0].spec.containers[0].image }'

Predefining and formating optios:
{"\n"} ---> new line incase you want to combine 2 jsonpath query, it should be inbetween the 2 querys.

{"\t"} --> tab


LOOPS USING RANGES:
With ranges, we organize the jsonpath query and to iterate each items in the list and print its property.

e.g

FOR EACH NODE 
PRINT NODE NAME \t PRINT CPU COUNT \n
END FOR

'{ranges .items[*]}
{.metadata.name} {"\t"} {.status.capacity.cpu} {"\n"}
{end}'

merge the above as a single entry and pass it on as an option the kubectl utility when querying the object in json..

kubectl get nodes -o=jsonpath='{ranges .items[*]} {.metadata.name} {"\t"} {.status.capacity.cpu} {"\n"} {end}'




JSONPATH WITH CUSTOM colums:
---------------------------

kubectl get nodes -o=custom-cloumns=<columname>:jasnpath
It assumes for each item in the list.. You must remove the .items

example:
{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "nginx-pod",
    "namespace": "default"
  },
  "spec": {
    "containers": [
      {
        "image": "nginx:alpine",
        "name": "nginx"
      }
    ],
    "nodeName": "node01"
  }
}

Develop a JSON PATH query to get the image name under the containers section.
$.spec.containers[0].image

......................
{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "nginx-pod",
    "namespace": "default"
  },
  "spec": {
    "containers": [
      {
        "image": "nginx:alpine",
        "name": "nginx"
      },
      {
        "image": "redis:alpine",
        "name": "redis-container"
      }
    ],
    "nodeName": "node01"
  },
  "status": {
    "conditions": [
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "Initialized"
      },
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "PodScheduled"
      }
    ],
    "containerStatuses": [
      {
        "image": "nginx:alpine",
        "name": "nginx",
        "ready": false,
        "restartCount": 4,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      },
      {
        "image": "redis:alpine",
        "name": "redis-container",
        "ready": false,
        "restartCount": 2,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      }
    ],
    "hostIP": "172.17.0.75",
    "phase": "Pending",
    "qosClass": "BestEffort",
    "startTime": "2019-06-13T05:34:09Z"
  }
}

We now have POD status too. Develop a JSON PATH query to get the phase of the pod under the status section.

Scroll down if you can't see the status section
$.status.phase
.................


Develop a JSON PATH query to get the reason for the state of the container under the status section.

Scroll down if you can't see the status section

{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "nginx-pod",
    "namespace": "default"
  },
  "spec": {
    "containers": [
      {
        "image": "nginx:alpine",
        "name": "nginx"
      },
      {
        "image": "redis:alpine",
        "name": "redis-container"
      }
    ],
    "nodeName": "node01"
  },
  "status": {
    "conditions": [
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "Initialized"
      },
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "PodScheduled"
      }
    ],
    "containerStatuses": [
      {
        "image": "nginx:alpine",
        "name": "nginx",
        "ready": false,
        "restartCount": 4,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      },
      {
        "image": "redis:alpine",
        "name": "redis-container",
        "ready": false,
        "restartCount": 2,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      }
    ],
    "hostIP": "172.17.0.75",
    "phase": "Pending",
    "qosClass": "BestEffort",
    "startTime": "2019-06-13T05:34:09Z"
  }
}

$.status.containerStatuses[0].state.waiting.reason

................

Develop a JSON PATH query to get the restart count of redis-container under the status section.

Scroll down if you can't see the status section

{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "nginx-pod",
    "namespace": "default"
  },
  "spec": {
    "containers": [
      {
        "image": "nginx:alpine",
        "name": "nginx"
      },
      {
        "image": "redis:alpine",
        "name": "redis-container"
      }
    ],
    "nodeName": "node01"
  },
  "status": {
    "conditions": [
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "Initialized"
      },
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "PodScheduled"
      }
    ],
    "containerStatuses": [
      {
        "image": "nginx:alpine",
        "name": "nginx",
        "ready": false,
        "restartCount": 4,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      },
      {
        "image": "redis:alpine",
        "name": "redis-container",
        "ready": false,
        "restartCount": 2,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      }
    ],
    "hostIP": "172.17.0.75",
    "phase": "Pending",
    "qosClass": "BestEffort",
    "startTime": "2019-06-13T05:34:09Z"
  }
}

$.status.containerStatuses[1].restartCount

/......

 14 / 14 JSON PATH in Kubernetes

The order of container could be different. The redis-container need not be the second container all the time. So, re-develop a JSON PATH query to get the restart count of redis-container, but this time use a criteria/condition to get the restart count of the container with the container name redis-container .

Scroll down if you can't see the status section

IQ


{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "nginx-pod",
    "namespace": "default"
  },
  "spec": {
    "containers": [
      {
        "image": "nginx:alpine",
        "name": "nginx"
      },
      {
        "image": "redis:alpine",
        "name": "redis-container"
      }
    ],
    "nodeName": "node01"
  },
  "status": {
    "conditions": [
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "Initialized"
      },
      {
        "lastProbeTime": null,
        "lastTransitionTime": "2019-06-13T05:34:09Z",
        "status": "True",
        "type": "PodScheduled"
      }
    ],
    "containerStatuses": [
      {
        "image": "nginx:alpine",
        "name": "nginx",
        "ready": false,
        "restartCount": 4,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      },
      {
        "image": "redis:alpine",
        "name": "redis-container",
        "ready": false,
        "restartCount": 2,
        "state": {
          "waiting": {
            "reason": "ContainerCreating"
          }
        }
      }
    ],
    "hostIP": "172.17.0.75",
    "phase": "Pending",
    "qosClass": "BestEffort",
    "startTime": "2019-06-13T05:34:09Z"
  }
}

$.status.containerStatuses[?(@.name == "redis-container")].restartCount

..............


{
  "kind": "Config",
  "apiVersion": "v1",
  "preferences": {},
  "clusters": [
    {
      "name": "development",
      "cluster": {
        "server": "KUBE_ADDRESS",
        "certificate-authority": "/etc/kubernetes/pki/ca.crt"
      }
    },
    {
      "name": "kubernetes-on-aws",
      "cluster": {
        "server": "KUBE_ADDRESS",
        "certificate-authority": "/etc/kubernetes/pki/ca.crt"
      }
    },
    {
      "name": "production",
      "cluster": {
        "server": "KUBE_ADDRESS",
        "certificate-authority": "/etc/kubernetes/pki/ca.crt"
      }
    },
    {
      "name": "test-cluster-1",
      "cluster": {
        "server": "KUBE_ADDRESS",
        "certificate-authority": "/etc/kubernetes/pki/ca.crt"
      }
    }
  ],
  "users": [
    {
      "name": "aws-user",
      "user": {
        "client-certificate": "/etc/kubernetes/pki/users/aws-user/aws-user.crt",
        "client-key": "/etc/kubernetes/pki/users/aws-user/aws-user.key"
      }
    },
    {
      "name": "dev-user",
      "user": {
        "client-certificate": "/etc/kubernetes/pki/users/dev-user/developer-user.crt",
        "client-key": "/etc/kubernetes/pki/users/dev-user/dev-user.key"
      }
    },
    {
      "name": "test-user",
      "user": {
        "client-certificate": "/etc/kubernetes/pki/users/test-user/test-user.crt",
        "client-key": "/etc/kubernetes/pki/users/test-user/test-user.key"
      }
    }
  ],
  "contexts": [
    {
      "name": "aws-user@kubernetes-on-aws",
      "context": {
        "cluster": "kubernetes-on-aws",
        "user": "aws-user"
      }
    },
    {
      "name": "research",
      "context": {
        "cluster": "test-cluster-1",
        "user": "dev-user"
      }
    },
    {
      "name": "test-user@development",
      "context": {
        "cluster": "development",
        "user": "test-user"
      }
    },
    {
      "name": "test-user@production",
      "context": {
        "cluster": "production",
        "user": "test-user"
      }
    }
  ],
  "current-context": "test-user@development"
}


Develop a JSON PATH query to get all user names.



$.users[*].name

FINALLY;;;
1. Get the needed object you want in a json data.
2. use jsonpath.com an online evaluate to query and evaluate your expected output.
3. Pass the output from the query to the kubectl utility to get the result from k8s objects as expected.


k get pv --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt


REVISION:
SCHEDULING

Important:
When you create a pod and add a command --command -- sleep 1000, if you have to use a dry run option, do it b4 the --command option b/c any thing after the command will be 
regarded as an argument for the sleep command e.g
k run staticpod --image=busybox --dry-run=client -o yaml --command -- sleep 1000 > staticpod.yaml

https://kubernetes.io/blog/2017/03/advanced-scheduling-in-kubernetes/


Important:

Create a pod with the given specifications. By default it displays a blue background. Set the given command line arguments to change it to green.

    Pod Name: webapp-green

    Image: kodekloud/webapp-color

    Command line arguments: --color=green


	This means to to set the args --color and green on the pods... command line argument.
	
	
Important: When you create role,clusterrole and its bindings on the cli, imperatively it will automatically includes the apigroups those resources belongs to and so you do not need to specify it.

Better to set all securitycontext at the container level except otherwise stated...


NETPOL:

spec:
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: internal
    ports:
    - port: 8080
      protocol: TCP
  podSelector:
    matchLabels:
      name: payroll
  policyTypes:
  - Ingress
status: {}

Important: egress definition has to be to and ingress has to be from


Important:
Type create a persistent volume

NB:


The Storage Class called local-storage makes use of VolumeBindingMode set to WaitForFirstConsumer. 
This will delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created.


Question:
We use container containerd as our container runtime. what is the interface/bridge created by container on this host..

ip addr show type bridge

This will show you all the bridge interface..

.. Always use --help for a command not familiar with..


To determine container runtime endpoint, you have to check the --container-runtime-endpoint option on the kubelet.
This will also tell you the container runtime been used by the cluster..

IQ:
Identify which of the below plugins is not available in the list of available CNI plugins on this host?

ls /opt/cni

IQ
What is the CNI plugin configured to be used on this kubernetes cluster?
ls /etc/cni/net.d/


IQ:
If the requirement does not match any of the configured paths what service are the requests forwarded to?
Default backend:  <default>
NEEDS TO BE CONFIGURED...

Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
              nginx.ingress.kubernetes.io/ssl-redirect: false
			  
			  
		EXAM:	  
			  
KUBELET ISSUE:
journalctl -u kubelet --no-pager 
journalctl -u kubelet 
journalctl -u kubelet --no-pager  | grep -i error

.....

 k logs  -n kube-system kube-proxy-bjgxt 
E1021 02:13:25.687717       1 run.go:74] "command failed" err="failed complete: failed to decode: no kind \"Config\" is registered for version \"v1\" in scheme \"pkg/proxy/apis/config/scheme/scheme.go:29\""

THIS ISSUE WAS FROM THE KUBE PROXY KUBECONFIG FILE, THE FILE WAS PASSED AS KUBECONFIG IN THE KUBEPROXY CM BUT WAS PASSED AS CONFIG AS OPTION IN THE CONTAINER.
ALSO THE RIGHT URL WASNT CORRECT OR CONSISTENT BW THE ONE IN THE CONTAINER AND THE ONE MOUNTED AS CM..


kubectl get deploy -n admin | jq -c paths
https://www.youtube.com/watch?v=EDuYmvzgPFc

k get no -o wide --kubeconfig=admin000.conf
k cluster-info --kubeconfig /cka/admin99777.conf

LINUX:

1. 1,$d --> delete everything in a vi. -- no insert
2. dd --> delete a specific line in a vi, move the cursor to the said line... no insert

test coonectivity:

k run curl --image=alpine/curl --rm -it -- sh



SOLUTIONS:

kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: orange-stc-cka07-str
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: orange-pv-cka07-str
spec:
  capacity:
    storage: 150Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: orange-stc-cka07-str
  local:
    path: /opt/orange-data-cka07-str
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - cluster1-controlplane

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: orange-pvc-cka07-str
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: orange-stc-cka07-str
  volumeName: orange-pv-cka07-str
  resources:
    requests:
      storage: 128Mi

	  .....
	  
	  kubectl rollout history deployment -n test-wl08 trace-wl08 --revision=2
	  
	  kubectl rollout history deployment -n test-wl08 trace-wl08 
	  kubectl get deploy -n test-wl08
	  .................
	  
	  kubectl get event --field-selector involvedObject.name=blue-dp-cka09-trb-xxxxx
	  
	  initContainers:
	    - command:
	      - sh
	      - -c
	      - echo 'Welcome!'
		  
		  when the logs,describe does no t show use events
		  
		  
		  OBSERVATIONS:
		  
		  When you modify a secret/configmap for a pod.
		  You should delete the pod and recreate it for the update to take effect except theyre mounted as a volume..
		  
		  
		  journalctl -u kubelet -f | grep -v 'connect: connection refused'
		  
		  When requred to add a volumename to a pvc do it..
		  
		  issue:
		  When you issue that the kubelet is not mounting to a volume that was specified in form of a file...
		  You should add a subpath with that path that it tells u is not a directory..
		  
		  When youve checked the labels of the pods matches that of the svc and still no endpoint and you where told not to modify the svc.. You can delete the pod and recreate it..
		  Even when you do this and it does not work replace the label, even if it is the same their might be typo.. replace the pod with the same label and it will work...
		  
		  ...
		  Connection the etcd can be refused if the wrong port is used in the livness.
		  if the volumemounts name and the volume names does not match
		  
		  
		  ,............
		  
,. Normal  ScalingReplicaSet  67s   deployment-controller  Scaled up replica set black-cka25-trb-74b777bb68 to 1

student-node ~ ➜  k logs black-cka25-trb-74b777bb68-nqndq 

student-node ~ ➜  kubectl rollout status deployment/black-cka25-trb
Waiting for deployment "black-cka25-trb" rollout to finish: 0 out of 1 new replicas have been updated...
^C
student-node ~ ✖ kubectl rollout history deployment/black-cka25-trb
deployment.apps/black-cka25-trb 
REVISION  CHANGE-CAUSE
1         <none>


student-node ~ ➜  kubectl rollout history  deployment/black-cka25-trb --revision=1
deployment.apps/black-cka25-trb with revision #1
Pod Template:
  Labels:       app=black-cka25-trb
        pod-template-hash=74b777bb68
  Containers:
   nginx-container-cka25-trb:
    Image:      nginx:1.14.2
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
  ..........................

student-node ~ ➜  kubectl rollout undo  deployment/black-cka25-trb --revision=1
Error: unknown flag: --revision
See 'kubectl rollout undo --help' for usage.

student-node ~ ✖ kubectl rollout undo  deployment/black-cka25-trb 
error: no rollout history found for deployment "black-cka25-trb"

student-node ~ ✖ kubectl rollout undo  deployment/black-cka25-trb 
error: no rollout history found for deployment "black-cka25-trb"

student-node ~ ✖ kubectl rollout undo deployment/black-cka25-trb --to-revision=1
error: you cannot rollback a paused deployment; resume it first with 'kubectl rollout resume deployment/black-cka25-trb' and try again

student-node ~ ✖ kubectl rollout resume deployment/black-cka25-trb 
deployment.apps/black-cka25-trb resumed

student-node ~ ➜  k get deploy
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
black-cka25-trb   1/1     1            1           7m54s
......................


For this question, please set the context to cluster1 by running:

kubectl config use-context cluster1


It appears that the black-cka25-trb deployment in cluster1 isn't up to date. While listing the deployments, we are currently seeing 0 under the UP-TO-DATE section for this deployment. Troubleshoot, fix and make sure that this deployment is up to date.

    Issue fixed?

    Pods of the deployment is up-to-date?
	
	ISSUE:
k auth can-i get namespaces --as system:serviceaccount:default:green-sa-cka22-arch

Important:
We do not need to give a logical address to the switch b/c it belongs to the datalink layer..
COMMAND FOR CONFIGURING THE ROUTER.. TO COMM BW 2 NETWORKS..

Would you like to initiate configuration dialogue?
say no, and click enter.
This will log you in to a router dialog box.

1. type enable and click enter
2. type configure and click enter
3.  a box will pop up with a question just click enter.....
4. interface gigabitEthernet 0/0 --> This means you want to configure this interface

g)#interface gigabitEthernet 0/0
Router(config-if)#ip a
Router(config-if)#ip add
Router(config-if)#ip address 192.168.1.1
% Incomplete command.
Router(config-if)#ip address 192.168.1.1 255.255.255.0

NOW We have to configure the router by assigning the first useable ip from the first network to it interface. say we have eth0 or interface G0/0 which should be a gateway for network of 
192.168.1.0, we will assign the first useable ip from this network to the interface... and do the same for the second network..

Example as above..
Bring up the interface by running.

no shutdown.
ig-if)#no shutdown

Router(config-if)#
%LINK-5-CHANGED: Interface GigabitEthernet0/0, changed state to up

%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0, changed state to up

Done??
exit and configure the second interface..

Finally, add a gateway to the devices in the network 192.168.1.0 to use the ip address assigned to your gateway interface at g0/0.
Also do the same for the second one..

......
CHAT
If you're looking to configure a router to connect two networks and provide them with gateway access. 
Here are the steps you've outlined and a few additional details to help guide you through the configuration:

Assuming you are in the router's configuration mode:

1. **Enable the Configuration Mode:**

    ```plaintext
    router> enable
    ```

2. **Enter Configuration Mode:**

    ```plaintext
    router# configure terminal
    ```

3. **Configure the First Interface (GigabitEthernet0/0) for the First Network (e.g., 192.168.1.0/24):**

    ```plaintext
    router(config)# interface GigabitEthernet0/0
    router(config-if)# ip address 192.168.1.1 255.255.255.0
    router(config-if)# no shutdown
    ```

    The `ip address` command assigns the router an IP address within the first network (e.g., 192.168.1.1) with a subnet mask of 255.255.255.0.

4. **Configure the Second Interface (GigabitEthernet0/1) for the Second Network:**

    If you have a second network, repeat the steps for the second interface. For example:

    ```plaintext
    router(config)# interface GigabitEthernet0/1
    router(config-if)# ip address 192.168.2.1 255.255.255.0
    router(config-if)# no shutdown
    ```

    This sets up the second interface (e.g., GigabitEthernet0/1) with an IP address in the second network (e.g., 192.168.2.1).

5. **Exit Configuration Mode:**

    ```plaintext
    router(config-if)# exit
    router(config)# exit
    ```

6. **Configure Gateway for Devices:**

    For devices in the network 192.168.1.0/24 to use the router as a gateway, you need to configure their default gateway to be the IP address assigned to GigabitEthernet0/0 (e.g., 192.168.1.1).

    Similarly, for devices in the second network, set their default gateway to be the IP address assigned to GigabitEthernet0/1 (e.g., 192.168.2.1).

That's it! You've now configured your router to connect two networks and provided them with gateway access. Devices in these networks can communicate with each other via the router. 
Just make sure to configure the gateway on devices accordingly.

...........

To query the Kubernetes api from the pod, using a service account.
1. Create a service account
2. Create a pod and associate that service account to the pods.
3 Describe the pod, you'll see where the service account is mounted as a volume.
e.g /var/run/secrets/kubernetes.io/serviceaccount 

4 exec into the pods using kubectl exec <podname> -- sh
Querying the Kubernetes api from the pod..

ls /var/run/secrets/kubernetes.io/serviceaccount, you will see ca.crt, namespace and token created by the token request api when the pod was created.
Remember you assigned your serviceaccount to this pod...
Depending on the k8s api or service you want to query, you have to grant the service account the right permission. using RBAC.
say you want to run a query to get secrets, then you should create a role/clusterrole and its bindings that will enable that service account perform such task.
Now lets run the commands to query the Kubernetes api.
Know that for you to access any resources in the cluster, say pods to pod communication and others, you do this via their services..

We set some variables for insecure communication.

TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) 
to curl you need the k8s service, which is kubernetes, note the cat was used in the command to provide the token to the variable TOKEN

curl -k https://kubernetes.default.svc.cluster.local/api --header "Authorization: Bearer ${TOKEN}"
curl -k https://kubernetes.default./api -H "Authorization: Bearer ${TOKEN}"

To list or get secrets if you have the permission...

curl -k https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"
...................................

To interact or with the Kubernetes api listing secrets using https or secure connection.
1. set the ca.crt as variable in the pod.

CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

curl --cacert $CACERT  https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"

-------------------------------


FROMGPT:
You've outlined a step-by-step process for querying the Kubernetes API from within a pod using a service account. 
This is a common and secure practice to access cluster resources and perform various operations. Here's a summary of the steps and the commands involved:

**Step 1: Create a Service Account**
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
```

**Step 2: Create a Pod with the Service Account**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-service-account
  containers:
  - name: my-container
    image: nginx:latest
```

**Step 3: Describe the Pod**
```bash
kubectl describe pod my-pod
```
You'll see where the service account is mounted as a volume at `/var/run/secrets/kubernetes.io/serviceaccount`.

**Step 4: Execute a Shell Inside the Pod**
```bash
kubectl exec my-pod -- sh
```

**Querying the Kubernetes API from the Pod:**

To access the Kubernetes API from within the pod using the service account, you can set environment variables and use `curl`:

- Get the Token:
```bash
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
```

- To access the API server:
```bash
curl -k https://kubernetes.default.svc.cluster.local/api --header "Authorization: Bearer ${TOKEN}"
```
or
```bash
curl -k https://kubernetes.default/api --header "Authorization: Bearer ${TOKEN}"
```

- To list or get secrets with proper permissions:
```bash
curl -k https://kubernetes.default/api/v1/secrets --header "Authorization: Bearer ${TOKEN}"
```

**To Interact with the Kubernetes API Over a Secure Connection:**

- Set the ca.crt as a variable in the pod:
```bash
CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

- Use `curl` with the `--cacert` option for secure communication:
```bash
curl --cacert $CACERT https://kubernetes.default/api/v1/secrets --header "Authorization: Bearer ${TOKEN}"
```

This approach allows you to securely interact with the Kubernetes API and perform various tasks, 
including listing secrets and accessing other resources, while ensuring proper authentication and authorization using the service account.

COMMNADS:

kubectl top pods -A --context cluster2 --no-headers | sort -nr -k4 | head -1

k get all  --no-headers -l env=prod --no-headers | wc -l

