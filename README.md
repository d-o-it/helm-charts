# d-o-it Helm Charts

[![Helm Chart Release](https://github.com/d-o-it/helm-charts/actions/workflows/helm-release.yml/badge.svg)](https://github.com/d-o-it/helm-charts/actions/workflows/helm-release.yml)

A collection of Helm charts for Kubernetes, hosted via GitHub Pages.

## Usage

Add the Helm repository:

```bash
helm repo add d-o-it https://d-o-it.github.io/helm-charts/charts
helm repo update
```

Search available charts:

```bash
helm search repo d-o-it
```

## Charts

| Chart | Description | Version |
|-------|-------------|---------|
| [sankeymatic](charts/sankeymatic) | A Helm chart for Kubernetes deployment of SankeyMATIC | 0.1.0 |

## sankeymatic

[SankeyMATIC](https://sankeymatic.com) is a tool for building Sankey diagrams in the browser.

### Install

```bash
helm install sankeymatic d-o-it/sankeymatic
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

## CI / Release Pipeline

When changes are pushed to `master` under `charts/`, the GitHub Actions workflow automatically:

1. Lints all charts with `helm lint`
2. Packages each chart into a `.tgz` archive
3. Uploads the archive as a GitHub Release asset
4. Regenerates `charts/index.yaml` with the correct download URLs
5. Commits the updated index back to `master`

The `.tgz` packages are **not** stored in the repository - they are built and published by CI.

## Pages

GitHub Pages is configured to serve from the `master` branch root.
The Helm repository index is available at:

```
https://d-o-it.github.io/helm-charts/charts/index.yaml
```
