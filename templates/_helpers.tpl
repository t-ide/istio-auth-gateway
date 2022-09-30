{{/*
Expand the name of the chart.
*/}}
{{- define "auth-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "auth-gateway.fullname" -}}
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
{{- define "auth-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "auth-gateway.labels" -}}
helm.sh/chart: {{ include "auth-gateway.chart" . }}
{{ include "auth-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "auth-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "auth-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "auth-gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "auth-gateway.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Service or Deployment name of a Gateway
*/}}
{{- define "auth-gateway.gatewayName" -}}
{{- .Release.Name -}}-{{- .Values.gateway.type -}}
{{- end -}}

{{/*
Domain of a Gateway
*/}}
{{- define "auth-gateway.gatewayDomain" -}}
{{- include "auth-gateway.gatewayName" . -}}.{{- .Values.keycloak.namespace -}}.svc.{{- .Values.global.clusterDomain -}}
{{- end -}}

{{/*
Port number of a Gateway
*/}}
{{- define "auth-gateway.gatewayPort" -}}
{{- if eq .Values.gateway.type "oauth2-proxy" -}}
{{- .Values.gateway.oauth2Proxy.service.port }}
{{- else -}}
{{- 0 }}
{{- end -}}
{{- end -}}


{{/*
Selector Labels of Keycloak realm CR
*/}}
{{- define "auth-gateway.relamLabels" -}}
{{- if .Values.keycloak.realm.sample.create }}
{{- include "auth-gateway.selectorLabels" . }}
{{- else }}
{{- default toYaml .Values.keycloak.client.sample.realmLabels }}
{{- end }}
{{- end }}

{{/*
Secret resource name of Keycloak client CR
*/}}
{{- define "auth-gateway.clientSecret" -}}
{{- if .Values.keycloak.client.sample.create }}
{{- "keycloak-client-secret-" }}{{- include "auth-gateway.fullname" . }}
{{- else }}
{{- .Values.keycloak.client.secret }}
{{- end }}
{{- end }}
