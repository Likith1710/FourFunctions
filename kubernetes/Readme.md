# Apply Kubernetes YAML Files

To deploy the Nginx server using Kubernetes, you need to apply the deployment, Service, and Ingress configuration files. Follow these commands to create the necessary resources in kubernetes cluster.

1. **Apply the Deployment**

```sh
kubectl apply -f nginx-deployment.yaml
```

This command creates a Deployment that manages a set of Nginx pods. The deployment ensures that there are always 2 replicas running.

2. **Apply the Service**

```sh
kubectl apply -f nginx-service.yaml
```

This command creates a Service that exposes the Nginx pods internally within the Kubernetes cluster. The service makes the Nginx Pods accessible on port 80.

3. **Apply the Ingress**

```sh
kubectl apply -f nginx-ingress.yaml
```

This command creates a Ingress resource that maps HTTP requests to the Nginx service. Ensure that kubernetes cluster has Ingress controller running and the host `hostname.com` is resolvable to the Ingress controller's IP address.