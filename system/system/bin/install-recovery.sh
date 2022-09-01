#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery:13215744:67e31f7b0e6b3155ec7dfc6a35f62165413eec05; then
  applypatch  EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/boot:7806976:d4d85a5f0397aabfb8b1f83f0bef6ebee5827dd2 EMMC:/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery 45b9a955062b0cc1b40a886177d59e22234116bc 13213696 d4d85a5f0397aabfb8b1f83f0bef6ebee5827dd2:/system/recovery-from-boot.p && installed=1 && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  [ -n "$installed" ] && dd if=/system/recovery-sig of=/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/recovery bs=1 seek=13213696 && sync && log -t recovery "Install new recovery signature: succeeded" || log -t recovery "Installing new recovery signature: failed"
else
  log -t recovery "Recovery image already installed"
fi
