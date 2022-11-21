#!/bin/bash

#
# CMD_VERBOSE=0: turn off actual aws cmd
#

__run_aws_cmd() {
	if [ "_$CMD_VERBOSE"  != "_0" ]; then
		echo cmd: "$*" 1>&2
	fi

	local __aws_cmd_ret=$($*)
	echo "$__aws_cmd_ret" | jq . -r
}

__run_vpc_admin_cmd() {
	if [ "_$CMD_VERBOSE"  != "_0" ]; then
		echo cmd: "$*" 1>&2
	fi

	local __vpc_admin_cmd_ret=$($*)
	echo "$__vpc_admin_cmd_ret" | jq -r .Result | jq -r .
}

########## primitive functions

get_ngw_desc() {
	local ngw_id=$1

	if [ -z "$ngw_id" ]; then
		return "ngw-id is empty"
	fi

	__run_aws_cmd "aws ec2 describe-nat-gateways --nat-gateway-ids $ngw_id"
}

get_eni_desc() {
	local eni_id=$1

	if [ -z "$eni_id" ]; then
		return "eni-id is empty"
	fi

	__run_aws_cmd "aws ec2 describe-network-interfaces --network-interface-ids $eni_id"
}

get_inst_desc() {
	local inst_id=$1

	if [ -z "$inst_id" ]; then
		return "inst-id is empty"
	fi

	__run_aws_cmd "aws ec2 describe-instances --instance-ids $inst_id"
}

#################################### vpc admin functions

admin_get_eni_desc() {

	local eni_id=$1
	#__run_vpc_admin_cmd "aws ec2 admin-vpc --admin-action list-network-interface --parameters Name=network-interface-id,Values=$1"
	__run_aws_cmd "aws ec2 describe-network-interfaces-spc --network-interface-ids $1"
}


########################### extened functions

get_inst_id_by_eni() {
	local eni_id=$1

	if [ -z "$eni_id" ]; then
		return "eni-id is empty"
	fi

	local eni_desc=$(get_eni_desc $eni_id)
	local inst_id=$(echo "$eni_desc" | jq --raw-output '.NetworkInterfaces[].Attachment.InstanceId')

	echo "$inst_id"
}

get_ngw_inst() {
	local ngw_id=$1

	# turn off actual aws cmd
	#CMD_VERBOSE=0

	local ngw_desc=$(get_ngw_desc $ngw_id)
	echo "$ngw_desc"

	local ngw_eni_id=$(echo "$ngw_desc" | jq --raw-output '.NatGateways[].NatGatewayAddresses[].NetworkInterfaceId')
	local ngw_eip=$(echo "$ngw_desc" | jq --raw-output '.NatGateways[].NatGatewayAddresses[].PublicIp')
	local ngw_ip=$(echo "$ngw_desc" | jq --raw-output '.NatGateways[].NatGatewayAddresses[].PrivateIp')
	local ngw_admin_ip=$(echo "$ngw_desc" | jq --raw-output '.NatGateways[].InstanceStatuses[].LastMetric[]|select(.Key=="admin-ip")|.Value' )

	local ngw_inst_id=$(get_inst_id_by_eni $ngw_eni_id)
	local ngw_inst_desc=$(get_inst_desc $ngw_inst_id)

	echo "$ngw_inst_desc"

	#local mgmt_ip=$(echo "$ngw_inst_desc" | jq --raw-output '.Reservations[].Instances[].NetworkInterfaces[0].PrivateIpAddress')
	local mgmt_eni=$(echo "$ngw_inst_desc" | jq --raw-output '.Reservations[].Instances[].NetworkInterfaces[0].NetworkInterfaceId')
	local mgmt_az=$(echo "$ngw_inst_desc" | jq --raw-output '.Reservations[].Instances[].Placement.AvailabilityZone')
	local host_ip=$(admin_get_eni_desc $mgmt_eni | jq --raw-output '.NetworkInterfaces[].HostIp')

	echo "NGW Info: $ngw_id"
	echo "user: $ngw_inst_id $ngw_eni_id $ngw_eip $ngw_ip"
	echo "mgmt: $mgmt_eni $mgmt_az [$host_ip] [$ngw_admin_ip]"
}

update_admin_api() {
	#git clone git@github.com:cloud-pi/aws-sdk-go.git
	#git checkout -b ec2 origin/master

	pushd `pwd`

	cd ~/src/aws-sdk-go
	echo "update local repository"
	git pull

	echo "copy file..."
	/bin/cp -f models/apis/ec2/2016-11-15/api-2.json ~/.aws/models/ec2/2016-11-15/service-2.json

	popd
}

