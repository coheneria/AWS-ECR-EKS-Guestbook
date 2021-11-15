# AWS ECR-EKS deployment
This project come to demonstarte how to deploy Docker images to ECR, deploy the image on K8S using Jenkins. I used guestbook-go [link](https://github.com/coheneria/guestbook-go-for-deploy). 
this is a web app with database and it contains 2 microservices.

### For security purpose, I hida accountid information, so you need to put your accountid.

## Pre Requirements
you need to deploy the infrastructure with Terraform:

1. Terraform deploy:
```
cd terraform
```
```
terraform init
```
```
terraform plan
```
```
terraform apply -auto-approve
```

2. Install Jenkins and necessary plugins:
[Install Jenkins on Linux](https://www.jenkins.io/doc/book/installing/linux/).
You need to have installed on your Jenkins's machine:
- Docker
- AWS CLI 2 (Enter your credientials)
- policy for IAM - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess

on Jenkins console, you need to have this plugins installed:
- CloudBees AWS credentials
- Kubernetes Continuous Deploy (ver. 1.0.0)
- Docker
- Docker Pipeline

3. create 2 pipelines for the ECR's deploy on your jenkins machine.

4. Deploy K8S:
You need to have credentials for communicate with AWS and K8S:

Go to Jenkins - Manage Jenkins - Global credentials section and add AWS credentials with the ID "ecr"
for K8S:
```
cat /home/ubuntu/.kube/config
```
Copy result of this command and put it on Kubernetes credentials.

5. create pipeline for EKS's deploy on your jenkins machine.

6. For access the website, check the service:
```
kubectl get svc
```

7. Delete k8s deployment:
```
kubectl delete -f .
```
8. Destroy the infrastructure:

```
cd terraform
```
```
terraform destroy -auto-approve
```

## Result
<p align="center">
  <img src="https://github.com/coheneria/AWS-ECR-EKS-Guestbook/blob/main/files/photos/result.PNG" width="100%" height="100%" />
</p>

<p align="center">
  <img src="https://github.com/coheneria/AWS-ECR-EKS-Guestbook/blob/main/files/photos/ecr.PNG" width="100%" height="100%" />
</p>