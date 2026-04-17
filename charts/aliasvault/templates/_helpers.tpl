{{/*
Expand the name of the chart.
*/}}
{{- define "aliasvault.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aliasvault.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aliasvault.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aliasvault.labels" -}}
helm.sh/chart: {{ include "aliasvault.chart" . }}
{{ include "aliasvault.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aliasvault.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aliasvault.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "aliasvault.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aliasvault.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use.
If secret.existingSecret is set, use that; otherwise use the chart-managed secret name.
*/}}
{{- define "aliasvault.secretName" -}}
{{- if .Values.secret.existingSecret }}
{{- .Values.secret.existingSecret }}
{{- else }}
{{- printf "%s-secret" (include "aliasvault.fullname" .) }}
{{- end }}
{{- end }}
