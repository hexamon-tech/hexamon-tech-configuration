{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
  ];

  users.users.srk = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
  };

  users.users.srk.extraGroups = [ ];
  users.users.srk.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ srk ];

  services.emci = {
    enable = true;
    conf = "https://raw.githubusercontent.com/distrap/meta/master/distrap.dhall";
  };

  services.ircbridge = {
    enable = true;
    instances = {
      freenode.irc = {
        nick = "bot-one";
        host = "irc.freenode.net";
        port = 6667;
        channels = [ "#distrap" "#nixpkgs-commits" "#emci-spam" ];
      };
    };
  };

  # backends
  my.services.amqp.enable = true;

  services.zre = {
    enable = true;
    globalConfig = true;
    gossip.enable = true;

    # XXX: needed?
    openFirewall = true;
    gossip.openFirewall = true;

    # IRC notifications
    services = [
      { name = "gp-zre2irc";
        exe = ''
          ${pkgs.haskellPackages.git-post-receive-zre2irc}/bin/git-post-receive-zre2irc \
            --chan "#distrap"
        '';
      }
    ];
  };
}
