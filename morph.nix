let
  # Pin the deployment package-set to a specific version of nixpkgs
  # update with nix-prefetch-url --unpack <URL>
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b2ac9a1aff916bf323b256405aab121f74555232.tar.gz";
    sha256 = "1lnxrr4xnw29mw8gxwdg9f110682df8rs1kr2360di8y5smsharb";
  };

  srkNurPinned = builtins.fetchTarball {
    url = "https://github.com/sorki/nur-expressions/archive/07bea27864ae90a091af7aca282ce955c01c5d60.tar.gz";
    sha256 = "1py84mh3sxfpby3w6qp2zprrzi1nkvnsir1kl53yv1yffs3hw9nh";
  };

  srkNurLocal = ~/git/nur/srk-nur-expressions;
  srkNur = srkNurPinned;
in
{
  network =  {
    #pkgs = import <nixpkgs> { };
    pkgs = import nixpkgs { };
    description = "hexamontech hosts";
  };

  vm0 = { config, pkgs, ... }: {

    nix.nixPath = [
      "nixpkgs=${nixpkgs}"
      "nixpkgs-overlays=${srkNur}/overlays/nixpkgs-overlays.nix"
    ];

    nixpkgs.overlays = (import srkNur {}).overlays.all;
    imports = [
      ./env.nix
      ./profiles/qemu.nix
      ./machines/vm0.nix
    ] ++ (import srkNur {}).modules.all;

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/198941ca-7375-45d9-825f-151d502def59";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/72408f49-8dfa-4512-95e1-888fda6f961c";
        fsType = "ext4";
      };
  };
}
