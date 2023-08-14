---
title: "Create FortiGate CNF Policy Set"
weight: 6
---

Policies are rules that govern how traffic is handled by the firewall. Policies use address and service objects to build matching rules and security profiles to define what action is to be taken.

Policy sets are groups of rules. A single policy set is deployed to a firewall instance, but policy sets may be re-used across multiple firewall instances.

Each CNF instance uses a single policy set at a time, but a single policy set can be used by multiple FortiGate CNF instances. Objects can also be used across multiple policy sets.

Fortigate CNF can create dynamic address objects based on cloud native tags, fully qualified domain-names, or even geography based IP's or malicious IPs provided by the Fortiguard service IP Database. This allows for dynamic security policies that can keep up with the dynamic nature of cloud infrastructure.
