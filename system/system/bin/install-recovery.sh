#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery:13228032:cffaffe0ca95148f4c4bff301d8ca492a3f8dc1f; then
  applypatch  EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/boot:7815168:89f2378202edb81c51edf15d5dac291614ee97ac EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery e4c164c3029dd9bcdf45fbb8a9f0cba5c133feec 13225984 89f2378202edb81c51edf15d5dac291614ee97ac:/system/recovery-from-boot.p && installed=1 && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  [ -n "$installed" ] && dd if=/system/recovery-sig of=/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery bs=1 seek=13225984 && sync && log -t recovery "Install new recovery signature: succeeded" || log -t recovery "Installing new recovery signature: failed"
else
  log -t recovery "Recovery image already installed"
fi
