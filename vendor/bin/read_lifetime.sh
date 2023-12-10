#!/vendor/bin/sh
#
# Copyright (c) 2019 - 2023 Amazon.com, Inc. or its affiliates.  All rights reserved.
#
# PROPRIETARY/CONFIDENTIAL.  USE IS SUBJECT TO LICENSE TERMS.

# Need to check for 72 Mb written for certain Hynix part numbers like H8G4a2 before
# reading correct lifetime value
READ_LIFETIME_CHECK="/vendor/bin/read_lifetime_check.sh"

# Get the eMMC block device node
# At this time, we're assuming that there's only one eMMC device.
# In the case that there are multiple, we'll just report lifetime metrics on
# the first one.
# Tablet devices may have SD cards attached, which will also be a sysfs block
# device node. Make sure to choose the eMMC device node. The scr node only
# exists for SD cards.
for i in 0 1 2 3 4
do
  if [ -e "/sys/block/mmcblk$i" ] && [ ! -e "/sys/block/mmcblk$i/device/scr" ]; then
    emmc_device="mmcblk$i"
    break
  fi
done

# Exit with error if no valid sysfs eMMC node is found
if [ "$emmc_device" = "" ]; then
  echo "read_lifetime.sh failed, no valid sysfs eMMC node"
  exit 1
fi

lifetime_file_name="/sys/block/$emmc_device/device/life_time";
pre_eol_info_file_name="/sys/block/$emmc_device/device/pre_eol_info";
manfid_file_name="/sys/block/$emmc_device/device/manfid";

pre_eol_info=$(<$pre_eol_info_file_name)
manfid=$(<$manfid_file_name)

lifetime_ready=1
# Workaround for Hynix eMMC.  Return 1 if ready, 0 otherwise
if [ -f $READ_LIFETIME_CHECK ] && [ -x $READ_LIFETIME_CHECK ]; then
  $READ_LIFETIME_CHECK $manfid
  lifetime_ready=$?
fi

if [ "$lifetime_ready" == 1 ]; then
  lifetime_info=$(<$lifetime_file_name)
  lifetime="${lifetime_info} ${pre_eol_info} ${manfid}"
  setprop sys.amzn_bsp_diag.emmc_lifetime "$lifetime"
fi
