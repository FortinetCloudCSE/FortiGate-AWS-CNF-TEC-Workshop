---
title: "Deploy FortiGate CNF"
weight: 5
---

This section will demonstrate how easy it is to deploy a FortiGate CNF instance into an existing VPC and redirect traffic to the CNF instance. The FortiGate CNF instance will be deployed into an account managed and owned by Fortinet. Traffic will be redirected into Gateway Load Balancer Endpoints (GWLBe) on ingress and egress. This will give the CNF Instance access to traffic flows and provide L4-L7 inspection and security features. The customer account will not be responsible for managing the FortiGate CNF instance. The FortiGate CNF instance will be managed by Fortinet and will be updated with the latest security features and bug fixes. The customer account will be responsible for managing VPC Route Tables to redirect traffic to the GWLBe endpoints.

# IAM Permissions

The customer account will deploy a CloudFormation Template that creates an IAM Role that can be "assumed" by the FortiGate account. This "assumed" role provides IAM Permissions that allow the GWLBe's to be installed into the customer VPC. 

# VPC Route Table Modifications

Once the FortiGate CNF instance and GWLBe's are deployed, a customer would then modify VPC Route Tables to redirect traffic to the endpoints for inspection. Making these modifications to the route tables is a critical step in the deployment process. If the route tables are not modified correctly, traffic may NOT be redirected to the FortiGate CNF instance for inspection, or you could create asymmetric traffic flows, __or you could create an expensive situation where traffic is crossing availability zone boundary's unnecessarily__.

# Let's get started!