## Deploy docker to ECS with Fargate to ship RDS MySQL logs:

You can deploy your Task Definition in 2 ways:
- [Manual deployment](#Manual-deployment)
- [Cloudformation deployment](#Cloudformation-deployment)

### 1. Create a Log Group on Cloudwatch

Create on Cloudwatch a Log Group named `/aws/ecs/logzio-mysql-logs`.

### 2. Download the task definition JSON

Download the task definition JSON file that matches your use case:

**Using AWS Keys to authenticate:**

```shell
wget https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/ecs/ecs-fargate/task-definition-keys.json
```

**Using IAM Role to authenticate:**

```shell
wget https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/ecs/ecs-fargate/task-definition-iam.json
```

### 3. Configure the task

In your prefered text editor, open the JSON you downloaded in the previous step and replace the following:

| Parameter | Description |
|---|---|
| `<<LOG-SHIPPING-TOKEN>>` | Your Logz.io account token. |
| `<<LISTENER-HOST>>` | Listener URL. For example, `listener.logz.io` if your account is hosted on AWS US East, or `listener-nl.logz.io` if hosted on Azure West Europe. |
| `<<RDS-IDENTIFIER>>` | The RDS identifier of the host from which you want to read logs from. |
| `<<AWS_REGION>>` | Your AWS region |
| `<<AWS-ACCESS-KEY>>` | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). Applies if you chose to authenticate with **AWS Keys**. |
| `<<AWS-SECRET-KEY>>` | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). Applies if you chose to authenticate with **AWS Keys**. |
| `<<RDS-ERROR-LOG-FILE-PATH>>` | The path to the RDS error log file. |
| `<<RDS-SLOW-LOG-FILE-PATH>>` | The path to the RDS slow query log file. |
| `<<RDS-LOG-FILE-PATH>>` | The path to the RDS general log file. |
| `<<YOUR-EXECUTION-ROLE-ARN>>` | The task execution role. Make sure the role has all the appropriate policies. |

### 4. Add your task definition

1. In your [Amazon ECS Classic Console](https://console.aws.amazon.com/ecs/) menu, go to **Task Definitions** and click on **Create new Task Definition**.

2. In the **Step 1: Select launch type compatibility** screen, choose **EC2** and click **Next step**.

3. In the **Step 2: Configure task and container definitions** screen, scroll down and click on the **Configure via JSON** button.

4. In the text-box, delete the existing text and paste your configured task definition JSON. Press **Save**, then press **Create**.

### 5. Run the task

1. After the task was created, click on the **Actions** button, then choose **Run Task**.

2. In the **Run Task** screen, choose **EC2** as your **Launch type**.

3. Choose the cluster you want to ship logs from.

4. For **Placement Templates**, choose **One Task Per Host**.

5. Click on **Run Task**.

### 6. Check Logz.io for your logs

Give your logs some time to get from your system to ours, and then open [Kibana](https://app.logz.io/#/dashboard/kibana).

## Cloudformation Deployment

### 1. Configure and create your stack

Click the button that matches your AWS region and authentication form, then follow the instructions below:

| AWS Region       | Auth with keys                                                                                                                                                                                                                                                                                                                                                   | Auth with IAM Role                                                                                                                                                                                                                                                                                                                                              |
|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `us-east-1`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-east-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-east-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           | 
| `us-east-2`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-east-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-east-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |
| `us-west-1`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-west-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-west-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |
| `us-west-2`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-west-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-us-west-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |
| `ap-northeast-1` | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-northeast-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs) | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-northeast-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs) |
| `ap-northeast-2` | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-northeast-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs) | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-northeast-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs) |
| `ap-northeast-3` | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-3#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-northeast-3.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs) | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-3#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-northeast-3.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs) |
| `ap-south-1`     | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-south-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-south-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)         | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-south-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-south-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)         |
| `ap-southeast-1` | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-southeast-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs) | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-southeast-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs) |
| `ap-southeast-2` | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-southeast-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs) | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-ap-southeast-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs) |
| `ca-central-1`   | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ca-central-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ca-central-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)     | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=ca-central-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-ca-central-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)     |
| `eu-central-1`   | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-central-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)     | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-central-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)     |
| `eu-north-1`     | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-north-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-north-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)         | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-north-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-north-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)         |
| `eu-west-1`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-west-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-west-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |
| `eu-west-2`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-west-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-2#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-west-2.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |
| `eu-west-3`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-3#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-west-3.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-3#/stacks/create/template?templateURL=https://logzio-aws-integrations-eu-west-3.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |
| `sa-east-1`      | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=sa-east-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-sa-east-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-keys.yaml&stackName=logzio-mysql-logs)           | [![Deploy to AWS](https://dytvr9ot2sszz.cloudfront.net/logz-docs/lights/LightS-button.png)](https://console.aws.amazon.com/cloudformation/home?region=sa-east-1#/stacks/create/template?templateURL=https://logzio-aws-integrations-sa-east-1.s3.amazonaws.com/logzio-mysql-logs/1.0.0/ecs/fargate/sam-template-iam.yaml&stackName=logzio-mysql-logs)           |

#### In screen **Step 1 Specify template**:

Keep the defaults and click **Next**.

#### In screen **Step 2 Specify stack details**:

1. For **Stack name** you can either keep the default, or change the stack name.

2. Fill the parameters on that page according to instructions.

3. Click **Next**.


#### In screen **Step 3 Configure stack options** (Optional):

If you want to, you can add your custom tags, or not. Click on **Next**.

#### In screen **Step 4 Review**:

Scroll down and click on **Create stack**.

### 2. Give your stack a few moments to launch.

### 3. Run the task

Go to your ECS cluster, and run the task you just created.

### 4. Check Logz.io for your logs

Give your lo