---
title: "Task 16: Creating a FortiGate CNF Policy Set"
chapter: true
weight: 5
---


# Task 16: Create FortiGate CNF Policy Set 

This lab will create a FortiGate CNF Policy Set. This time, instead of using the FortiGate CNF Console to create the policy set, we will use FortiManager. 

Let's create a Policy Set that does the following: 

* Allow Internet access from West VPC (CIDR 192.168.1.0/24)
* Block Internet access from East VPC (CIDR 192.168.0.0/24)
* Allow traffic to/from East AZ1 to West AZ1
* Allow traffic from East AZ2 to West AZ1
* Block traffic from West AZ2 to West AZ2

{{% notice info %}}
**Note:** Keep in mind, we only have to build rules for what is "Allowed". Anything not explicitly allowed, is Denied by the default rule at the bottom of the policy.
{{% /notice %}}

![](../images/image-t16-policy-diagram.png)

Login to the FortiManager. 

  * From your scratchpad, pull the FortiManager Public IP

![](../images/image-t16-1.png)

  * bringup a browser windows and login to FortiManager with the credentials you created earlier

![](../images/image-t16-2.png)

  * Click on **Policy & Objects** 

![](../images/image-t16-3.png)

  * Here you can see the default "Allow All" policy. Make sure the policy package for "FortiGateCNF" is highlighted in the left pane.
  * Let's edit rule #1 (allow_all). Highlight and click edit

![](../images/image-t16-4.png)

  * Change the **Name** to allow_egress_west
  * Double Click Source and in the Address Object screen, click **Create**
  * Setup a subnet address group for west_vpc_az1 (CDIR 192.168.1.0/28) and west_vpc_az2 (CIDR 192.168.1.0/28)

![](../images/image-t16-5.png)
![](../images/image-t16-5a.png)
![](../images/image-t16-5b.png)
![](../images/image-t16-5c.png)

  * Add west_vpc_az1 and west_vpc_az2 address objects to the **Source**
  * Add RFC-1918-10, RFC1918-172, RFC1918-192 objects to the destination and **Negate Destination**
  * Leave defaults for Service "ALL", Schedule "always", Action "Accept", Inspection Mode "Flow-based", NAT "Off"
  * Turn on **Log Allowed Traffic** and set to "All Sessions"
  * Add a **Change Note** and Click **OK**
  * 
![](../images/image-t16-5d.png)
![](../images/image-t16-5e.png)

The rule should look like this in the Policy Editor.

![](../images/image-t16-6.png)

Now let's Allow traffic from West VPC AZ1 to East VPC AZ1 and vice versa.

  * Click **Create New**
  * Set **Name** to "allow_east_west_az1"
  * Set **Incoming Interface** to "protected_vpcs"
  * Set **Outgoing Interface** to "protected_vpcs"
  * Select **Source**
  * Click **+ Create**


![](../images/image-t16-7.png)
![](../images/image-t16-7a.png)  
![](../images/image-t16-7b.png)  

We need to create an address object for "east_vpc_az1"

  * Click **Firewall Address**
  * Set **Name** to "east_vpc_az1"
  * Set **Type** to "Subnet"
  * Set **IP/Netmask** to "192.168.0.0/28"
  * Add a **Change Note** "added east_vpc_az1"
  * Click **OK**

![](../images/image-t16-8.png) 
![](../images/image-t16-8a.png) 

Now we can finish creating the "New Firewall Policy"

  * Set **Source** to "east_vpc_az1" AND "west_vpc_az1"
  * Set **Destination** to "east_vpc_az1" AND "west_vpc_az1"
  * Set **Action** to "Accept"
  * Set **Log Allowed Traffic** to "All Sessions"
  * Add **Change Note** "allow communications between EAST AZ1 and WEST AZ1"
  * Click **OK**

![](../images/image-t16-9.png) 
![](../images/image-t16-9a.png) 

The rule should look like this in the Policy Editor.

![](../images/image-t16-10.png)

Now let's create a rule that allows one-way communication from West VPC AZ2 to East VPC AZ1

  * Click **Create New**

![](../images/image-t16-11.png)

  * Set **Name** to "allow_west_az2 to east_az1"
  * Set **Incoming Interface** to "protected_vpcs"
  * Set **Outgoing Interface** to "protected_vpcs"
  * Select **Source** to "west_vpc_az2"
  * Select **Destination** to "east_vpc_az1"
  * Set **Action** to "Accept"
  * Set **Log Allowed Traffic** to "All Sessions"
  * Add **Change Note** "allow communications between West AZ2 and East AZ1"
  * Click **OK**

![](../images/image-t16-12.png)
![](../images/image-t16-12a.png)

The rule should look like this in the Policy Editor.

![](../images/image-t16-13.png)

Now let's create a rule that allows the jump box to go anywhere

  * Click **Create New**

![](../images/image-t16-13a.png)

  * Set **Name** to "allow_jump_box_anywhere"
  * Set **Incoming Interface** to "protected_vpcs"
  * Set **Outgoing Interface** to "protected_vpcs"
  * Select **Source** and click **+ Create**
  * 
![](../images/image-t16-13b.png)
  
We need to create an address object for "jump_box"

  * Click **Firewall Address**
  * Set **Name** to "jump_box"
  * Set **Type** to "IP Range"
  * Set **IP Range** to "10.0.0.14 - 10.0.0.14"
  * Add a **Change Note** "add jump box"
  * Click **OK**

![](../images/image-t16-13c.png)

  * Set **Source** to "jump_box"
  * Set **Action** to "Accept"
  * Set **Log Allowed Traffic** to "All Sessions"
  * Add **Change Note** "allow communications between West AZ2 and East AZ1"
  * Click **OK**

![](../images/image-t16-13d.png)
![](../images/image-t16-13e.png)

The rule should look like this in the Policy Editor.

![](../images/image-t16-13f.png)

Now let's push policy using the **Install Wizard**

  * Click **Install Wizard**

![](../images/image-t16-14.png)

  * Add **Install Comments** "add CNF Workshop Lab Policies"
  * Click **Next**

![](../images/image-t16-15.png)

  * Accept defaults for screen 2/4 and click **Next**

![](../images/image-t16-16.png)

  * Verify good status on screen 3/4
  * Click **Install**

![](../images/image-t16-17.png)

  * Verify successful policy push on screen 4/4. This should take about 2 minutes.
  * Click **Finish**

![](../images/image-t16-18.png)

This should take you back to the Policy Editor Screen

![](../images/image-t16-19.png)

  * This concludes this section.
