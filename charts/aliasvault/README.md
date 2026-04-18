# AliasVault Helm Chart

Deploys [AliasVault](https://github.com/aliasvault/aliasvault) as a single all-in-one container in Kubernetes.

AliasVault is a privacy-first, end-to-end encrypted password and email alias manager. It includes a built-in email server and zero third-party dependencies.

## Quickstart

### Option 1: Port-forward (testing)

```bash
helm install aliasvault ./charts/aliasvault \
  --set config.hostname=localhost \
  --set secret.dataProtectionCertPassword=my-secure-password

kubectl port-forward deploy/aliasvault 8080:80
# open http://127.0.0.1:8080
# Admin: http://127.0.0.1:8080/admin
```

### Option 2: Ingress (with cert-manager)

```yaml
config:
  hostname: aliasvault.example.com
  forceHttpsRedirect: "false"  # TLS handled by ingress

secret:
  dataProtectionCertPassword: "your-secure-random-password"

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: aliasvault.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: aliasvault-tls
      hosts:
        - aliasvault.example.com
```

### Option 3: Gateway API / HTTPRoute (Istio, Envoy Gateway etc.)

```yaml
config:
  hostname: aliasvault.example.com

httpRoute:
  enabled: true
  parentRefs:
    - name: my-gateway
      sectionName: https
  hostnames:
    - aliasvault.example.com
```

## Architecture

AliasVault runs as a **single all-in-one container** using [s6-overlay](https://github.com/just-containers/s6-overlay) to combine all services (API server, admin panel, SMTP server, reverse proxy, database) into one image.

> **Note:** Because the database is SQLite stored on a local PVC, `replicaCount > 1` is not supported.

## Persistence

The chart creates 4 separate PVCs by default:

| PVC | Mount | Default Size | Purpose |
|-----|-------|-------------|----------|
| `*-database` | `/database` | 2Gi | Postgres database |
| `*-logs` | `/logs` | 1Gi | Application logs |
| `*-secrets` | `/secrets` | 1Gi | Internal secrets |
| `*-certificates` | `/certificates` | 1Gi | TLS certificates |

Disable persistence (not recommended for production):
```yaml
persistence:
  enabled: false
```

## TLS / HTTPS

AliasVault's all-in-one Docker image does **not** provide automatic TLS termination. You must use an external reverse proxy:

- **Ingress**: Use an Ingress controller (nginx, traefik) with cert-manager
- **Gateway API**: Use an HTTPRoute with a TLS-enabled listener
- **Istio**: Use a VirtualService or HTTPRoute with a Gateway

Set `config.forceHttpsRedirect: "false"` (default) when TLS is handled externally.

## Email Aliasing (SMTP)

To enable AliasVault's built-in email aliasing feature:

```yaml
config:
  privateEmailDomains: "mail.example.com"

service:
  smtp:
    enabled: true   # exposes ports 25 and 587
```

> **Requirements:** A public IP with ports 25/587 reachable, proper MX and PTR DNS records.

## Secret Management

The `DATA_PROTECTION_CERT_PASSWORD` is required for AliasVault to encrypt its internal certificates.

**Using chart-managed secret (default):**
```yaml
secret:
  create: true
  dataProtectionCertPassword: "your-secure-random-password"
```

**Using an existing secret (recommended for production with external secret managers):**
```yaml
secret:
  create: false
  existingSecret: my-aliasvault-secret
  dataProtectionCertPasswordKey: DATA_PROTECTION_CERT_PASSWORD
```

## Values Reference

| Key | Default | Description |
|-----|---------|-------------|
| `image.repository` | `ghcr.io/aliasvault/aliasvault` | Container image |
| `image.tag` | `""` (uses appVersion) | Image tag |
| `config.hostname` | `localhost` | External hostname |
| `config.publicRegistrationEnabled` | `"true"` | Allow public registration |
| `config.forceHttpsRedirect` | `"false"` | Force HTTPS redirect |
| `config.privateEmailDomains` | `""` | Domains for email aliasing |
| `secret.create` | `true` | Create Kubernetes secret |
| `secret.dataProtectionCertPassword` | `change-me-...` | Cert encryption password |
| `secret.existingSecret` | `""` | Use existing secret |
| `persistence.enabled` | `true` | Enable PVCs |
| `persistence.database.size` | `2Gi` | Database PVC size |
| `service.httpPort` | `80` | HTTP service port |
| `service.smtp.enabled` | `false` | Enable SMTP ports |
| `ingress.enabled` | `false` | Enable Ingress |
| `httpRoute.enabled` | `false` | Enable HTTPRoute |

For a full list of values, see [values.yaml](values.yaml).
