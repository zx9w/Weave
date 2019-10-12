{ pkgs, ... }:
{
  # Remind me about shit by piping into 'at now + <number> minutes'
  services.atd.enable = true;

  # Best-ish way to search for namespaced packages
  environment.shellAliases.nixi = "nix repl '<nixpkgs>'";

  # Enable documentation
  documentation.man.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}
