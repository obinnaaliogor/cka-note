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
						  
						  openssl X509  -in /etc/kubernetes/manifests/kube-apiserver.yaml -noout -text
						  
						  
						  
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
						 
						 She then sends me this CSR, as the only one with access to the cluster where the CA KEY AND CA cert are i use these to sign the users CSR and sends it back the certificate to her
						 for an access to the cluster. This certificate has a validity period, i keep rotating the certificate each time it expires by asking her to generate a new one and i sign it with the CA
						 
						 Each time a new user joins again, the process is repeated and when the number of users increases this becomes a tidious job..
						 
						 The Certificate API, allows us to automate the process of certificate approval and deny.
						 It allows us to secure of CA servers which is a safe storage of the CAkey and CA cert used in signing the csr.
						 There4 the CA server is nothing but a server where we safe store the CAkey and CA certificates.. Anyone with access to this server can create as many users as they want and with any permission they want.
						 This is why we need to secure the CA server..
						 
						 Automating CERTIFICATE SIGNING:
						 
						 Kubernetes has a certificate API, with certificate api you can send csr to the CA server and all administrator will see this as pending csr in the cluster.
						 
						 Process: 
						 The new user generates a set of keys, create a csr and send the csr to me the admin user.
						 The admin user creates a CertificateSingingRequest object. In this CSR object, the details of the new users csr is enterred into it.
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
 						   groups: <The group the user belongs to in linux eg system:masters or system:authenticated, theyre all list and should have ->
 						   usages:  ---> The use of the certificate, just for auth or gital signature or key encipherment. They all list and should have -, ?
 						   - client auth
						
				
						https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#certificate-signing-requests
						
						Some points to note:

						    usages has to be 'client auth'

						    expirationSeconds could be made longer (i.e. 864000 for ten days) or shorter (i.e. 3600 for one hour)

						    request is the base64 encoded value of the CSR file content. You can get the content using this command:
							
							cat jane.csr | base64 | tr -d "\n"
							
							
						
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
							
							We know that for anyone to sign certificate, the need the CA server root certificate and key.
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
							You have not been specifying the cacert,key,cert options when calling the kubernetes api b/c theyre already in the .kube folder and kubectl check that folder and uses the file in there.
							
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
							  We link the user/users to that role we have created.. To do this we create another object called RoleBinding...
							  
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
									 If in creating the csr you added the user to OU system:masters, and when granting authorization to the user using RBAC, you create a clusterrole say to create, delete, get pods and deployments
									 and binds its using clusterrolebinding and in the subject you specify kind as Group and name as system:masters b/c that user was added to the group system:masters when generating the 
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
											F  or example, to generate a token that expires in 1 hour (3600 seconds):
									
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
	   
	   
	   Exactly, that's the workflow. Once you've created the `TokenRequest` associated with a specific ServiceAccount, you can create a pod object, specify the ServiceAccount you want to use for that pod, and mount the token as a projected volume in the pod. Here's a step-by-step breakdown:

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
 
 

	   Image Security:
	   
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



Networking:


