{ config, lib, ... }:

{
  # Btrfs filesystems for storage volumes
  # These will be mounted after initial formatting (see setup instructions)

  # NVMe SSDs: RAID1 mirror (2x 1TB = ~1TB usable)
  # Device paths: nvme0n1, nvme1n1
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

  # HDDs: Single copy data, RAID1 metadata (4x 7.3TB = ~29.2TB usable)
  # Device paths: sdb, sdd, sde, sdf
  fileSystems."/mnt/slow" = {
    device = "/dev/disk/by-label/hdd-storage";
    fsType = "btrfs";
    options = [ "subvol=slow" "defaults" "noatime" ];
  };

  # Ensure mount points exist
  systemd.tmpfiles.rules = [
    "d /mnt/fast 0755 root root -"
    "d /mnt/prime 0755 root root -"
    "d /mnt/slow 0755 root root -"
  ];
}

