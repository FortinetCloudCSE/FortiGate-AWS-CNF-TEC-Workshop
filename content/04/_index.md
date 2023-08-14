---
title: "Protect the Workload VPC with Security Groups"
weight: 4
---

This section will configure security groups to protect a few of the critical resources in the demo environment.  Security Groups are stateful firewalls that control traffic to and from AWS resources.  Security Groups are applied to AWS resources such as EC2 instances, RDS instances, and Elastic Load Balancers.  This type of security is limited to layer 4 only and is not able to inspect the contents of the traffic.  For this reason, it is recommended to use Security Groups in conjunction with a FortiGate CNF to provide layer 7 inspection and advanced security features.