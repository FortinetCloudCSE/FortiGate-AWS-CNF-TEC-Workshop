---
title: "Task 19: Cleanup"
chapter: true
weight: 5
---


# Task 19: Cleanup

* When finished experimenting with the Policy Set, let's cleanup the CNF Endpoints, the CNF Instance, and the Workload-VPC. Start by removing all routes in the Workload VPC that point to the CNF endpoints.
* * Log into your AWS account and navigate to the [**Console Home**](https://us-west-2.console.aws.amazon.com/console/home?region=us-west-2#).
* Click on the VPC icon

![](../images/image-t19-1.png)

* Click on "Route tables" in the left pane

![](../images/image-t19-2.png)


* Highlight the private route table for the Inspection VPC in AZ1 (tec-cnf-lab-inspection-private-rt-az1)
* Click the "Routes" tab at the bottom
* Click "Edit routes"

![](../images/image-t19-3.png)

* Click **Remove** for both routes that point to the vpc endpoint
* Click "Save changes"

![](../images/image-t19-4.png)

* The modified route table should like this. Click **Route tables** to continue

![](../images/image-t19-5.png)

* Highlight the private route table for the Inspection VPC in AZ2 (tec-cnf-lab-inspection-private-rt-az2)
* Click the "Routes" tab at the bottom
* Click "Edit routes"

![](../images/image-t19-6.png)


* Click **Remove** for both routes that point to the vpc endpoint
* Click "Save changes"

![](../images/image-t19-7.png)

* The modified route table should like this. Click **Route tables** to continue

![](../images/image-t19-8.png)

* Highlight the public route table for the Inspection VPC in AZ1 (tec-cnf-lab-inspection-public-rt-az1)
* Click the "Routes" tab at the bottom
* Click "Edit routes"

![](../images/image-t19-9.png)

* Click **Remove** for the route that points to the vpc endpoint
* Click "Save changes"

![](../images/image-t19-10.png)


* The modified route table should like this. Click **Route tables** to continue

![](../images/image-t19-11.png)

* Highlight the public route table for the Inspection VPC in AZ2 (tec-cnf-lab-inspection-public-rt-az2)
* Click the "Routes" tab at the bottom
* Click "Edit routes"

![](../images/image-t19-12.png)

* Click **Remove** for the route that points to the vpc endpoint
* Click "Save changes"

![](../images/image-t19-13.png)


* The modified route table should like this. Click **Route tables** to continue

![](../images/image-t19-14.png)

* Cleanup the Fortigate CNF endpoints and instance
* Navigate back to https://fortigatecnf.com
* Click on the proper account
* Click on CNF Instances
* Highlight CNF Instance for corp-us-west-2-cnf
* Click on **Delete**

![](../images/image-t19-15.png)

* Log into your AWS account and navigate to the [**Console Home**](https://us-west-2.console.aws.amazon.com/console/home?region=us-west-2#).
* Click on the "AWS Cloudshell" icon
* cd cnf-tec-workshop-terraform/
* cd centralized_ingress_egress_east_west/
* terraform destroy --auto-approve

![](../images/image-t19-16.png)

* Wait for "destroy complete"

![](../images/image-t19-17.png)

* This concludes this section.
