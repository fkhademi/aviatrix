# avxstart

### Description

CLI commands for starting an Aviatrix Controller in AWS and auto updating the security groups.

Set the SHELL_TYPE variable in the install script to specify either zsh or bash shell

### Usage

avxgo:      Start the Aviatrix Controller and add your public IP to the SG
avxstop:    Stop the Aviatrix Controller and remove your public IP from the SG
avxupdate:  Update the SG with your public IP
avxdel:     Delete the SG rules added by this script
cpltgo:      Start CoPilot and add your public IP to the SG
cpltstop:    Stop CoPilot and remove your public IP from the SG
cpltupdate:  Update the SG with your public IP
cpltdel:     Delete the SG rules added by this script