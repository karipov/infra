{ config, pkgs, ... }:

{
  # enable OpenGL and Intel QuickSync hardware acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver       # Intel's VAAPI driver for newer GPUs
      intel-vaapi-driver       # VAAPI driver for older Intel GPUs
      libva-vdpau-driver       # VAAPI VDPAU backend
      libvdpau-va-gl           # VDPAU driver with OpenGL/VAAPI backend
      intel-compute-runtime    # OpenCL support for hardware tone-mapping and subtitle burn-in
      vpl-gpu-rt               # QSV support for 11th gen Intel GPUs and newer
    ];
  };

  services.jellyfin = {
    enable = true;
  };

  # open firewall ports for local access to Jellyfin
  # external access is also available via Caddy reverse proxy at watch.komron.me
  networking.firewall.allowedTCPPorts = [ 8096 8920 ];

  # create a media group for shared access between users and Jellyfin
  # host-specific configuration should add users and configure directories
  users.groups.media = {};
  # add jellyfin user to video and render groups for GPU access
  users.users.jellyfin.extraGroups = [ "media" "video" "render" ];
}

