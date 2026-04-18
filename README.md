# d-o-it Helm Charts

[![Helm Chart Release](https://github.com/d-o-it/helm-charts/actions/workflows/helm-release.yml/badge.svg)](https://github.com/d-o-it/helm-charts/actions/workflows/helm-release.yml)

A collection of Helm charts for Kubernetes, hosted via GitHub Pages.

## Usage

Add the Helm repository:

```bash
helm repo add d-o-it https://d-o-it.github.io/helm-charts
helm repo update
```

Search available charts:

```bash
helm search repo d-o-it
```

## Charts

| Chart | Description | Version |
|-------|-------------|----------|
| [sankeymatic](charts/sankeymatic) | A Helm chart for Kubernetes deployment of SankeyMATIC | 0.1.0 |
| [aliasvault](charts/aliasvault) | A Helm chart for deploying AliasVault - privacy-first password manager with built-in email aliasing | 0.1.0 |

## sankeymatic

[SankeyMATIC](https://sankeymatic.com/) is a tool for building Sankey diagrams in the browser.

### Install

```bash
helm   install   sankeymatic d-o-it/sankeymatic
```

### Upgrade

```bash
helm upgrade sankeymatic d-o-it/sankeymatic
```

### Uninstall

```bash
helm uninstall sankeymatic
```

### Configuration

See [charts/sankeymatic/values.yaml](charts/sankeymatic/values.yaml) for all available configuration options.

Key values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `bvmensvoort/sankeymatic` |
| `image.tag` | Container image tag (defaults to chart appVersion) | `""` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `ingress.enabled` | Enable ingress | `false` |

## aliasvault

[AliasVault](https://aliasvault.net/) is a privacy-first, end-to-end encrypted password and email alias manager with a built-in email server and zero third-party dependencies.

### Install

```bash
helm install aliasvault d-o-it/aliasvault
```

### Upgrade

```bash
helm upgrade aliasvault d-o-it/aliasvault
```

### Uninstall

```bash
helm uninstall aliasvault
```

### Configuration

See [charts/aliasvault/values.yaml](charts/aliasvault/values.yaml) for all available configuration options.

Key values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas (max 1 due to SQLite) | `1` |
| `image.repository` | Container image repository | `ghcr.io/aliasvault/aliasvault` |
| `image.tag` | Container image tag (defaults to chart appVersion) | `""` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `config.hostname` | Hostname used by AliasVault (must match external domain) | `localhost` |
| `config.publicRegistrationEnabled` | Allow public user registration | `"true"` |
| `config.forceHttpsRedirect` | Force HTTPS redirect (disable when behind reverse proxy) | `"false"` |
| `config.privateEmailDomains` | Comma-separated list of private email domains | `""` |
| `config.smtpTlsEnabled` | Enable TLS for SMTP | `"false"` |
| `config.smtpAdvertisedHostname` | SMTP advertised hostname (leave empty to use config.hostname) | `""` |
| `secret.create` | Create a new secret with required keys | `true` |
| `secret.dataProtectionCertPassword` | DATA_PROTECTION_CERT_PASSWORD value | `change-me-to-a-secure-random-value` |
| `persistence.enabled` | Enable persistent storage (recommended for production) | `true` |
| `persistence.database.size` | SQLite database storage size | `2Gi` |
| `persistence.logs.size` | Log storage size | `1Gi` |
| `persistence.secrets.size` | Secrets/certificates storage size | `1Gi` |
| `persistence.certificates.size` | Certificate storage size | `1Gi` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.httpPort` | HTTP port for the web UI | `80` |
| `service.smtp.enabled` | Enable SMTP service ports | `false` |
| `ingress.enabled` | Enable ingress | `false` |
| `httpRoute.enabled` | Enable Gateway API HTTPRoute | `false` |

## CI / Release Pipeline

When changes are pushed to `master` under `charts/`, the GitHub Actions workflow automatically:

1. Lints all charts with `helm lint`
2. Packages each chart into a `.tgz` archive
3. Uploads the archive as a GitHub Release asset
4. Regenerates `charts/index.yaml` with the correct download URLs
5. Commits the updated index back to `master`

The `.tgz` packages are **not** stored in the repository - they are built and published by CI.

## Pages

GitHub Pages is configured to serve from the `master` branch root. The site is available at https://d-o-it.github.io/helm-charts
The Helm repository index is available at:

```
https://d-o-it.github.io/helm-charts/charts/index.yaml
```
