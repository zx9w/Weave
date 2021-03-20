{ pkgs, ... }:
{
  # Enable Virtualisation
  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
  };

  # Containers for programming environments
  # This is an experiment!
  containers.rust = {
    config =
      { config, pkgs, ... }:
      {
        services.postgresql = {
          enable = true;
          package = pkgs.postgresql96;
        };
        nixpkgs.config = {
          allowunfree = true;
        };
        environment.systemPackages = with pkgs; [
          wget curl vim emacs git zlib tmux
          xfontsel xlsfonts xclip
          ripgrep which binutils gcc gnumake
	  openssl pkgconfig
        ];
      };
   };
}
