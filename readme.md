Issues:

- Authenticating with token for terragrunt setup
- Creatting bucket:

01:58:06.156 ERROR  terraform invocation failed in ./.terragrunt-cache/kr93K7_rrE8n27VJuyxjnBVoi9g/iikTA8C0_1gOjSXoi2fAi5twB_w/modules/env-module
01:58:06.156 ERROR  error occurred:

* Failed to execute "terraform apply" in ./.terragrunt-cache/kr93K7_rrE8n27VJuyxjnBVoi9g/iikTA8C0_1gOjSXoi2fAi5twB_w/modules/env-module
  ╷
  │ Error: failed to create bucket
  │ 
  │   with module.storage.ionoscloud_s3_bucket.example,
  │   on ../../resources/object-storage/main.tf line 1, in resource "ionoscloud_s3_bucket" "example":
  │    1: resource "ionoscloud_s3_bucket" "example" {
  │ 
  │ failed to wait for bucket creation: failed to check if bucket exists: 403
  │ Forbidden: 
  ╵
  
  exit status 1


- Create K8s cluster:

  * Failed to execute "terraform apply" in ./.terragrunt-cache/kr93K7_rrE8n27VJuyxjnBVoi9g/iikTA8C0_1gOjSXoi2fAi5twB_w/modules/env-module
  ╷
  │ Error: error creating data center () (401 Unauthorized {"httpStatus":401,"messages":[{"errorCode":"315","message":"Unauthorized"}]})
  │ 
  │   with module.env-setup.ionoscloud_datacenter.testdatacenter,
  │   on ../../resources/kubernetes-cluster/main.tf line 1, in resource "ionoscloud_datacenter" "testdatacenter":
  │    1: resource "ionoscloud_datacenter" "testdatacenter" {
  │ 
  ╵
  ╷
  │ Error: an error occurred while reserving an ip block: 401 Unauthorized {"httpStatus":401,"messages":[{"errorCode":"315","message":"Unauthorized"}]}
  │ 
  │   with module.env-setup.ionoscloud_ipblock.k8sip,
  │   on ../../resources/kubernetes-cluster/main.tf line 7, in resource "ionoscloud_ipblock" "k8sip":
  │    7: resource "ionoscloud_ipblock" "k8sip" {

  │ 

  * Failed to execute "terraform apply" in ./.terragrunt-cache/kr93K7_rrE8n27VJuyxjnBVoi9g/iikTA8C0_1gOjSXoi2fAi5twB_w/modules/env-module
  ╷
  │ Error: installation failed
  │ 
  │   with module.grafana.helm_release.kube_prometheus_stack,
  │   on ../../resources/grafana/main.tf line 32, in resource "helm_release" "kube_prometheus_stack":
  │   32: resource "helm_release" "kube_prometheus_stack" {
  │ 
  │ cannot re-use a name that is still in use
  ╵
  
  exit status 1