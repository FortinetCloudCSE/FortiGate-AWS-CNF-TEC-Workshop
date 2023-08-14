---
title: "Task 5: Onboard an AWS account to FortiGate CNF"
weight: 2
---

* In the FortiGate CNF Console, navigate to AWS Accounts, then click **New** to start the add account wizard.

![](../images/image-t5-1.png)

* In a new browser tab, log into your AWS account and click on your **IAM user name in the upper right corner**. This will allow you to see and copy your AWS account ID.

![](../images/image-t5-2.png)

* In the FortiGate CNF Console, provide your AWS account ID and select Launch CloudFormation Template. This will redirect you to the CloudFormation Console in your AWS account in the us-west-2 region.

{{% notice info %}}
**Note:** Your browser may block the popup window to launch the CloudFormation console.  Please check your browser for blocked popup notifications.
{{% /notice %}}

![](../images/image-t5-3.png)

* This CloudFormation Template creates the following items:

	* S3 bucket for sending logs

	* IAM Cross Account Role which allows us to manage GWLBe endpoints, describe VPCs, push logs to S3, and describe instances and EKS clusters for the SDN connector feature (dynamic address objects based on metadata).

	* Custom resources which kicks off automation on our managed accounts to complete backend tasks for onboarding the AWS account.

* Please follow through the create stack wizard **without changing the region or any of the parameter values**. Simply follow the steps outlined in the FortiGate CNF Console and click through the CloudFormation wizard.

{{% notice info %}}
**Note:** This CloudFormation template must be ran in the us-west-2 (Oregon) region for successful onboarding and ongoing operations of this AWS account with FortiGate CNF.
{{% /notice %}}

![](../images/image-t5-4.png)

* Once the CloudFormation template has been created successfully, you should see your account showing **Success** in the AWS account page of FortiGate CNF.

![](../images/image-t5-5.png)

* This concludes this section.
