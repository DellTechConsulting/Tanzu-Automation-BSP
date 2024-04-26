# **Post Tanzu K8s Cluster build task**

## **_Table of Contents:_**
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Steps to run the workflow action](#steps-to-run-the-workflow-action)
- [Sequence of Components gets Installed](#sequence-of-components-gets-installed)
- [References](#references)

## **_Introduction:_**

#### GitHub workflow written in YAML showing how to deploy following list of components as part of Post Tanzu Kubernetes Cluster build.

- Avi HELM Chart/ AKO
- Datadog

## **_Prerequisites:_**

#### To be updated prior executing post cluster build yaml.

##### 1. Update the input values against each env vars in `tkg-Post-cluster-build.yaml` file as appropriate. Example as follows:
    - PROVISIONER_NAME: "namespace-app0001"
    - CLUSTER_NAME: "tkgs-app0001"
    - MGMT_CLUSTER_NAME: "vcf-xyx-tanzu-cluster"
    - KUBECTL_VERSION: "v1.23.8"
    - AKO_VERSION: "1.8.2"
    - AVI_CONTROLLER_HOST: "avi-vcf-tanzu-01.xyz.com"
    - TMC_API_TOKEN: "${{ secrets.TMC_API_TOKEN }}"    
    - AVI_AKO_TOKEN: "${{ secrets.AVI_AKO_TOKEN }}"      
    - DATADOG_API_KEY: "${{ secrets.DATADOG_API_KEY }}"

##### 2. Update `values.yaml` file to input values related to Avi configuration. Example as follows:
  - AKOSettings:
    - clusterName: 'tkg-apm0001'
  - NetworkSettings:
    - nsxtT1LR: '/infra/tier-1s/**avi-namespace-app0001-T1**'
    - vipNetworkList:
      - networkName: "avi-namespace-app0001-L7-VIP"
      - cidr: 10.xx.xx.0/28
  - L7Settings:
    - serviceType: NodePort
    - shardVSSize: SMALL
    - passthroughShardSize: SMALL
    - enableMCI: 'true'
  - ControllerSettings:
    - serviceEngineGroupName: Default-Group
    - controllerVersion: '22.1.4'
    - cloudName: 'vcf-nsxt-cloud'
    - controllerHost: 'avi-vcf-tanzu-01.xyz.com'
    - tenantName: admin

## **_Steps to run the workflow action:_**

##### 1. Update [tkg-Post-cluster-build.yaml](https://github.com/XYZ-Staging/DIGITS-DevOpsHub-tkgs-Infra/blob/feature-branch/.github/workflows/tkg-Post-cluster-build.yaml). Refer [Prerequisites](#prerequisites) section - Point# 1.

##### 2. Update [values.yaml](https://github.com/XYZ-Staging/DIGITS-DevOpsHub-tkgs-Infra/blob/feature-branch/terraform/cluster-build/values.yaml). Refer [Prerequisites](#prerequisites) section - Point# 2.
##### 3. Click on **Actions** to list all the available workflows.
##### 4. Select **Post Cluster Build VCF** workflow from the left pane and **RUN** the workflow.
##### 5. Select the **DEV** environment to allow the workflow to run.
##### 6. Click on the JOB to see the execution logs, and wait for it to complete.
##### 7. Commands to verify the AKO & Datadog installation status:
   - AKO verification commands:
        - To list releases across all namespaces:
          > helm list -A
        - To list all pods within a specified namespace:
          > kubectl get pods -n avi-system
        - DELETE command (Only use while deletion):
          > helm delete `"Type ako-name without quotes"` -n avi-system

   -  DATADOG verification commands:
        - To list releases across all namespaces:
          > helm list -A
        - To list all pods within a specified namespace:
          > kubectl get pods -n datadog
        - DELETE command (Only use while deletion):
          > helm delete `"Type DATADOG name without quotes"` -n datadog

## **_Sequence of Components gets Installed:_**

#### The [tkg-Post-cluster-build.yaml](https://github.com/XYZ-Staging/DIGITS-DevOpsHub-tkgs-Infra/blob/feature-branch/.github/workflows/tkg-Post-cluster-build.yaml) performs following sequence of Install/ Config tasks on its execution:

##### Note: Few installations takes place on `runner machine` and few directly on `Tanzu Kubernetes Cluster`.

- Install kubectl
  - `kubectl` gets installed on runner machine 
  - Required to communicate and control Kubernetes clusters.
- Install helm
  - `helm` gets installed on runner machine
  - A package manager for Kubernetes that includes all the necessary code and resources needed to deploy & manage an application to a cluster.
- Install Tanzu cli
  - `tanzu cli` gets installed on runner machine
  - A CLI tool, required to create and manage management cluster, workload cluster, manage packages etc.
- Get kubeconfig
  - `kubeconfig` information is being fetched from desired cluster.
  - Required to organize information about clusters, users, namespaces, and authentication mechanisms.
- Apply cluster role bindings
  - `cluster role bindings` is applied on desired cluster.
  - Required to manage permissions defined in a role/ cluster role to a user or set of users on namespace(s).
- Install Avi Helm Chart
  - `avi-helm-chart/ AKO` gets installed on tanzu kubernetes cluster.
  - The Avi Kubernetes Operator (AKO) is an operator which works as an ingress Controller and performs Avi-specific functions in a Kubernetes environment with the Avi Controller.
  - Ensure you update the `values.yaml` to edit values related to Avi configuration.
- Install datadog
  - `datadog` gets installed on tanzu kubernetes cluster.
  - It's a monitoring tool that automatically detects services running in Kubernetes clusters and monitors them no matter where they spin up.
- Cleanup step for env vars / files
  - `cleanup` is being performed to clean any stored token/ secrets from env vars/ files.

## **_References_**

#### - [Install AKO using Helm](https://github.com/akshayhavile/load-balancer-and-ingress-services-for-kubernetes/blob/af5c2bb57fa758c58bf1c22263ae545c36ac18bd/docs/install/helm.md)
#### - [Datadog](https://github.com/DataDog/helm-charts/blob/main/charts/datadog/README.md)
