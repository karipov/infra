{ config, lib, ... }:

let
  # 7.3TB HDDs (by-id for stability)
  hddDevices = [
    "/dev/disk/by-id/ata-ST8000NM0045-1RL112_ZA1H18Z5"
    "/dev/disk/by-id/ata-ST8000NM0045-1RL112_ZA1H1FFV"
    "/dev/disk/by-id/ata-ST8000NM0045-1RL112_ZA1H1JQX"
    "/dev/disk/by-id/ata-ST8000NM0045-1RL112_ZA1H1KES"
  ];
in
{
  # btrfs filesystems for storage pools
  fileSystems."/mnt/fast" = {
    device = "/dev/disk/by-label/nvme-storage";
    fsType = "btrfs";
    options = [ "subvol=fast" "defaults" "noatime" ];
  };

  fileSystems."/mnt/prime" = {
    device = "/dev/disk/by-label/nvme-storage";
    fsType = "btrfs";
    options = [ "subvol=prime" "defaults" "noatime" ];
  };

  fileSystems."/mnt/slow" = {
    device = "/dev/disk/by-label/hdd-storage";
    fsType = "btrfs";
    options = [ "subvol=slow" "defaults" "noatime" ];
  };

  # ensure mount points exist
  systemd.tmpfiles.rules = [
    "d /mnt/fast 0755 root root -"
    "d /mnt/prime 0755 root root -"
    "d /mnt/slow 0755 root root -"
  ];

  # export HDD devices so base module can configure hdparm
  hardware.hddSpindownDevices = hddDevices;
}

