---
title: "Task 12: Deploying CNF Instances and GWLBe endpoints"
chapter: true
weight: 4
---


# Task 12: Deploying CNF Instances and GWLBe endpoints

* In the FortiGate CNF console, navigate to CNF instances and click **New**.

![](../images/image-t12-1.png)

* Provide a name for the CNF instance
* select **us-west-2** for the region
* select **FortiManager Mode**, select **External Syslog** for the log type, and insert the  **Jump Box Public IP** you wrote down earlier when you created the Workload VPC. 

![](../images/image-t12-2.png)

* This time, we will deploy the Fortigate CNF endpoints at the same time we are deploying the CNF instance (save time). 
  * Click **New** under the **Endpoints** section

![](../images/image-t12-3.png)

* Give the Endpoint a name
* We already "on-boarded" the account in the previous lab, so choose your account from the dropdown
* Click the "Inspection" VPC ID from the dropdown. 
* Unclick the "all subnets" button. This will restrict the subnet choices to the properly tagged subnets (the template tagged the correct choices).
* Choose the "fwaas" subnet associated with AZ1
* Click **OK** at the bottom of the page

{{% notice info %}}
**Note:** In order for FortiGate CNF to successfully create a GWLBe in a subnet, **the subnet must be properly tagged**.  The subnet needs a Tag ***Name = fortigatecnf_subnet_type*** and Tag ***Value = endpoint***. Otherwise you will see an error that the subnet ID is invalid.  The subnets below have already been tagged properly. **In this example environment, the subnets above have already been properly tagged.**
{{% /notice %}}

![](../images/image-t12-4.png)
![](../images/image-t12-5.png)

Now repeat the process for the endpoint in AZ2
* Give the Endpoint a name
* We already "on-boarded" the account in the previous lab, so choose your account from the dropdown
* Click the "Inspection" VPC ID from the dropdown. 
* Unclick the "all subnets" button. This will restrict the subnet choices to the properly tagged subnets (the template tagged the correct choices).
* Choose the "fwaas" subnet associated with AZ2

![](../images/image-t12-6.png)
![](../images/image-t12-5.png)

* Now click **OK** on the "Create CNF" screen to start the creation of the CNF Instance and associated Endpoints
{{% notice info %}}
The CNF Instance should show up as **active after roughly 10 minutes** (Now is a great time for a break :) ).
{{% /notice %}}

![](../images/image-t12-7.png)

* Highlight the CNF Instance and click **Edit**. 

![](../images/image-t12-8.png)

* Click **Display Primary FortiGate Information**
* Copy **Primary FGT IP**, **Primary FGT Username**, **Primary FGT Password** to your scratchpad. This information will be used when we add the FortiGate CNF instance to FortiManager as a "managed device".

![](../images/image-t12-7a.png)

* Step through the tabs to verify the Fortigate CNF Instance and Endpoints deployed correctly.

![](../images/image-t12-9.png)
![](../images/image-t12-10.png)
![](../images/image-t12-11.png)

{{% notice info %}} The next task will be to login to FortiManager and provide initial setup.
{{% /notice %}}

* This concludes this section.
