## Deploy docker to ECS with EC2 to ship RDS MySQL logs:

### 1. Create a Log Group on Cloudwatch

Create on Cloudwatch a Log Group named `/aws/ecs/logzio-mysql-logs`.

### 2. Download the task definition JSON

Download the task definition JSON file that matches your use case:

**Using AWS Keys to authenticate:**

```shell
wget https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/ecs/ecs-ec2/task-definition-keys.json
```

**Using IAM Role to authenticate:**

```shell
wget https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/ecs/ecs-ec2/task-definition-iam.json
```

### 3. Configure the task

In your prefered text editor, open the JSON you downloaded in the previous step and replace the following:

| Parameter | Description |
|---|---|
| `<<LOG-SHIPPING-TOKEN>>` | Your Logz.io account token. |
| `<<LISTENER-HOST>>` | Listener URL. For example, `listener.logz.io` if your account is hosted on AWS US East, or `listener-nl.logz.io` if hosted on Azure West Europe. |
| `<<RDS-IDENTIFIER>>` | The RDS identifier of the host from which you want to read logs from. |
| `<<AWS_REGION>>` | Your AWS region. |
| `<<AWS-ACCESS-KEY>>` | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). Applies if you chose to authenticate with **AWS Keys**. |
| `<<AWS-SECRET-KEY>>` | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). Applies if you chose to authenticate with **AWS Keys**. |
| `<<RDS-ERROR-LOG-FILE-PATH>>` | The path to the RDS error log file. |
| `<<RDS-SLOW-LOG-FILE-PATH>>` | The path to the RDS slow query log file. |
| `<<RDS-LOG-FILE-PATH>>` | The path to the RDS general log file. |
| `<<YOUR-EXECUTION-ROLE-ARN>>` | The task execution role. Applies if you chose to authenticate with **IAM Role**. Make sure the role has all the appropriate policies. |

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