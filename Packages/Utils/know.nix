{ pkgs, todofilepath }:

pkgs.writeShellScriptBin "know" ''
  date
  ${pkgs.acpi}/bin/acpi \
  | ${pkgs.gawk}/bin/awk -F " " '{print $3, $4, $5, $6}' \
  | ${pkgs.gnused}/bin/sed "s/charging/C/g"
  if [ $(/run/wrappers/bin/ping -c 1 8.8.8.8 | ${pkgs.ripgrep}/bin/rg "1 received" | ${pkgs.coreutils}/bin/wc -l) = 1 ]; then
    ${pkgs.networkmanager}/bin/nmcli connection show | ${pkgs.ripgrep}/bin/rg wlp | ${pkgs.gawk}/bin/awk -F ' ' '{print "Wifi: "  $1}'
  fi
  echo
  head -5 ${todofilepath}
''
