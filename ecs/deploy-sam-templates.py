import os

import boto3
import os

ENV_AWS_ACCESS_KEY = 'AWS_ACCESS_KEY'
ENV_AWS_SECRET_KEY = 'AWS_SECRET_KEY'
ENV_VERSION = 'VERSION'
AWS_REGIONS = ['ap-northeast-1', 'ap-northeast-2', 'ap-northeast-3', 'ap-south-1', 'ap-southeast-1', 'ap-southeast-2',
               'ca-central-1', 'eu-central-1', 'eu-north-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'sa-east-1',
               'us-east-1', 'us-east-2', 'us-west-1', 'us-west-2']
BUCKET_BASE = 'logzio-aws-integrations-'
FOLDER_NAME = 'logzio-mysql-logs'
SUB_FOLDER = 'ecs'


def run():
    ecs_types = ['ec2', 'fargate']
    auth_types = ['iam', 'keys']
    if is_all_envs_filled():
        for region in AWS_REGIONS:
            s3 = boto3.client('s3', region_name=region, aws_access_key_id=os.environ[ENV_AWS_ACCESS_KEY],
                              aws_secret_access_key=os.environ[ENV_AWS_SECRET_KEY])
            bucket_name = f'{BUCKET_BASE}{region}'
            if is_in_bucket(s3, bucket_name, f'{FOLDER_NAME}/{os.environ[ENV_VERSION]}'):
                print(f'Version {os.environ[ENV_VERSION]} already exists in bucket {bucket_name}. Moving to next bucket.')
                continue
            bucket_path = f'{FOLDER_NAME}/{os.environ[ENV_VERSION]}/{SUB_FOLDER}'
            error_occurred = False
            for ecs_type in ecs_types:
                for auth_type in auth_types:
                    uploaded = upload(s3, bucket_name, bucket_path, f'sam-template-{auth_type}.yaml',ecs_type)
                    if not uploaded:
                        error_occurred = True
                        print(f' Could not upload sam template {auth_type} for {ecs_type} in region {region}')
                        continue
                    changed = change_permissions(s3, bucket_name, bucket_path, f'sam-template-{auth_type}.yaml', ecs_type)
                    if not changed:
                        print(f'!! Could not change permissions for sam template {auth_type} for {ecs_type} in region {region}')
                        continue
            if not error_occurred:
                print(f'Successfully uploaded to region {region}')

    else:
        print('Missing some environment variables. Exiting.')


def is_all_envs_filled():
    return ENV_AWS_SECRET_KEY in os.environ and len(os.environ[ENV_AWS_SECRET_KEY]) > 0 and \
           ENV_AWS_SECRET_KEY in os.environ and len(os.environ[ENV_AWS_SECRET_KEY]) > 0 and \
           ENV_VERSION in os.environ and len(os.environ[ENV_VERSION]) > 0


def is_in_bucket(s3, bucket_name, path):
    resp = s3.list_objects(Bucket=bucket_name, Prefix=path)
    # print(resp)
    return 'Contents' in resp


def upload(s3, bucket_name, bucket_path, file_name, ecs_type):
    try:
        object_path = f'{bucket_path}/{ecs_type}/{file_name}'
        s3.upload_file(f'./ecs-{ecs_type}/{file_name}', bucket_name, object_path)
        return True
    except Exception as e:
        print(e)
        return False


def change_permissions(s3, bucket_name, bucket_path, file_name, ecs_type):
    try:
        object_path = f'{bucket_path}/{ecs_type}/{file_name}'
        response = s3.put_object_acl(
            ACL="public-read", Bucket=bucket_name, Key=object_path
        )
        print(response)
        if 'ResponseMetadata' in response:
            if 'HTTPStatusCode' in response['ResponseMetadata'] and response['ResponseMetadata']['HTTPStatusCode'] == 200:
                return True
    except Exception as e:
        print(e)
    return False


run()
