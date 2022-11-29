import awsipranges
import re
import sys

# https://github.com/aws-samples/awsipranges

print("Download aws ip file...")

#aws_ip_ranges = awsipranges.get_ranges(cafile="amazon_root_certificates.pem")
aws_ip_ranges = awsipranges.get_ranges()

ip_list = []
file_name = sys.argv[1]

print("")
print("Check IPs: " + file_name)
with open(sys.argv[1]) as filename:
    for line in filename:
        line = line.rstrip()
        if line in aws_ip_ranges:
            info = aws_ip_ranges[line]
            print('%s: %s/%s' %(line, info.network_address, info.netmask))
            ip_list.append(info)

print("")
print("=== output ===")
for ipinfo in set(ip_list):
    print('route %s %s' %(ipinfo.network_address, ipinfo.netmask))


