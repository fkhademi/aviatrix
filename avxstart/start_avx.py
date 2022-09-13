#!/usr/bin/env python3

# Script to start or stop the Controller and update the SG with client IP

import requests
import json
import sys
import urllib3
import time
import socket
import boto3
import argparse
import configparser
from requests import get
import os

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


parser = argparse.ArgumentParser()
   
parser.add_argument('-a', '--action', action='store', 
    help="Start | Stop | Update | Delete - Start or Stop instance, Update SG, or Delete previous rules")

args = parser.parse_args()

config_file=('%s/.avx/aviatrix.cfg' %(os.path.expanduser('~')))


config = configparser.ConfigParser()
config.sections()
config.read(config_file)
config.sections()

controller = config['controller']
sg_id=controller['sg_id']
region=controller['region']
instance_id=controller['instance_id']
copilot = config['copilot']
cplt_sg_id=copilot['sg_id']
cplt_region=copilot['region']
cplt_instance_id=copilot['instance_id']
action=args.action


ec2 = boto3.client('ec2',region_name=region)


def start_vm(instance_id):
    # Power on the instance
    try:
        data = ec2.start_instances( InstanceIds=[ instance_id ], DryRun=False )
        print("[INFO] VM started with instance ID ",sg_id)
        #return true
    except Exception as e:
        print("[ERROR] ", e)
        exit()

def stop_vm(instance_id):
    # Stop the instance
    try:
        data = ec2.stop_instances( InstanceIds=[ instance_id ], DryRun=False )
        print("[INFO] VM stopped with instance ID ",instance_id)
    except Exception as e:
        print("[ERROR] ", e)
        exit()

def add_rule(sg_id, proto, port, ip):
    # Add Security Group Rule
    try:
        data = ec2.authorize_security_group_ingress(
            GroupId=sg_id,
            IpPermissions=[
                {'IpProtocol': proto,
                'FromPort': int(port),
                'ToPort': int(port),
                'IpRanges': [{'CidrIp': ip,'Description': 'Added by script'}]}
            ])
        print("[ADDED] Added SG Rule for IP:", ip, " Port:", port, " Protocol:", proto, " to SG:",sg_id)
    except Exception as e:
        print("[ERROR] ", e)


def del_rule(sg_id, proto, port, ip):
    # Delete Security Group Rule
    try:
        data = ec2.revoke_security_group_ingress(
            GroupId=sg_id,
            IpPermissions=[
                {'IpProtocol': proto,
                'FromPort': int(port),
                'ToPort': int(port),
                'IpRanges': [{'CidrIp': ip}]}
            ])
        print("[DELETED] Deleted SG Rule for IP:", ip, " Port:", port, " Protocol:", proto, " to SG:",sg_id)
    except Exception as e:
        print("[ERROR] ", e)


def del_rules(sg_id):
    # Get the security group rules from the Controller SG
    sg_output = ec2.describe_security_groups(
        Filters=[
            {
                'Name': 'group-id',
                'Values': [
                    sg_id,
                ]
            },
        ],
    )
    for i in sg_output['SecurityGroups']:
        for j in i['IpPermissions']:
            try:
                for k in j['IpRanges']:
                    # For each CIDR in the Controller SG, check if there is a description in the SG and delete the rule
                    if 'Description' not in k:
                        print("[INFO] No description for rule ",k['CidrIp'])
                    else:
                        print("[INFO] Found ", k['CidrIp'] ," in Controller SG", k['Description'])
                        if k['Description'] == "Added by script":
                            del_rule(sg_id, "TCP", 443, k['CidrIp'])
                            print("[INFO] Found ", k['CidrIp'] ," in Controller SG - ", k['Description'])
            except Exception as e:
                print("[ERROR] ", e)


ip = get('https://api.ipify.org').content.decode('utf8')
ip = "%s/32" %ip

if action.casefold() == "start":
    start_vm(instance_id)
    add_rule(sg_id, "TCP", 443, ip)

elif action.casefold() == "stop":
    stop_vm(instance_id)
    del_rule(sg_id, "TCP", 443, ip)

elif action.casefold() == "update":
    add_rule(sg_id, "TCP", 443, ip)

elif action.casefold() == "delete":
    del_rules(sg_id)

elif action.casefold() == "cpltstart":
    start_vm(cplt_instance_id)
    add_rule(cplt_sg_id, "TCP", 443, ip)

elif action.casefold() == "cpltstop":
    stop_vm(cplt_instance_id)
    del_rule(cplt_sg_id, "TCP", 443, ip)

elif action.casefold() == "cpltupdate":
    add_rule(cplt_sg_id, "TCP", 443, ip)

elif action.casefold() == "cpltdelete":
    del_rules(cplt_sg_id)