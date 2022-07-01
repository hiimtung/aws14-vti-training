#!/bin/sh
set -e
temp_profile=tf_temp

resp=$(aws sts get-caller-identity --profile $temp_profile | jq '.UserId')

if [ ! -z $resp ]; then
  echo '{
  "Version": 1,
  "AccessKeyId": "'"$(aws configure get aws_access_key_id --profile $temp_profile)"'",
  "SecretAccessKey": "'"$(aws configure get aws_secret_access_key --profile $temp_profile)"'",
  "SessionToken": "'"$(aws configure get aws_session_token --profile $temp_profile)"'",
  "Expiration": "'"$(aws configure get expiration --profile $temp_profile)"'"
}'
  exit 0
fi
# This will used when using zsh
# vared -p 'Please enter IAM User: ' -c IAM_USER
# echo "You entered $IAM_USER"
# MFA_DEVICE_ARN="arn:aws:iam::<VTIA AccountID>:mfa/$IAM_USER"
# echo "Your MFA ARN: $MFA_DEVICE_ARN"
# vared -p 'Please enter MFA code: ' -c MFA_CODE
# echo "You entered $MFA_CODE"

read -p "Enter IAM User: " IAM_USER
read -p "Enter MFA token: " MFA_CODE
MFA_DEVICE_ARN="arn:aws:iam::<VTIA AccountID>:mfa/$IAM_USER"
cmd=$(aws sts get-session-token \
    --serial-number $MFA_DEVICE_ARN \
    --token-code $MFA_CODE | jq '.Credentials')
check=$(echo $cmd | jq -r '.AccessKeyId')
if [ -z $check ]; then 
    echo "You could put wrong IAM User or Token, please re-run and input again"
    exit 1
fi

aws_access_key_id=$(echo $cmd | jq -r '.AccessKeyId')
aws_secret_access_key=$(echo $cmd | jq -r '.SecretAccessKey')
aws_session_token=$(echo $cmd | jq -r '.SessionToken')
expiration=$(echo $cmd | jq -r '.Expiration')

aws configure set aws_access_key_id $aws_access_key_id --profile $temp_profile
aws configure set aws_secret_access_key $aws_secret_access_key --profile $temp_profile
aws configure set aws_session_token $aws_session_token --profile $temp_profile
aws configure set expiration $expiration --profile $temp_profile

echo '{
  "Version": 1,
  "AccessKeyId": "'"$aws_access_key_id"'",
  "SecretAccessKey": "'"$aws_secret_access_key"'",
  "SessionToken": "'"$aws_session_token"'",
  "Expiration": "'"$expiration"'"
}'
