{pkgs, config, lib, ...}:
with import ../../support.nix {inherit lib config;};
{
  home-manager.users.balsoft.xdg.configFile."flaska.net/trojita.conf".text = if ! isNull config.secrets.gmail then  genIni {
        General = {
          "app.updates.checkEnabled" = false;
          "imap.auth.user" = config.secrets.gmail.user;
          "imap.auth.pass" = config.secrets.gmail.password;
          "imap.host" = "imap.gmail.com";
          "imap.method" = "SSL";
          "imap.needsNetwork" = true;
          "imap.numberRefreshInterval" = 300;
          "imap.port" = 993;
          "imap.proxy.system" = true;
          "imap.starttls" = true;
          "imapIdleRenewal" = 29;
          "msa.method" = "SMTP";
          "msa.smtp.auth" = true;
          "msa.smtp.auth.reuseImapCredentials" = true;
          "msa.smtp.burl" = false;
          "msa.smtp.host" = "smtp.gmail.com";
          "msa.smtp.port" = 587;
          "msa.smtp.starttls" = true;
          "offline.cache" = "days";
          "offline.cache.numDays" = "30";
        };
        autoMarkRead = { 
          enabled = true;
          seconds = 0;
        };
        composer = {
          imapSentName = "Sent";
          saveToImapEnabled = false;
        };
        gui = {
          "mainWindow.layout" = "compact";
          preferPlaintextRendering = true;
          showSystray = false;
          startMinimized = false;
        };
        identities = {
          "1\\address" = "${config.secrets.gmail.user}@gmail.com";
          "1\\organisation" = "";
          "1\\realName" = "Alexander Bantyev";
          "1\\signature" = "";
          size = 1;
        };
        interoperability.revealVersions = true;
        plugin = {
          addressbook = "abookaddressbook";
          password = "cleartextpassword";
        };
      } else "";
}
