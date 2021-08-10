#!/bin/bash

in_json_file=""

base_dir="$HOME/Library/Application\ Support/iTerm2/DynamicProfiles/"
output="./iterms2-dynamic-profiles.json"

_comma=""

get_value() {
	local v=$(echo "$1" | jq .\"$2\")
	echo $v
}

out() {
	echo "$@" >> $output
}

truncate_file() {
	echo "" > $1
}

print_key_val() {
	echo -E "\"$1\": \"$2\""
}

print_key_arr() {
	local key argv json

	key=$1
	shift 1

	ar=("$@")
	json="[$(printf '"%b",' "${ar[@]}")"
	json="${json%,}]"

	echo \"${key}\": $json
}

print_header() {
	truncate_file $output

	#out "// iTerms Dynamic Profiles for SPC"
	#out "// DONOT edit it manually"
	#out ""

	out "{"
	out " \"Profiles\": ["
}

print_footer() {
	out ""
	out " ]"
	out "}"
}

print_profile_item() {
	local name tag_zone

	if [ -n "${_comma}" ]; then
		out "${_comma}"
	fi

	if [ "${hosttype}" == "inst" ]; then
		name="${region}-${hosttype}-${adminip}-${privateip}"
		tag_zone=""
	else
		if [ "_${rack}" != "_" ]; then
			name="${region}-${hosttype}-${zone}-${adminip}-${rack}"
		else
			name="${region}-${hosttype}-${zone}-${adminip}"
		fi

		tag_zone="Dy-${region}-${zone}"
	fi

	out "  {"
	out "    $(print_key_val Name ${name}),"
	out "    $(print_key_val Guid "guid-${name}"),"
	out "    $(print_key_arr Tags Dy-${region} Dy-${region}-${hosttype} ${tag_zone}),"
	out "    $(print_key_val "Custom Command" Yes),"
	out "    $(print_key_val "Command" "ssh ${sshopts} -i ${sshkey} ${user}@${adminip}"),"
	local newvar=$(echo $badgetext|sed -e 's/\\/\\\\/g')
	out "    $(print_key_val "Badge Text" "${newvar}"),"
	if [ "_${initial_text}" != "_" ]; then
		out "    $(print_key_val "Initial Text" "${initial_text}"),"
	fi

	## end of item
	out "    $(print_key_val "Dynamic Profile Parent Name" ${baseprofile})"
	echo -n "  }" >> $output

	_comma=","
}

parse_host_list() {
	local conf=$1
	local region_name=$2
	local host_list=$3
	local i row len

	len=$(echo "$host_list" | jq 'length')
	for (( i=0; i<len; i+=1 )); do
		row=$(echo "$host_list" | jq ".[$i]")
		# converte json to bash variables
		eval "$(echo $conf | jq -r 'to_entries | .[] | .key + "=\"" + .value + "\""')"
		eval "$(echo $row | jq -r 'to_entries | .[] | .key + "=\"" + .value + "\""')"

		#echo "Index: $i"
		#echo "adminip: $adminip"
		#echo "user: $user"

		print_profile_item
	done
}

#################
main() {
	if [ ! -e $in_json_file ]; then
		echo "No file: $in_json_file"
		exit 1
	fi
	if [ -z "$output" ]; then
		echo "No output file name"
		exit 1
	fi

	echo "Generating profiles..."
	print_header

	data=$(cat $in_json_file)
	#echo "### Data: $data"

	regions=$(echo "$data" | jq '. | to_entries | .[].key')
	#echo "${regions}"

	for r in $regions; do
		eval "region=$r"

		region_data=$(get_value "$data" "$region")
		#echo "### region-data: <$region_data>"

		config=$(get_value "$region_data" "config")
		#echo "### config: $config"

		# convert config to bash variables
		eval "$(echo $config | jq -r 'to_entries | .[] | .key + "=\"" + .value + "\""')"

		hosttype="bp"
		values=$(get_value "$region_data" "$hosttype")
		parse_host_list "$config" "$region" "$values"

		hosttype="vr"
		values=$(get_value "$region_data" "$hosttype")
		parse_host_list "$config" "$region" "$values"

		hosttype="inst"
		values=$(get_value "$region_data" "$hosttype")
		parse_host_list "$config" "$region" "$values"
	done

	print_footer
	echo "Done"
}

#######################

usage() {
	echo "Generate iTerms2 Dynamic Profiles"
	echo "Usage: $0 <options>"
	echo " -i: input json file including host list"
	echo " -o: output iTerms2 Dynamic Profiles, default:iterms2-dynamic-profiles.json"
}

while getopts ":i:o:uh" opt; do
    case "${opt}" in
        i)
            in_json_file=${OPTARG}
            ;;
        o)
            output=${OPTARG}
            ;;
        *)
            usage
			exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${in_json_file}" ]; then
    usage
fi

main

echo "Open Finder and copy $output to $base_dir"
echo "Or run below: " 
echo "cp $output $base_dir"
echo 
