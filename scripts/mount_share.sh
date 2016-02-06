#!/bin/bash

MNT=${1}

SMB_SHARE=//build/images
SMB_USER=clonewrite
SMB_PASS=clonewrite

# Mount build / deploy files
while ! mount | grep -q "${MNT}"; do
	sleep 2
	mount -o username=${SMB_USER},password=${SMB_PASS} -t cifs ${SMB_SHARE} ${MNT}
done

