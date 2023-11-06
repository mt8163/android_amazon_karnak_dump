#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery:13219840:0e7bd4eb26fec982f027afb9173f7ce631ae1882; then
  applypatch  EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/boot:7809024:5cd50925698225833d3a34e207fb1c3a6af83dd5 EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery bca83722ae0a31e7ab5b18921675bdacd49444f9 13217792 5cd50925698225833d3a34e207fb1c3a6af83dd5:/system/recovery-from-boot.p && installed=1 && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  [ -n "$installed" ] && dd if=/system/recovery-sig of=/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery bs=1 seek=13217792 && sync && log -t recovery "Install new recovery signature: succeeded" || log -t recovery "Installing new recovery signature: failed"
else
  log -t recovery "Recovery image already installed"
fi
