{ config, pkgs, ... }:
let
  vimCustom = (pkgs.vimUtils.makeCustomizable pkgs.vim).customize {
    name = "vim";
    vimrcConfig = {
      customRC = ''
        runtime vimrc

        set mouse=
        if has("autocmd")
          au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ vim-nix ];
      };
    };
  };
in
{
  time.timeZone = "Europe/Amsterdam";
  # networking.nameservers = [ ];
  services.openssh.enable = true;
  nix.useSandbox = true;
  nix.buildCores = 0;
  systemd.tmpfiles.rules = [ "d /tmp 1777 root root 7d" ];

  environment.systemPackages = with pkgs; [
    htop
    screen
    vimCustom
    wget
    git
  ];

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ adluc srk ];

  system.stateVersion = "20.09";
}
