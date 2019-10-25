{ pkgs, ... }:
{
  environment.shellAliases = {
    psc = "ps xawf -eo pid,user,cgroup,args";
  };
}
