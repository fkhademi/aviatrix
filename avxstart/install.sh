#!/bin/bash
# install shortcuts for starting the controller and updating security groups in AWS

SHELL_FILE="$HOME/.zshrc"  # set to /etc/bashrc or $HOME/.bash_profile for bash
AVX="$HOME/.avx"
mkdir $AVX
curl -s https://raw.githubusercontent.com/fkhademi/aviatrix/main/avxstart/start_avx.py -o $AVX/start_avx.py

chmod +x $AVX/start_avx.py

echo "Enter AWS Region:"
read region
echo "\n******* Controller *******"
echo "EC2 Instance ID:"
read ctrl_id
echo "Security Group ID:"
read ctrl_sg_id

echo "\n******* Co-Pilot *******"
echo "EC2 Instance ID:"
read cplt_id
echo "Security Group ID:"
read cplt_sg_id

echo "Writing config file ..."
echo "[controller]
instance_id=${ctrl_id}
sg_id=${ctrl_sg_id}
region=${region}

[copilot]
instance_id=${cplt_id}
sg_id=${cplt_sg_id}
region=${region}" > $AVX/aviatrix.cfg

read -p "Do you need pip3 and the python packages? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    echo "Installing pip3 ..."
    curl https://bootstrap.pypa.io/get-pip.py -o ~/get_pip.py
    python3 ~/get_pip.py

    echo "Getting a few pythong packages ..."
    pip3 install boto3 configparser requests urllib3
fi

echo "Updating shortcuts ..."
if grep -q "avxgo" $SHELL_FILE 
then
    echo "Shortcuts already exist ..."
else
    echo "Adding shortcuts ..."
    cat <<EOT >> ${SHELL_FILE}
alias avxgo="python3 ${AVX}/start_avx.py -a start"
alias avxstop="python3 ${AVX}/start_avx.py -a stop"
alias avxupdate="python3 ${AVX}/start_avx.py -a update"
alias avxdel="python3 ${AVX}/start_avx.py -a delete"
alias cpltgo="python3 ${AVX}/start_avx.py -a cpltstart"
alias cpltstop="python3 ${AVX}/start_avx.py -a cpltstop"
alias cpltupdate="python3 ${AVX}/start_avx.py -a cpltupdate"
alias cpltdel="python3 ${AVX}/start_avx.py -a cpltdelete"
EOT
fi

sleep 5

echo "DONE ...
The following commands have been added:
avxgo:      Start the Aviatrix Controller and add your public IP to the SG
avxstop:    Stop the Aviatrix Controller and remove your public IP from the SG
avxupdate:  Update the SG with your public IP
avxdel:     Delete the SG rules added by this script
cpltgo:      Start CoPilot and add your public IP to the SG
cpltstop:    Stop CoPilot and remove your public IP from the SG
cpltupdate:  Update the SG with your public IP
cpltdel:     Delete the SG rules added by this script"
