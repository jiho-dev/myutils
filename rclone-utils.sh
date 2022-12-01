#!/bin/bash

#sync_dirs="mac-settings ssh-keys"
sync_dirs="tmp"

rclone-upload() {
	for name in ${sync_dirs}; do
		# upload
		echo "### Upload ${name}"
		rclone -P copy /home/jiho.jung/joyent-google-drive/${name} joyent-google-drive:/${name}
	done
}

rclone-download() {
	for name in ${sync_dirs}; do
		# download
		echo "### Download ${name}"
		rclone -P copy joyent-google-drive:/${name} /home/jiho.jung/joyent-google-drive/${name}
	done
}


