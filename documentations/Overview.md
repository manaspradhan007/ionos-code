# App Deployments and Cloud Infra setup:

## Presentation link

> https://powerpoint.cloud.microsoft/open/onedrive/?docId=1A56E55106E077B1%21s172614f50d8a448fa82ae5cfd4869caa&driveId=1A56E55106E077B1



# Architecture Diagram: Scalable & Observable Application in Kubernetes

## Overview

This repository contains an architecture diagram illustrating the key interactions between an application (exemplified by WordPress), a GitOps continuous delivery system (ArgoCD), an ingress controller, and a robust monitoring stack (Prometheus & Grafana) within a Kubernetes cluster.

The diagram showcases the end-to-end flow from external user access to internal application components and their comprehensive observability.

## Purpose

This diagram serves to:
* Visually explain the interconnected components of a modern, cloud-native application deployment on Kubernetes.
* Highlight the roles of Ingress for traffic routing, ArgoCD for automated deployments, and Prometheus/Grafana for deep insights and monitoring.
* Provide a clear reference for team members, stakeholders, and for demo presentations.

## Key Components and Their Roles

The architecture comprises several core components, organized within a Kubernetes cluster:

1.  **Internet / External Client:** Represents end-users or other external systems initiating requests.
2.  **Ingress Controller:**
    * The entry point for all HTTP/HTTPS traffic into the Kubernetes cluster.
    * Routes incoming requests to the correct internal Kubernetes Services based on configured hostnames and paths (e.g., `wordpress.task.de`, `argocd.task.de`, `grafana.task.de`).
3.  **WordPress Application:**
    * The demo application deployed within its own Kubernetes namespace.
    * Consists of:
        * **Nginx:** The web server handling incoming HTTP requests.
        * **PHP-FPM:** The application server processing PHP code for WordPress.
4.  **ArgoCD:**
    * A GitOps continuous delivery tool.
    * Monitors a Git repository (not explicitly shown in the cluster, but the source of truth) for desired application state.
    * Synchronizes changes from Git and applies them to the Kubernetes API Server, automating deployments and ensuring cluster consistency.
5.  **Prometheus:**
    * A powerful open-source monitoring system and time-series database.
    * **Scrapes**  metrics from various "exporters" running across the cluster.
6.  **Grafana:**
    * An open-source platform for analytics and interactive visualization.
    * **Queries** Prometheus for metric data to create and display custom dashboards, providing real-time insights into application and infrastructure performance.
7.  **Prometheus Exporters:**
    * Lightweight agents that expose metrics from specific services in a Prometheus-compatible format.
    * **Nginx Exporter:** Collects metrics from the Nginx web server.
    * **PHP-FPM Exporter:** Collects metrics from the PHP-FPM processes.
8.  **Prometheus Operator:**
    * A Kubernetes Operator that simplifies the deployment and management of Prometheus and Alertmanager instances.
    * It introduces Custom Resource Definitions (CRDs) like `ServiceMonitor` and `PodMonitor` for configuring Prometheus scraping targets.
9.  **Kubernetes API Server:**
    * The central control plane component of Kubernetes.
    * All interactions for managing the cluster state (deploying apps, creating services, setting up monitoring targets) happen via the API Server.

## Key Interactions and Data Flows

* **User Access:** External clients access applications via Ingress, which routes traffic to the appropriate Kubernetes Service for WordPress, ArgoCD, or Grafana.
* **Application Workflow:** Nginx serves requests, PHP-FPM processes dynamic content and interacts with the MySQL database.
* **GitOps Workflow:** ArgoCD continuously monitors Git (source of truth) and updates the Kubernetes API Server to maintain the desired application state.
* **Monitoring Data Flow:** Prometheus Exporters expose application-specific metrics. Prometheus pulls (scrapes) these metrics. Grafana queries Prometheus to visualize the data on dashboards.
* **Control Plane:** The Kubernetes API Server acts as the central hub for all cluster management activities, including deployments, service discovery, and resource orchestration by operators (like Prometheus Operator).

## Technologies Highlighted

* **Container Orchestration:** Kubernetes
* **Continuous Delivery (GitOps):** ArgoCD
* **Monitoring:** Prometheus, Grafana
* **Web Server:** Nginx
* **Application Runtime:** PHP-FPM
* **Containerization:** Docker

## How to View the Diagram

The diagram is defined using [PlantUML](https://plantuml.com/), which allows for text-based diagramming.

1.  **View Online:** You can paste the PlantUML source code (found in `architecture.puml` or similar) into the [PlantUML Online Server](http://www.plantuml.com/plantuml/url) to render it live.
2.  **Generate Locally:**
    * Install Java.
    * Download `plantuml.jar` from the [PlantUML website](http://plantuml.com/download).
    * Run `java -jar plantuml.jar <your_diagram_file>.puml` to generate a PNG image.
    * Many IDEs (like VS Code) have PlantUML extensions for direct rendering.

## Details on tools and technologies used:

1. External Access (Users/Developers):

Users access your DemoApp (WordPress) via its dedicated domain (e.g., wordpress.task.de) which points to the Ingress Controller.
Users access Grafana via its dedicated domain (e.g., grafana.task.de) which also points to the Ingress Controller.
Developers access ArgoCD UI via its dedicated domain (e.g., argocd.task.de) which also points to the Ingress Controller.

2. Ingress Controller:

Acts as the entry point to your cluster.
Based on the Host header (domain name) and Path in the incoming HTTP/HTTPS request, it routes traffic to the correct Kubernetes Service (e.g., DemoApp Service, Grafana Service, ArgoCD Service).

3. Kubernetes Services:

Provide a stable network endpoint for your applications.
They load-balance traffic across the healthy Pods that match their selector labels.

4. Application Pods (DemoApp - WordPress Example):

Your WordPress application runs in Pods. A typical setup includes:
Nginx Container: Serves static files and proxies dynamic requests to PHP-FPM.
PHP-FPM Container: Executes WordPress PHP code.
MySQL/MariaDB Container: The database where WordPress stores its content.
These Pods are typically deployed in their own namespace (e.g., demo-ns).

5. Prometheus Exporters:

Nginx Exporter (Sidecar): Runs alongside your Nginx container, scrapes Nginx's stub_status page, and exposes Nginx metrics.
PHP-FPM Exporter (Sidecar): Runs alongside your PHP-FPM container, scrapes PHP-FPM's status page, and exposes PHP-FPM metrics.
MySQL Exporter (Separate Pod): Runs as its own Pod, connects to your MySQL/MariaDB Service, and exposes database metrics.
These exporters expose metrics on a specific port and path (e.g., /metrics).

6. Prometheus Server:

Deployed in the monitoring namespace (as part of kube-prometheus-stack).
Scrapes Metrics: Prometheus is configured (via ServiceMonitor and PodMonitor resources) to periodically pull (scrape) metrics from all the exporters (Nginx, PHP-FPM, MySQL) and other Kubernetes components (Node Exporter, Kube-state-metrics).
Stores Metrics: It stores this time-series data in its internal Time Series Database (TSDB).

7. Grafana:

Deployed in the monitoring namespace (as part of kube-prometheus-stack).
Queries Prometheus: Grafana connects to the Prometheus Server as a data source.
Visualizes Metrics: It allows you to create and display dashboards using PromQL queries to visualize the metrics collected by Prometheus, giving you insights into your application's performance and health.
8. Prometheus Operator:

Deployed in the monitoring namespace (as part of kube-prometheus-stack).
Manages Monitoring Resources: It's a Kubernetes Operator that watches for custom resources (CRs) like Prometheus, ServiceMonitor, PodMonitor, Alertmanager, PrometheusRule.
It automatically configures and manages the Prometheus and Alertmanager instances based on these CRs.

9. ArgoCD:

Deployed in its own namespace (e.g., argocd-ns).
GitOps Controller: ArgoCD continuously monitors your Git repository (where your application's Kubernetes YAML manifests are stored).
Syncs State: If it detects a difference between the desired state in Git and the actual state in the Kubernetes cluster, it automatically (or manually, depending on configuration) syncs the cluster to match the Git repository.
Interacts with K8s API: ArgoCD's components (like the ArgoCD Server and Repo Server) interact directly with the Kubernetes API server to deploy, update, and manage your application resources.