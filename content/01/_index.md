---
title: "Introduction"
weight: 1
---

# How to Demo and Sell FortiGate CNF

![](./images/image-cnf-overview.png)

## Welcome!

In this TEC Recipe, you will learn how to deploy FortiGate Cloud Native Firewall as a Service (FortiGate CNF). Fortinet customers can use this service to protect AWS workloads deployed in the cloud. Later sections in the TEC Recipe will demonstrate the use of common architecture patterns to protect different types of ingress, egress, and East-West traffic.

This TEC Recipe is intended to help accomplish the following:

  * Learn common AWS networking concepts such as routing traffic in and out of VPCs for various traffic flows
  * Use AWS Cloudshell and Terraform to deploy a demo environment
  * Interact with FortiGate CNF Portal to deploy CNF instances, build security policy sets, and deploy them
  * Test traffic flows in an example environment and use FortiGate CNF to control traffic flows
  * Configure FortiManager to manage FortiGate CNF instances
  * Configure FortiAnalyzer to collect and analyze logs from FortiGate CNF instances
  * Learn how to use FortiGate CNF to protect AWS workloads in common architecture patterns
  * Configure SDN Connectors to integrate FortiGate CNF with VPC Tagged objects and dynamic policy creation

## Learning Objectives

At the end of this TEC Recipe, you will complete the following objectives:
  
  * Understand AWS Networking Concepts *(10 minutes)*
  * Understand AWS Common Architecture Patterns *(10 minutes)*
  * Understand FortiGate CNF terminology *(5 minutes)*
  * Subscribe to FortiGate CNF *(5 minutes)*
  * Onboard an AWS account *(5 minutes)*
  * Use AWS Cloudshell and Terraform to deploy a demo environment *(10 minutes)*
  * Deploy a FortiGate CNF Instance & GWLBe endpoints *(20 minutes)*
  * Create a policy set and apply it to a FortiGate CNF Instance *(10 minutes)*
  * Test traffic flows (distributed in + egress and centralized e-w + egress) *(20 minutes)*

## TEC Recipe Components

These are the AWS and Fortinet components that will be used during this workshop:

  * AWS Marketplace
  * FortiCloud 
  * FortiGate CNF Portal
  * Hashicorp Terraform Templates (Infrastructure as Code, IaC)
  * AWS SDN (AWS intrinsic router and route tables in a VPC)
  * AWS Gateway Load Balancer (GWLB)
  * AWS Transit Gateway (TGW)
  * AWS EC2 Instances (Amazon Linux OS)

## AWS Reference Architecture Diagram

This is the architecture and environment that will be used in the workshop.

  * With AWS networking, there are several ways to organize your AWS architecture to take advantage of FortiGate CNF traffic inspection. The important point to know is that as long as the traffic flow has a symmetrical routing path (for forward and reverse flows), the architecture will work.

  * This diagram will highlight two main designs that are common architecture patterns for securing traffic flows.
  * **Distributed Ingress + Egress**
  * **Centralized Egress + East-West**

![](./images/image-ref-diag1.png)
