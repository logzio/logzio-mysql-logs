## Deploying to Kubernetes to ship RDS logs

**Before you begin, you'll need**: Destination port 5015 open on your firewall for outgoing traffic.

**Important note**: this is a basic deployment. If there are advanced configurations that you wish to apply, you'll need to adjust and edit the deployment.

### 1. Create monitoring namespace:

If you don't already have a **monitoring** namespace in your cluster, create one using the following command:

```sh
kubectl create namespace monitoring
```

The `logzio-mysql-logs` will be deployed under this namespace.

### 2. Store your credentials:

Save your Logz.io shipping credentials as a Kubernetes secret using the following command:


```sh
kubectl create secret generic logzio-logs-secret -n kube-system \
--from-literal=logzio-logs-shipping-token='<<LOG-SHIPPING-TOKEN>>' \
--from-literal=logzio-logs-listener='<<LISTENER-HOST>>' \
--from-literal=rds-identifier='<<RDS-IDENTIFIER>>' \
# Uncomment the lines below if you wish to insert any of the following variables:
#--from-literal=aws-access-key='<<AWS-ACCESS-KEY>>' \
#--from-literal=aws-secret-key='<<AWS-SECRET-KEY>>' \
#--from-literal=rds-error-log-file='<<RDS-ERROR-LOG-FILE-PATH>>' \
#--from-literal=rds-slow-log-file='<<RDS-SLOW-LOG-FILE-PATH>>' \
#--from-literal=rds-log-file='<<RDS-LOG-FILE-PATH>>' \
-n monitoring
```

**Note:** If you're deploying to EKS cluster, and it has the appropriate IAM role permissions, you don't have to specify your AWS keys.

Replace the placeholders to match your specifics. (They are indicated by the double angle brackets << >>):


| Parameter | Description | Required/Default |
|---|---|---|
| logzio-logs-shipping-token | Your Logz.io account token. Replace `<<LOG-SHIPPING-TOKEN>>` with the token of the account you want to ship to. | Required |
| logzio-logs-listener | Listener URL. Replace `<<LISTENER-HOST>>` with the host [for your region](https://docs.logz.io/user-guide/accounts/account-region.html#available-regions). For example, `listener.logz.io` if your account is hosted on AWS US East, or `listener-nl.logz.io` if hosted on Azure West Europe. | Required. Default: `listener.logz.io` |
| rds-identifier | The RDS identifier of the host from which you want to read logs from. | Required |
| aws-access-key | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). | Optional |
| aws-secret-key | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). | Optional |
| rds-error-log-file | The path to the RDS error log file. | Optional. `error/mysql-error.log` |
| rds-slow-log-file | The path to the RDS slow query log file. | Optional. `slowquery/mysql-slowquery.log` |
| rds-log-file | The path to the RDS general log file. | Optional. `general/mysql-general.log` |



### 3. Deploy

Run the following command:

```sh
kubectl apply -f https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/k8s/logzio-deployment.yaml
```

**Note**: If you chose to use one of the optional parameters in the previous step, you'll have to edit the [deployment file](https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/k8s/logzio-deployment.yaml) - download it, and uncomment the environment variables that you wish to use.


### 4. Check Logz.io for your logs

Give your logs some time to get from your system to ours, and then open [Kibana](https://app.logz.io/#/dashboard/kibana).

If you still don’t see your logs, see [log shipping troubleshooting](https://docs.logz.io/user-guide/log-shipping/log-shipping-troubleshooting.html).
