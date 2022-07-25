## Deploying to Kubernetes to ship RDS logs

**Before you begin, you'll need**: Destination port 5015 open on your firewall for outgoing traffic.

**Important note**: this is a basic deployment. If there are advanced configurations that you wish to apply, you'll need to adjust and edit the deployment.

### 1. Store your credentials:

Save your Logz.io shipping credentials as a Kubernetes secret. Customize the sample command below to your specifics before running it.


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
-n kube-system
```

**Note:** If you're deploying to EKS cluster, and it has the appropriate IAM role permissions, you don't have to specify your AWS keys.

Replace the placeholders to match your specifics. (They are indicated by the double angle brackets << >>):

Mandatory:
- Replace `<<LOG-SHIPPING-TOKEN>>` with the token of the account you want to ship to.
- Replace `<<LISTENER-HOST>>` with the host for your region. For example, `listener.logz.io` if your account is hosted on AWS US East, or `listener-nl.logz.io` if hosted on Azure West Europe.
- Replace `<<RDS-IDENTIFIER>>` with the identifier of your RDS instance.

Optional:
- Replace `<<AWS-ACCESS-KEY>>` with your AWS access key.
- Replace `<<AWS-SECRET-KEY>>` with your AWS secret key.
- Replace `<<RDS-ERROR-LOG-FILE-PATH>>` with the path to the RDS error log file. Default: error/mysql-error.log.
- Replace `<<RDS-SLOW-LOG-FILE-PATH>>` with the path to the RDS slow query log file. Default: slowquery/mysql-slowquery.log.
- Replace `<<RDS-LOG-FILE-PATH>>` with the path to the RDS general log file. Default: general/mysql-general.log.

### 2. Deploy

Run the following command:

```sh
kubectl apply -f https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/k8s/logzio-deployment.yaml
```

**Note**: If you chose to use one of the optional parameters in step 1, you'll have to edit the [deployment file](https://raw.githubusercontent.com/logzio/logzio-mysql-logs/master/k8s/logzio-deployment.yaml) - download it, and uncomment the environment variables that you wish to use.


### 3. Check Logz.io for your logs

Give your logs some time to get from your system to ours, and then open [Kibana](https://app.logz.io/#/dashboard/kibana).

If you still don’t see your logs, see [log shipping troubleshooting](https://docs.logz.io/user-guide/log-shipping/log-shipping-troubleshooting.html).
