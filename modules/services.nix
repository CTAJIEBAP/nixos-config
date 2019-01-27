{config, lib, pkgs, ...}:
{

  services.acpid.enable = true;


  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 100;
  };

  services.printing = {
    enable = config.device == "Lenovo-Workstation";
    drivers = [ pkgs.gutenprint ];
  };
  programs.dconf.enable = true;  

  services.tor = {
    enable = true;
    client.enable = true;
    client.privoxy.enable = true;
    torsocks.enable = true;
  };
  #services.teamviewer.enable = true;


  services.avahi.enable = true;

  systemd.services.systemd-udev-settle.enable = false;

  services.upower.enable = true;
  virtualisation.virtualbox.host = {
    enable = config.deviceSpecific.isHost;
    enableHardening = false;
  };

}
