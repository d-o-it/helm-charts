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

### Uninstall

```bash
helm uninstall sankeymatic
```
