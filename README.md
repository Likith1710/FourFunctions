# Kubernetes and Terraform Setup 

This repository consists of instructions and configuration files for deploying an Nginx server using Kubernetes and Provisioning AWS Infrastructure using Terraform.

## Kubernetes Deployment.

To deploy the Nginx server using Kubernetes, we need to apply the Deployment, Service, and Ingress configuration files. 

By using the below commands , can create the necessary resources in the Kubernets cluster.

**1. Apply the Deployment**

```sh
kubectl apply -f nginx-deployment.yaml
```

This command creates a Deployment that manages a set of Nginx pods. The deployment ensures that there are always 2 replica's running.

**2. Apply the Service**

```sh
kubectl apply -f nginx-service.yaml
```

This command creates a Service that exposes the Nginx pods internally within Kubernetes cluster. The service makes the Nginx Pods accessible on port 80.

**3. Apply the Ingress**

```sh
kubectl apply -f nginx-ingress.yaml
```

This command creates an Ingress resource that maps HTTP requests to the Nginx service. Ensure that the Kubernetes cluster has an Ingress controller running and that the host `hostname.com` is resolvable to the Ingress controller's IP adderss.

## Terraform Configuration for AWS Infrastructure.

This section contains Terraform configurations to provision AWS infrastructure , including a VPC, EC2 instances managed by Autoscaling , and a Route53 A record.

#### Configuration Overview.

##### Modules Used

- VPC Module (`./aws_infra/modules/vpc`) : 
  - creates a VPC with public and private subnets , Internet gateway, NAT Gateway, and necessary route tables.
- Nginx Module (`./aws_infra/modules/nginx`):
  - Configures an EC2 Auto Scaling group with Nginx installed on Ubuntu, running in Private subnets only.

#### AWS Resources Created

- **VPC SETUP**
  - VPC with CIDR block `10.0.0.0/16`
  - 3 Public and 3 Private Subnets across availability zones.
  - Internet gateway attached to the VPC for public subnet access.
  - NAT gateway for private subnet internet access.
- **EC2 Auto Scaling Group**
  - Instances type : `t2.micro`
  - Minimum Instances:2, Maximum Instances : 4
  - Nginx Installed via user data scripts in private subnets.
  - Pubic IPV4 addresses are disabled for instances.
- **Route53 A record**

  - Points to the NAT gateway's ElasticIp  for serving a Default Nginx webpage.

#### Usage of Commands

**1. Initialise Terraform**

```sh
terraform init
```

**2. Plan Terraform Changes**

```sh
terraform plan -out tfplan
```

**3. Apply Terraform Changes**

```sh
terraform apply tfplan
```

**4. Clean UP**

```sh
terraform destroy
```