# avxstart

### Description

CLI commands for starting an Aviatrix Controller in AWS and auto updating the security groups.

### Install

Download and run the install.sh script:

* `curl -s https://raw.githubusercontent.com/fkhademi/aviatrix/main/avxstart/install.sh -o /tmp/install.sh`  

* Set the `SHELL_TYPE` variable in the install script to specify either _zsh_ or _bash_ shell

* `sh /tmp/install.sh`

* Go to the AWS Console and get the Controller and CoPilot Instance ID's and Security Group ID's


### Usage
|  |  |
| ------ | ----------- |
avxgo | Start the Aviatrix Controller and add your public IP to the SG
avxstop | Stop the Aviatrix Controller and remove your public IP from the SG
avxupdate | Update the SG with your public IP
avxdel | Delete the SG rules added by this script
cpltgo | Start CoPilot and add your public IP to the SG
cpltstop | Stop CoPilot and remove your public IP from the SG
cpltupdate | Update the SG with your public IP
cpltdel | Delete the SG rules added by this script