---
title: "Task 13: Login to FortiManager and provide initial configuration"
chapter: true
weight: 4
---


# Task 13: Login to FortiManager and provide initial configuration

Let's login to the FortiManager. 
  * From Console Home, click on EC2
  * From EC2, click on Instances (running)
  * Choose the FortiManager instance.
  * Click **Details** tab if it isn't already highlighted.
  * Click the **open address** link associated with the Public IP of the FortiManager.

![](../images/image-t13-1.png)
![](../images/image-t13-2.png)
![](../images/image-t13-3.png)

* Accept the self-signed certificate warnings

![](../images/image-t13-4.png)

* Login to the FortiManager login screen with your FortiCloud account credentials
* Click the **Free Trial** license option.
* Click **Login with FortiCloud**

![](../images/image-t13-5.png)

* Accept the License Agreement.

![](../images/image-t13-6.png)

* FortiManager will restart and apply the trial license. 

![](../images/image-t13-7.png)

* After FortiManager reboots and the Web Interface refreshes, Accept the Pre-Login Disclaimer

![](../images/image-t13-8.png)

* Retrieve the instance id from the AWS EC2 screen for FortiManager.
* Use "admin" as the username and the instance-id as the password to login to FortiManager.
* Click **Begin** to step through the initial FortiManager setup screens.
* Accept default Hostname (or change it if you like).
* Click **Finish** to complete setup.

![](../images/image-t13-9.png)
![](../images/image-t13-10.png)
![](../images/image-t13-11.png)
![](../images/image-t13-12.png)
![](../images/image-t13-13.png)
![](../images/image-t13-14.png)

* Change Password from default "instance-id". 
  * Insert "instance-id"
  * Insert New Password and Confirm Password 
  * When you change the default password, Fortimanager will logout and force you to re-enter the new password.
  
![](../images/image-t13-15.png)
![](../images/image-t13-16.png)

{{% notice info %}} The next task will be to add our Fortigate CNF instance to our FortiManager as a managed device.
{{% /notice %}}

* This concludes this section.
