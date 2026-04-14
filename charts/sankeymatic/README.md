# SankeyMATIC Helm Chart

Deploys **SankeyMATIC** as a single container in Kubernetes using this Helm chart.

## Quickstart

### Option 1: Port-forward (testing)

```bash
helm install sankeymatic ./charts/sankeymatic
kubectl port-forward deploy/sankeymatic 8080:80
# open http://127.0.0.1:8080
```

### Option 2: Ingress

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: sankeymatic.example.com
      paths:
        - path: /
          pathType: Prefix
```

### Option 3: Gateway API (HTTPRoute)

```yaml
httpRoute:
  enabled: true
  parentRefs:
    - name: gateway
      sectionName: http
  hostnames:
    - sankeymatic.example.com
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
```

**Note:** The chart includes optional HTTPRoute support and assumes suitable Gateway API resources and a compatible controller are installed in the cluster.[cite:page:1]

## Configuration

### Image

- **`image.repository`**: container image repository, default: `bvmensvoort/sankeymatic`.[page:1]
- **`image.tag`**: image tag, default: chart `appVersion`.[page:1]
- **`image.pullPolicy`**: default: `IfNotPresent`.[page:1]

### Replicas

- **`replicaCount`**: number of pod replicas, default: `1`.[page:1]

### Service

- **`service.type`**: Kubernetes Service type, default: `ClusterIP`.[page:1]
- **`service.port`**: Service port exposed inside the cluster, default: `80`.[page:1]

### Ingress

- **`ingress.enabled`**: enables Ingress, default: `false`.[page:1]
- **`ingress.className`**: ingress class name, default: empty.[page:1]
- **`ingress.hosts`**: default host list includes `chart-example.local`.[page:1]
- **`ingress.tls`**: optional TLS entries, default: empty.[page:1]

### Gateway API / HTTPRoute

- **`httpRoute.enabled`**: enables HTTPRoute, default: `false`.[page:1]
- **`httpRoute.parentRefs`**: gateway parent references, default includes `name: gateway` and `sectionName: http`.[page:1]
- **`httpRoute.hostnames`**: default host list includes `chart-example.local`.[page:1]
- **`httpRoute.rules`**: default rule matches path `/headers` with `PathPrefix`.[page:1]

### Service Account

- **`serviceAccount.create`**: whether to create a service account, default: `false`.[page:1]
- **`serviceAccount.automount`**: whether to automount API credentials, default: `false`.[page:1]
- **`serviceAccount.name`**: existing or generated service account name, default: empty.[page:1]

### Health Checks

- **`livenessProbe`**: HTTP probe on `/` via port `http`.[page:1]
- **`readinessProbe`**: HTTP probe on `/` via port `http`.[page:1]

### Autoscaling

- **`autoscaling.enabled`**: enables HPA, default: `false`.[page:1]
- **`autoscaling.minReplicas`**: default: `1`.[page:1]
- **`autoscaling.maxReplicas`**: default: `100`.[page:1]
- **`autoscaling.targetCPUUtilizationPercentage`**: default: `80`.[page:1]

### Scheduling and Runtime

- **`resources`**: pod resource requests and limits, default: empty.[page:1]
- **`nodeSelector`**: node selector map, default: empty.[page:1]
- **`tolerations`**: tolerations list, default: empty.[page:1]
- **`affinity`**: affinity rules, default: empty.[page:1]
- **`volumes`** and **`volumeMounts`**: extra volumes and mounts, default: empty.[page:1]

## Example values

### Minimal local install

```yaml
replicaCount: 1

image:
  repository: bvmensvoort/sankeymatic
  pullPolicy: IfNotPresent
  tag: ""

service:
  type: ClusterIP
  port: 80
```

### Ingress example

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: sankeymatic.example.com
      paths:
        - path: /
          pathType: Prefix
```

### HTTPRoute example

```yaml
httpRoute:
  enabled: true
  parentRefs:
    - name: gateway
      sectionName: http
  hostnames:
    - sankeymatic.example.com
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
```

## Install from this repository

After the GitHub Pages chart index is published correctly, you can install the chart with:

```bash
helm repo add d-o-it https://d-o-it.github.io/helm-charts/charts/
helm repo update
helm install sankeymatic d-o-it/sankeymatic
```

## Chart metadata

- **Chart name**: `sankeymatic`.[page:1]
- **Chart type**: `application`.[page:1]
- **Chart version**: `0.1.0`.[page:1]
- **App version**: `latest`.[page:1]
- **Description**: `A Helm chart for Kubernetes deployment of SankeyMATIC`.[page:1]