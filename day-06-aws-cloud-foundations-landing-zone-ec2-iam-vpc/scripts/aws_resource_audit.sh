#!/bin/bash
# Day 6: AWS Cloud Foundation Resource Audit Script
# Inspects EC2 instances, IAM configurations, and VPC subnets using AWS CLI

set -euo pipefail

echo "======================================================="
echo "       AWS CLOUD FOUNDATION INVENTORY AUDIT            "
echo "======================================================="

# Check AWS CLI availability
if ! command -v aws > /dev/null 2>&1; then
    echo "Note: AWS CLI is not installed in local simulation environment."
    echo "Sample expected commands and outputs demonstrated below:"
    echo ""
    echo "1. Query Running EC2 Instances:"
    echo "   $ aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]'"
    echo ""
    echo "2. Audit Active IAM Users:"
    echo "   $ aws iam list-users --query 'Users[*].[UserName,UserId,CreateDate]'"
    echo ""
    echo "3. List VPCs & Subnets:"
    echo "   $ aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock,IsDefault]'"
    echo "======================================================="
    exit 0
fi

echo -e "\n[1] Checking Active IAM Identity:"
aws sts get-caller-identity --output table

echo -e "\n[2] Checking Configured VPCs:"
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock,IsDefault]' --output table

echo -e "\n[3] Checking EC2 Instances:"
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' --output table

echo -e "\n======================================================="
echo "Audit complete."
