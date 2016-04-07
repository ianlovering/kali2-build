function show_message {
    title=$1
    desc=$2
    
        whiptail \
            --title "${title}" \
            --backtitle "restore" \
            --msgbox "${desc}" 0 0  \
            3>&2 2>&1 1>&3-
}

function abort {
	show_message "Abort" "Aborting restore. Will shutdown.\n"
	#shutdown now
	exit 1
}

function ask_yes_no {
    title=$1
    desc=$2
    
        whiptail \
            --title "${title}" \
            --backtitle "restore" \
            --yesno "${desc}" 0 0  \
            --defaultno \
            3>&2 2>&1 1>&3-
    result=$?
}

function get_input {
    title=$1
    desc=$2
    
    input=$(\
        whiptail \
            --title "${title}" \
            --backtitle "restore" \
            --passwordbox "${desc}" 0 0 \
            3>&2 2>&1 1>&3-)
}

function show_menu {
    title=$1
    desc=$2
    items=$3
    
    result=$(\
        whiptail \
            --title "${title}" \
            --backtitle "restore" \
            --menu "${desc}" 0 0 0 \
            "${@:3}" \
            3>&2 2>&1 1>&3-)
}

function find_disk_dev {

    disk_id=$1
    disk_dev=
    disk_full_id=
    if [ "x${disk_id}" != 'x' ]; then
        disk_dev=$(ls -la /dev/disk/by-id/ | grep $disk_id | awk '$11 ~/sd.$/ && $9 ~/^(ata|usb)./ { gsub("../../","/dev/",$11); print $11; exit }')
        disk_full_id=$(ls -la /dev/disk/by-id/ | grep $disk_id | awk '$11 ~/sd.$/ && $9 ~/^(ata|usb)./ { print $9; exit }')
    fi
}

function select_restore_type {
    i=0
    s=1

    type[0]="WDN"
    type[1]="Whole Disk (no encryption)"
    type[2]="WDL"
    type[3]="Whole Disk (luks encryption)"
    type[4]="WDS"
    type[5]="Whole Disk (sed encryption)"
    type[6]="EF"
    type[7]="Existing Filesystem"
          
    show_menu "Select Restore Type" "Select the restore type:" "${type[@]}"
}

function select_disk {
    i=0
    s=1
    #for d in $(ls -la /dev/disk/by-id | awk '$11 ~/sd.$/ && $9 ~/^(ata|usb)-/ { print $9 }')
    for d in $(ls /dev/sd? | xargs -n 1)
    do
        disks[i]=$d
        disks[i+1]=""
        ((i+=2))
    done
          
    show_menu "Select Disk" "Select the disk to use:" "${disks[@]}"
}

function select_target {
    i=0
    s=1
    #for d in $(ls -la /dev/disk/by-id | awk '$11 ~/sd.$/ && $9 ~/^(ata|usb)-/ { print $9 }')
    for d in $(ls /dev/sd* | xargs -n 1)
    do
        disks[i]=$d
        disks[i+1]="blank"
        ((i+=2))
    done
          
    show_menu "Select Target" "Select the disk or partition to use:" "${disks[@]}"
    #diskno=${result}
    #find_disk_dev ${disks[diskno*2-1]}
}

function select_volume {
	title=${1}
	desc=${2}
	i=0
	for v in $(ls /dev/mapper/* | xargs -n 1 | grep -v crypt-main | grep -v control)
	do
		vols[i]=$v
		vols[i+1]="blank"
		((i+=2))
	done
    show_menu "$title" "$desc" "${vols[@]}"	
}

function select_part {
	title=${1}
	desc=${2}
	i=0
	for p in $(ls /dev/sd* | xargs -n 1 | grep '[0-9]')
	do
		parts[i]=$p
		parts[i+1]="blank"
		((i+=2))
	done
    show_menu "$title" "$desc" "${parts[@]}"	
}

function select_image {
	title="Select Image"
	desc="Select the image file to restore."
	imagedir=${1}
	i=0
	for img in $(ls ${imagedir} | xargs -n 1 )
	do
		images[i]=$img
		images[i+1]=""
		((i+=2))
	done
    show_menu "$title" "$desc" "${images[@]}"	
}

function is_disk {
	dev=$1
	[[ $dev =~ ^/dev/sd[a-z]$ ]]
	result=$?
}

function partition_disk {

	target_disk=$1
	sgdisk -Z $target_disk
    sgdisk \
        -n 1:0:+2M -t 1:EF02 -c 1:"BIOS Boot" \
        -n 2:0:0 -c 2:"Main" \
        $target_disk
    sfdisk -A1 $target_disk
}

function partition_disk_nocrypt {

	target_disk=$1
	sgdisk -Z $target_disk
    sgdisk \
        -n 1:0:+2M -t 1:EF02 -c 1:"BIOS Boot" \
        -n 2:0:+1G -c 2:"Swap" \
        -n 3:0:0 -c 3:"Linux" \
        $target_disk
    sfdisk -A1 $target_disk
}

function create_crypt {
	target_encrypt=$1
	pass=$2
	echo -n $pass | cryptsetup -q luksFormat $target_encrypt -
}

function open_crypt {
	target_encrypt=$1
	pass=$2
	name=$3
    echo -n $pass | cryptsetup -q luksOpen --key-file="-" $target_encrypt $name
}

function close_crypt {
	name=$1
	cryptsetup luksClose ${name}
}

function create_logical_volumes {
	pvol=$1
	vgroup=$2
	lvswap=$3
	lvroot=$4
	swap_size=4G

    pvcreate $pvol
    vgcreate $vgroup $pvol
    lvcreate -L $swap_size -n $lvswap $vgroup
    lvcreate -l 100%FREE -n $lvroot $vgroup
}

function mount_chroot_dynamic {
	root_mnt=$1

    mount --bind /proc $root_mnt/proc
    mount --bind /dev $root_mnt/dev
    mount --bind /sys $root_mnt/sys
}

function umount_chroot_dynamic {
	root_mnt=$1

    umount $root_mnt/proc
    umount $root_mnt/dev
    umount $root_mnt/sys
}

function update_fstab {

	root_mnt=$1
	swap_dev=$3
	
    target_swap_uuid=$(blkid $swap_dev | awk -F\" '{ print $2 }')    
    sed -i "s/UUID=.*\(\s.*none\s.*swap\)/UUID=$target_swap_uuid\1/" $root_mnt/etc/fstab
}

function update_crypttab {

	root_mnt=$1
	crypt_dev=$2
	crypt_name=$3
	
    target_encrypt_uuid=$(blkid $crypt_dev | awk -F\" '{ print $2 }')
    
    echo -e "${crypt_name}\tUUID=${target_encrypt_uuid}\tnone\tluks" > $root_mnt/etc/crypttab
}

function update_boot {

	root_mnt=$1
	root_fs=$2
	
	#get_disk $root_fs
	
	mount_chroot_dynamic ${root_mnt}

chroot ${root_mnt} <<EOF
update-initramfs -u
update-grub
grub-install /dev/sda
EOF
}

function setup_module_run {
	root_mnt=$1
	selected_profile=${2}
	SCRIPTS="restore_control.sh mount_share.sh"

	for s in ${SCRIPTS}; do
		cp ${s} $root_mnt/root
		chmod 755 ${root_mnt}/root/${s}
	done

	echo "gnome-terminal -x /root/restore_control.sh $2" >> $root_mnt/root/.profile
	sed -i 's/# *AutomaticLogin/AutomaticLogin/' $root_mnt/etc/gdm3/daemon.conf
	
}
