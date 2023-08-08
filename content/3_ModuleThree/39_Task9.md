---
title: "Task 9: Cleanup"
chapter: true
weight: 4
---


# Task 9: Cleanup

* When finished experimenting with the First VPC, let's cleanup the CNF Endpoints, the CNF Instance, and the Workload-VPC. Start by removing all routes in the Workload VPC that point to the CNF endpoints.
* * Log into your AWS account and navigate to the [**Console Home**](https://us-west-2.console.aws.amazon.com/console/home?region=us-west-2#).
* Click on the VPC icon

![](../images/image-t9-1.png)

* Click on "Route tables" in the left pane

![](../images/image-t9-2.png)

* Highlight the IGW Ingress Route table named "cnf-dist-rec-igw-rt". 
* Click on the "Routes" tab at the bottom. 
* Click on "Edit routes".

![](../images/image-t9-3.png)

* Remove the four routes that have a "Target" that points to a "vpce"
* Click "Save Changes"
![](../images/image-t9-4.png)

* Highlight the private route table for AZ1.
* Click the "Routes" tab at the bottom
* Click "Edit routes"

![](../images/image-t9-5.png)

* Change the default route target to the IGW in the VPC.
* Click "Save changes"

![](../images/image-t9-6.png)
![](../images/image-t9-7.png)

* Navigate back to the "Route tables" screen and change the default route for the private subnet in AZ2. 
* Click the "Routes" tab at the bottom
* Click "Edit routes"
* Change the default route target to the IGW in the VPC.
* Click "Save changes"

![](../images/image-t9-8.png)
![](../images/image-t9-9.png)

* Cleanup the Fortigate CNF endpoints and instance
** Navigate back to https://fortigatecnf.com
** Click on CNF Instances
** Double-click the CNF instance we created

![](../images/image-t9-10.png)

** Advance the menu to "Configure Endpoints"
** Highlight each endpoint and click "Delete"

![](../images/image-t9-11.png)
![](../images/image-t9-12.png)

** Click "Refresh" periodically and wait for both endpoint to disappear (~5 min).
** Advance the menu tab to Configure Endpoints

![](../images/image-t9-13.png)

** Click on "CNF Instances"
** Highlight the CNF Instance 
** Click "Delete"
** Wait approximately 10 minutes for the CNF instance to finish deleting

![](../images/image-t9-14.png)

* Log into your AWS account and navigate to the [**Console Home**](https://us-west-2.console.aws.amazon.com/console/home?region=us-west-2#).
* Click on the "AWS Cloudshell" icon
* cd tec-recipe-distributed-ingress-nlb/
* terraform destroy --auto-approve

![](../images/image-t9-15.png)
![](../images/image-t9-16.png)

* Wait for "destroy complete"

![](../images/image-t9-17.png)

* This concludes this section.
