{ pkgs, ... }:
{
  environment.shellAliases = {
    psc = "ps xawf -eo pid,user,cgroup,args";
    pscl = "ps xawf -eo pid,user,cgroup,args | less -S";
  };
}
